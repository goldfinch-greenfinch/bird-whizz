import os
import re
import azure.cognitiveservices.speech as speechsdk
from dotenv import load_dotenv

# Configuration
INPUT_DIR = r"lib\data\sections"
OUTPUT_DIR = r"assets\audio\question_answers"
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
    questions = []
    
    # Split content by "Question(" to get chunks
    chunks = content.split('Question(')
    
    for chunk in chunks[1:]: # Skip the first chunk
        question_data = {}
        
        # Extract text
        text_match = re.search(r"text:\s*(['\"])((?:\\\1|.)*?)\1,", chunk, re.DOTALL)
        if text_match:
            raw_text = text_match.group(2)
            quote_char = text_match.group(1)
            cleaned_text = raw_text.replace('\\' + quote_char, quote_char)
            question_data['text'] = cleaned_text.replace('\n', ' ').strip()
        
        # Extract options
        options_match = re.search(r"options:\s*\[(.*?)\]", chunk, re.DOTALL)
        if options_match:
            options_str = options_match.group(1)
            opts = re.findall(r"(['\"])((?:\\\1|.)*?)\1", options_str)
            question_data['options'] = [o[1].replace('\\' + o[0], o[0]).strip() for o in opts]
            
        if 'text' in question_data and 'options' in question_data:
            questions.append(question_data)
            
    return questions

def generate_ssml(text, options, voice_name):
    # Escape XML special chars in text
    def escape_xml(s):
        return s.replace('&', '&amp;').replace('<', '&lt;').replace('>', '&gt;').replace('"', '&quot;').replace("'", '&apos;')
    
    ssml = f'<speak version="1.0" xmlns="http://www.w3.org/2001/10/synthesis" xml:lang="en-US">'
    ssml += f'<voice name="{voice_name}">'
    ssml += f'{escape_xml(text)}'
    ssml += '<break time="700ms" />' # Pause between question and answers
    
    for i, opt in enumerate(options):
        ssml += f'{escape_xml(opt)}'
        if i < len(options) - 1:
             ssml += '<break time="300ms" />' # Pause between answers
             
    ssml += '</voice></speak>'
    return ssml

def synthesize_ssml(ssml, output_path, speech_config):
    print(f"Synthesizing to: {output_path}")
    
    audio_config = speechsdk.audio.AudioOutputConfig(filename=output_path)
    synthesizer = speechsdk.SpeechSynthesizer(speech_config=speech_config, audio_config=audio_config)
    
    result = synthesizer.speak_ssml_async(ssml).get()

    if result.reason == speechsdk.ResultReason.SynthesizingAudioCompleted:
        print("Success")
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
    speech_config.set_speech_synthesis_output_format(speechsdk.SpeechSynthesisOutputFormat.Audio16Khz32KBitRateMonoMp3)

    ensure_dir(OUTPUT_DIR)

    # Get dart files
    dart_files = [f for f in os.listdir(INPUT_DIR) if f.endswith('_data.dart')]
    print(f"Found {len(dart_files)} data files.")

    count = 0
    for filename in dart_files:
        file_path = os.path.join(INPUT_DIR, filename)
        print(f"Parsing {filename}...")
        questions = parse_dart_data(file_path)
        
        for q in questions:
            # Generate filename
            safe_name = sanitize_filename(q['text']) + ".mp3"
            output_path = os.path.join(OUTPUT_DIR, safe_name)
            
            if os.path.exists(output_path):
                print(f"Skipping (exists): {safe_name}")
                continue

            print(f"Processing: {q['text'][:30]}...")
            ssml = generate_ssml(q['text'], q['options'], VOICE_NAME)
            synthesize_ssml(ssml, output_path, speech_config)
            count += 1
            
    print(f"Done! Generated {count} new files.")

if __name__ == "__main__":
    main()
