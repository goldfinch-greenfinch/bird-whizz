import os
import re
import azure.cognitiveservices.speech as speechsdk
from dotenv import load_dotenv

# Configuration
INPUT_DIR = r"lib\data\sections"
OUTPUT_DIR_QUESTIONS = r"assets\audio\questions"
OUTPUT_DIR_ANSWERS = r"assets\audio\answers"
VOICE_NAME = "en-GB-OllieMultilingualNeural"

def sanitize_filename(text):
    # Remove invalid chars, lower case, replace spaces with underscores, limit length
    safe_text = re.sub(r'[^\w\s-]', '', text).strip().lower()
    safe_text = re.sub(r'[\s-]+', '_', safe_text)
    return safe_text[:50] # Limit length to avoid path issues

def ensure_dir(directory):
    if not os.path.exists(directory):
        os.makedirs(directory)

def parse_dart_data(file_path):
    with open(file_path, 'r', encoding='utf-8') as f:
        content = f.read()

    # Find all Question blocks
    # This regex looks for Question( ... ) and captures the content inside
    # We use a non-greedy match for the content to process one by one
    # Note: Regex parsing code is fragile if code structure changes, but works for the current rigid format
    
    questions = []
    
    # Split content by "Question(" to get chunks
    chunks = content.split('Question(')
    
    for chunk in chunks[1:]: # Skip the first chunk which is before the first Question
        question_data = {}
        
        # Extract text
        # distinct text: '...' or text: "..."
        # Handle escaped quotes: (['"]) captures quote. ((?:\\\1|.)*?) captures content allowing escaped quote. \1 matches closing.
        text_match = re.search(r"text:\s*(['\"])((?:\\\1|.)*?)\1,", chunk, re.DOTALL)
        if text_match:
            raw_text = text_match.group(2)
            quote_char = text_match.group(1)
            # Unescape the quote char
            cleaned_text = raw_text.replace('\\' + quote_char, quote_char)
            question_data['text'] = cleaned_text.replace('\n', ' ').strip()
        
        # Extract options
        # options: ['...', '...']
        options_match = re.search(r"options:\s*\[(.*?)\]", chunk, re.DOTALL)
        if options_match:
            options_str = options_match.group(1)
            # Find all quoted strings inside the list
            opts = re.findall(r"(['\"])((?:\\\1|.)*?)\1", options_str)
            # Unescape quotes
            question_data['options'] = [o[1].replace('\\' + o[0], o[0]).strip() for o in opts]
            
        if 'text' in question_data and 'options' in question_data:
            questions.append(question_data)
            
    return questions

def synthesize_audio(text, output_path, speech_config):
    if os.path.exists(output_path):
        print(f"Skipping (exists): {output_path}")
        return

    print(f"Synthesizing: '{text}' -> {output_path}")
    
    audio_config = speechsdk.audio.AudioOutputConfig(filename=output_path)
    synthesizer = speechsdk.SpeechSynthesizer(speech_config=speech_config, audio_config=audio_config)
    
    result = synthesizer.speak_text_async(text).get()

    if result.reason == speechsdk.ResultReason.SynthesizingAudioCompleted:
        # print("Success")
        pass
    elif result.reason == speechsdk.ResultReason.Canceled:
        cancellation_details = result.cancellation_details
        print(f"Failed: {cancellation_details.reason}")
        if cancellation_details.reason == speechsdk.CancellationReason.Error:
            print(f"Error: {cancellation_details.error_details}")

def main():
    load_dotenv()
    speech_key = os.getenv('SPEECH_KEY')
    service_region = os.getenv('SPEECH_REGION')
    
    if not speech_key or not service_region:
        print("Error: Missing credentials in .env")
        return

    # Setup Speech Config
    speech_config = speechsdk.SpeechConfig(subscription=speech_key, region=service_region)
    speech_config.speech_synthesis_voice_name = VOICE_NAME
    speech_config.set_speech_synthesis_output_format(speechsdk.SpeechSynthesisOutputFormat.Audio16Khz32KBitRateMonoMp3)

    # Setup Directories
    ensure_dir(OUTPUT_DIR_QUESTIONS)
    ensure_dir(OUTPUT_DIR_ANSWERS)

    # Get all dart files
    dart_files = [f for f in os.listdir(INPUT_DIR) if f.endswith('_data.dart')]
    print(f"Found {len(dart_files)} data files in {INPUT_DIR}")

    all_questions = []
    
    for filename in dart_files:
        file_path = os.path.join(INPUT_DIR, filename)
        print(f"Parsing {filename}...")
        questions = parse_dart_data(file_path)
        print(f"  Found {len(questions)} questions in {filename}")
        all_questions.extend(questions)
        
    print(f"Total questions found: {len(all_questions)}")

    # Process
    unique_answers = set()
    
    for i, q in enumerate(all_questions):
        # 1. Process Question
        q_text = q['text']
        q_filename = sanitize_filename(q_text) + ".mp3"
        q_path = os.path.join(OUTPUT_DIR_QUESTIONS, q_filename)
        
        synthesize_audio(q_text, q_path, speech_config)
        
        # 2. Process Options (Answers)
        for opt in q['options']:
            if opt not in unique_answers:
                unique_answers.add(opt)
                
                opt_filename = sanitize_filename(opt) + ".mp3"
                opt_path = os.path.join(OUTPUT_DIR_ANSWERS, opt_filename)
                
                synthesize_audio(opt, opt_path, speech_config)
            
    print("Done!")

if __name__ == "__main__":
    main()
