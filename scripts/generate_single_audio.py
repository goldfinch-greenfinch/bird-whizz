import os
import re
import azure.cognitiveservices.speech as speechsdk
from dotenv import load_dotenv

# Configuration
OUTPUT_DIR_QUESTIONS = r"assets\audio\questions"
OUTPUT_DIR_ANSWERS = r"assets\audio\answers"
VOICE_NAME = "en-GB-OllieMultilingualNeural"

# Target Question
TARGET_QUESTION_ID = "l1q1"
TARGET_QUESTION_TEXT = "Which bird is the fastest diver in the sky?"
TARGET_QUESTION_OPTIONS = ["Peregrine Falcon", "Eagle", "Sparrow", "Chicken"]

def sanitize_filename(text):
    # Remove invalid chars, lower case, replace spaces with underscores, limit length
    safe_text = re.sub(r'[^\w\s-]', '', text).strip().lower()
    safe_text = re.sub(r'[\s-]+', '_', safe_text)
    return safe_text[:50] # Limit length to avoid path issues

def ensure_dir(directory):
    if not os.path.exists(directory):
        os.makedirs(directory)

def synthesize_audio(text, output_path, speech_config):
    if os.path.exists(output_path):
        print(f"Skipping (exists): {output_path}")
        return

    print(f"Synthesizing: '{text}' -> {output_path}")
    
    audio_config = speechsdk.audio.AudioOutputConfig(filename=output_path)
    synthesizer = speechsdk.SpeechSynthesizer(speech_config=speech_config, audio_config=audio_config)
    
    result = synthesizer.speak_text_async(text).get()

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
    speech_config.speech_synthesis_voice_name = VOICE_NAME
    speech_config.set_speech_synthesis_output_format(speechsdk.SpeechSynthesisOutputFormat.Audio16Khz32KBitRateMonoMp3)

    # Setup Directories
    ensure_dir(OUTPUT_DIR_QUESTIONS)
    ensure_dir(OUTPUT_DIR_ANSWERS)

    print(f"Processing ONLY Target Question: {TARGET_QUESTION_ID}")

    # 1. Process Question
    q_filename = sanitize_filename(TARGET_QUESTION_TEXT) + ".mp3"
    q_path = os.path.join(OUTPUT_DIR_QUESTIONS, q_filename)
    synthesize_audio(TARGET_QUESTION_TEXT, q_path, speech_config)
    
    # 2. Process Options (Answers)
    for opt in TARGET_QUESTION_OPTIONS:
        opt_filename = sanitize_filename(opt) + ".mp3"
        opt_path = os.path.join(OUTPUT_DIR_ANSWERS, opt_filename)
        synthesize_audio(opt, opt_path, speech_config)
        
    print("Done!")

if __name__ == "__main__":
    main()
