
import os
from PIL import Image
from pathlib import Path

# Configuration
RAW_DIR = Path('assets/bird_photos_raw')
OUTPUT_DIR = Path('assets/bird_photos')
MAX_SIZE = (1024, 1024)
QUALITY = 80

def normalize_filename(filename):
    """
    Normalizes the filename to match existing convention:
    - Lowercase
    - Spaces to underscores
    - Extension to .webp
    """
    stem = Path(filename).stem
    normalized_stem = stem.lower().replace(' ', '_').replace('-', '_')
    return f"{normalized_stem}.webp"

def process_images():
    if not OUTPUT_DIR.exists():
        OUTPUT_DIR.mkdir(parents=True)

    processed_count = 0
    skipped_count = 0
    errors = []

    print(f"Scanning {RAW_DIR}...")
    
    files = list(RAW_DIR.glob('*'))
    total_files = len(files)
    
    print(f"Found {total_files} files.")

    for file_path in files:
        if file_path.suffix.lower() not in ['.jpg', '.jpeg', '.png']:
            continue

        target_filename = normalize_filename(file_path.name)
        target_path = OUTPUT_DIR / target_filename

        if target_path.exists():
            print(f"Skipping {file_path.name} -> {target_filename} (already exists)")
            skipped_count += 1
            continue

        try:
            with Image.open(file_path) as img:
                # Convert to RGB if necessary (e.g. for PNGs with transparency if saving as JPEG, but WebP supports alpha)
                # However, usually good to ensure consistency.
                
                # Resize
                img.thumbnail(MAX_SIZE, Image.Resampling.LANCZOS)
                
                # Save
                img.save(target_path, 'WEBP', quality=QUALITY)
                print(f"Processed {file_path.name} -> {target_filename}")
                processed_count += 1
        except Exception as e:
            print(f"Error processing {file_path.name}: {e}")
            errors.append((file_path.name, str(e)))

    print("\nProcessing complete.")
    print(f"Processed: {processed_count}")
    print(f"Skipped: {skipped_count}")
    
    if errors:
        print("\nErrors:")
        for name, err in errors:
            print(f"{name}: {err}")

if __name__ == "__main__":
    process_images()
