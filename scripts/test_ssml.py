import os
import azure.cognitiveservices.speech as speechsdk
from dotenv import load_dotenv

load_dotenv()
speech_key = os.getenv("SPEECH_KEY")
service_region = os.getenv("SPEECH_REGION")

speech_config = speechsdk.SpeechConfig(subscription=speech_key, region=service_region)
speech_config.set_speech_synthesis_output_format(speechsdk.SpeechSynthesisOutputFormat.Audio16Khz32KBitRateMonoMp3)

ssml = """<speak version="1.0" xmlns="http://www.w3.org/2001/10/synthesis" xml:lang="en-GB">
    <voice name="en-GB-OllieMultilingualNeural">
        Fill in the blank <break time="800ms" /> Parrots are famous because they can <break time="1500ms" /> human speech.
    </voice>
</speak>"""

audio_config = speechsdk.audio.AudioOutputConfig(filename="assets/audio/test_blank_ssml.mp3")
synthesizer = speechsdk.SpeechSynthesizer(speech_config=speech_config, audio_config=audio_config)
synthesizer.speak_ssml_async(ssml).get()

print("Generated assets/audio/test_blank_ssml.mp3")
