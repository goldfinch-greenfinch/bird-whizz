import os
import re
import argparse
import azure.cognitiveservices.speech as speechsdk
from dotenv import load_dotenv

INPUT_DIR = r"lib\data\sections"
OUTPUT_DIR_QUESTIONS = r"assets\audio\questions"
OUTPUT_DIR_ANSWERS = r"assets\audio\answers"
VOICE_NAME = "en-GB-OllieMultilingualNeural"

def sanitize_filename(text):
    # Same logic as Question._sanitizeFilename in Dart
    safe_text = re.sub(r'[^\w\s-]', '', text).strip().lower()
    safe_text = re.sub(r'[\s-]+', '_', safe_text)
    return safe_text[:50]

def clean_text_for_speech(text):
    # Remove quotes and other awkward symbols to keep speech natural
    text = text.replace('"', '').replace("'", "")
    
    if "_" in text:
        text = text.replace("&", "&amp;").replace("<", "&lt;").replace(">", "&gt;")
        text = re.sub(r'_+', '<break time="1200ms" />', text)
        
        ssml = f'<speak version="1.0" xmlns="http://www.w3.org/2001/10/synthesis" xml:lang="en-GB">'
        ssml += f'<voice name="{VOICE_NAME}">{text}</voice>'
        ssml += '</speak>'
        return ssml

    return text

def ensure_dir(directory):
    if not os.path.exists(directory):
        os.makedirs(directory)

def parse_dart_data(file_path):
    with open(file_path, 'r', encoding='utf-8') as f:
        content = f.read()
    questions = []
    chunks = content.split('Question(')
    for chunk in chunks[1:]:
        question_data = {}
        # Parse text field
        text_match = re.search(r"text:\s*(['\"])((?:\\\1|.)*?)\1,", chunk, re.DOTALL)
        if text_match:
            raw_text = text_match.group(2)
            quote_char = text_match.group(1)
            cleaned_text = raw_text.replace('\\' + quote_char, quote_char)
            question_data['text'] = cleaned_text.replace('\n', ' ').strip()
        
        # Parse options list
        options_match = re.search(r"options:\s*\[(.*?)\]", chunk, re.DOTALL)
        if options_match:
            options_str = options_match.group(1)
            opts = re.findall(r"(['\"])((?:\\\1|.)*?)\1", options_str)
            question_data['options'] = [o[1].replace('\\' + o[0], o[0]).strip() for o in opts]
            
        if 'text' in question_data and 'options' in question_data:
            questions.append(question_data)
    return questions

def synthesize_audio(text, output_path, speech_config):
    if os.path.exists(output_path):
        return
    # print(f"Synthesizing: '{text}' -> {output_path}")
    audio_config = speechsdk.audio.AudioOutputConfig(filename=output_path)
    synthesizer = speechsdk.SpeechSynthesizer(speech_config=speech_config, audio_config=audio_config)
    
    if text.startswith("<speak"):
        result = synthesizer.speak_ssml_async(text).get()
    else:
        result = synthesizer.speak_text_async(text).get()
    
    if result.reason == speechsdk.ResultReason.Canceled:
        cancellation_details = result.cancellation_details
        print(f"Failed: {cancellation_details.reason}")
        if cancellation_details.reason == speechsdk.CancellationReason.Error:
            print(f"Error: {cancellation_details.error_details}")

def main():
    parser = argparse.ArgumentParser(description="Generate separate audio for questions and answers.")
    parser.add_argument('--run', action='store_true', help="Actually perform synthesis. Otherwise, performs a dry run.")
    args = parser.parse_args()

    load_dotenv()
    speech_key = os.getenv('SPEECH_KEY')
    service_region = os.getenv('SPEECH_REGION')
    
    if args.run and (not speech_key or not service_region):
        print("Error: Missing Azure credentials in .env file.")
        return

    speech_config = None
    if args.run:
        speech_config = speechsdk.SpeechConfig(subscription=speech_key, region=service_region)
        speech_config.speech_synthesis_voice_name = VOICE_NAME
        speech_config.set_speech_synthesis_output_format(speechsdk.SpeechSynthesisOutputFormat.Audio16Khz32KBitRateMonoMp3)

    ensure_dir(OUTPUT_DIR_QUESTIONS)
    ensure_dir(OUTPUT_DIR_ANSWERS)

    dart_files = [f for f in os.listdir(INPUT_DIR) if f.endswith('_data.dart')]
    all_questions = []
    print(f"Parsing {len(dart_files)} data files...")
    for filename in dart_files:
        file_path = os.path.join(INPUT_DIR, filename)
        all_questions.extend(parse_dart_data(file_path))

    unique_answers_filenames = set()
    total_chars_to_synthesize = 0

    print(f"\nStarting {'SYNTHESIS' if args.run else 'DRY RUN'}...")
    print(f"Total questions found: {len(all_questions)}")

    for q in all_questions:
        q_raw_text = q['text']
        q_filename = sanitize_filename(q_raw_text) + ".mp3"
        q_path = os.path.join(OUTPUT_DIR_QUESTIONS, q_filename)
        q_spoken_text = clean_text_for_speech(q_raw_text)

        # Process Question
        if not os.path.exists(q_path):
            total_chars_to_synthesize += len(q_spoken_text)
            print(f"  [Question] '{q_spoken_text}' -> {q_filename}")
            if args.run:
                synthesize_audio(q_spoken_text, q_path, speech_config)
        else:
            print(f"  [Question] Skipped (Exists) '{q_spoken_text}' -> {q_filename}")
        
        # Process Answer Options
        for opt in q['options']:
            opt_filename = sanitize_filename(opt) + ".mp3"
            
            # The normalised string acts as our collision check (saving space & computation)
            if opt_filename not in unique_answers_filenames:
                unique_answers_filenames.add(opt_filename)
                opt_path = os.path.join(OUTPUT_DIR_ANSWERS, opt_filename)
                opt_spoken_text = clean_text_for_speech(opt)

                if not os.path.exists(opt_path):
                    total_chars_to_synthesize += len(opt_spoken_text)
                    print(f"    [Answer] '{opt_spoken_text}' -> {opt_filename}")
                    if args.run:
                        synthesize_audio(opt_spoken_text, opt_path, speech_config)
                else:
                    print(f"    [Answer] Skipped (Exists) '{opt_spoken_text}' -> {opt_filename}")
    
    # Calculate limits and cost based on non-existing audio required
    FREE_TIER_LIMIT = 500_000
    cost_per_1M_chars = 16.00 # Approximate Standard neural voice rate
    
    print("\n" + "="*40)
    print("COST CALCULATION REPORT")
    print("="*40)
    print(f"Total new characters to synthesize: {total_chars_to_synthesize}")
    
    if total_chars_to_synthesize <= FREE_TIER_LIMIT:
        print(f"Status: Safe within Free Tier boundary ({FREE_TIER_LIMIT:,} characters/month).")
        print("Estimated Cost: $0.00")
    else:
        chargeable_chars = total_chars_to_synthesize - FREE_TIER_LIMIT
        estimated_cost = (chargeable_chars / 1_000_000) * cost_per_1M_chars
        print(f"WARNING: Exceeds the free tier limit by {chargeable_chars:,} characters!")
        print(f"Estimated Cost: ${estimated_cost:.2f}")
    
    if not args.run:
        print("\n[Dry run complete. No audio was generated or network calls executed.]")
        print("To generate the audio exactly, please re-run the script with the '--run' flag.")

if __name__ == '__main__':
    main()
