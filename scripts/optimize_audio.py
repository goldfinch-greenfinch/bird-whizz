import os
from pydub import AudioSegment
import static_ffmpeg

# Initialize static_ffmpeg to ensure ffmpeg is available
static_ffmpeg.add_paths()

AUDIO_DIR = r"assets\audio"
BG_MUSIC_DIR = os.path.join(AUDIO_DIR, "background_music")
SFX_DIR = os.path.join(AUDIO_DIR, "sound_effects")

def get_file_size_mb(path):
    return os.path.getsize(path) / (1024 * 1024)

def optimize_background_music():
    print("Optimizing Background Music...")
    if not os.path.exists(BG_MUSIC_DIR):
        print(f"Directory not found: {BG_MUSIC_DIR}")
        return

    for filename in os.listdir(BG_MUSIC_DIR):
        if filename.lower().endswith(('.wav', '.mp3')):
            filepath = os.path.join(BG_MUSIC_DIR, filename)
            try:
                print(f"Processing {filename}...")
                audio = AudioSegment.from_file(filepath)
                
                # Trim to 60s if needed
                if len(audio) > 60000:
                    print(f"  Trimming {filename} from {len(audio)/1000:.1f}s to 60s")
                    audio = audio[:60000]
                    # Fade out last 3 seconds
                    audio = audio.fade_out(3000)
                
                # Export as MP3 64k
                output_filename = os.path.splitext(filename)[0] + ".mp3"
                output_path = os.path.join(BG_MUSIC_DIR, output_filename)
                
                # Check directly exporting
                print(f"  Exporting to {output_filename} (64k)...")
                audio.export(output_path, format="mp3", bitrate="64k")
                
                # Remove original if it was a different extension or if we overwrote (pydub handles overwrite)
                if filename.lower().endswith('.wav'):
                    print(f"  Removing original {filename}")
                    os.remove(filepath)
                
                print(f"  Done. New size: {get_file_size_mb(output_path):.2f} MB")
                
            except Exception as e:
                print(f"  Error processing {filename}: {e}")

def optimize_sound_effects():
    print("\nOptimizing Sound Effects...")
    if not os.path.exists(SFX_DIR):
        print(f"Directory not found: {SFX_DIR}")
        return
        
    for filename in os.listdir(SFX_DIR):
        if filename.lower().endswith(('.wav', '.mp3')):
            filepath = os.path.join(SFX_DIR, filename)
            try:
                # Strategy: Convert WAV to MP3 128k
                # Except maybe if very short? No, user wants size reduction.
                
                if filename.lower().endswith('.wav'):
                    print(f"Processing {filename}...")
                    audio = AudioSegment.from_file(filepath)
                    
                    output_filename = os.path.splitext(filename)[0] + ".mp3"
                    output_path = os.path.join(SFX_DIR, output_filename)
                    
                    print(f"  Converting to {output_filename} (128k)...")
                    audio.export(output_path, format="mp3", bitrate="128k")
                    
                    print(f"  Removing original {filename}")
                    os.remove(filepath)
                    print(f"  Done. New size: {get_file_size_mb(output_path):.2f} MB")
                    
                # If mp3, maybe reduce bitrate if huge? 
                # level_up.mp3 is small. Leave mp3s alone in SFX for now unless > 1MB
                elif filename.lower().endswith('.mp3'):
                     if get_file_size_mb(filepath) > 1.0:
                        print(f"Processing large MP3 {filename}...")
                        audio = AudioSegment.from_file(filepath)
                        print(f"  Re-encoding to 128k...")
                        audio.export(filepath, format="mp3", bitrate="128k")
                        print(f"  Done. New size: {get_file_size_mb(filepath):.2f} MB")

            except Exception as e:
                print(f"  Error processing {filename}: {e}")

if __name__ == "__main__":
    optimize_background_music()
    optimize_sound_effects()
