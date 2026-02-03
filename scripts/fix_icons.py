from PIL import Image
import os
import sys

def crop_and_maximize(image_path):
    try:
        img = Image.open(image_path)
        img = img.convert("RGBA")
        
        # Get the original dimensions
        orig_width, orig_height = img.size
        
        # Get the bounding box of the non-transparent content
        bbox = img.getbbox()
        
        if not bbox:
            print(f"Warning: {image_path} seems empty/transparent. Skipping.")
            return

        # Crop to content
        cropped_img = img.crop(bbox)
        crop_width, crop_height = cropped_img.size
        
        # Calculate scaling factor to fit into original dimensions
        # We leave a very small margin (e.g. 2%) to prevent harsh edge clipping on some launchers
        # Android adaptive icons are 108dp. Safe zone is center 66dp-72dp.
        # But user wants "WHOLE SPACE". 
        # If we fill the full 108dp, the circle mask (diameter ~72dp-ish to 100dp depending on device) WILL cut corners.
        # However, the user complained about "massive border" and "50% white space".
        # Let's target filling about 90% of the canvas. 
        # The full canvas is 108dp. The viewport is usually masked to ~72dp diameter circle in worst case? 
        # Actually standard adaptive icon: 
        # Full size: 108x108 dp.
        # Viewport (masked): ~72x72 dp (radius 36dp).
        # Note: If we fill 100% of 108x108, the bird will be severely cropped.
        # If the user says "bird take up whole space", they probably mean "whole visible space".
        # The visible space is roughly 66% of the full image (72/108).
        # So we should scale the bird so it fits within a ~80-85% central square?
        # Let's try scaling to fit 90% of the canvas width/height.
        
        target_scale = 0.95 # Aggressive fill
        
        scale_w = (orig_width * target_scale) / crop_width
        scale_h = (orig_height * target_scale) / crop_height
        scale = min(scale_w, scale_h)
        
        new_w = int(crop_width * scale)
        new_h = int(crop_height * scale)
        
        resized_img = cropped_img.resize((new_w, new_h), Image.Resampling.LANCZOS)
        
        # Create new canvas
        final_img = Image.new("RGBA", (orig_width, orig_height), (0, 0, 0, 0))
        
        # Center the resized bird
        paste_x = (orig_width - new_w) // 2
        paste_y = (orig_height - new_h) // 2
        
        final_img.paste(resized_img, (paste_x, paste_y))
        
        final_img.save(image_path)
        print(f"Processed: {image_path} (Original: {orig_width}x{orig_height} -> Scaled Content: {new_w}x{new_h})")
        
    except Exception as e:
        print(f"Error processing {image_path}: {e}")

paths = [
    r"c:/Users/adamw/.gemini/antigravity/scratch/bird_quiz/android/app/src/main/res/drawable-hdpi/ic_launcher_foreground.png",
    r"c:/Users/adamw/.gemini/antigravity/scratch/bird_quiz/android/app/src/main/res/drawable-mdpi/ic_launcher_foreground.png",
    r"c:/Users/adamw/.gemini/antigravity/scratch/bird_quiz/android/app/src/main/res/drawable-xhdpi/ic_launcher_foreground.png",
    r"c:/Users/adamw/.gemini/antigravity/scratch/bird_quiz/android/app/src/main/res/drawable-xxhdpi/ic_launcher_foreground.png",
    r"c:/Users/adamw/.gemini/antigravity/scratch/bird_quiz/android/app/src/main/res/drawable-xxxhdpi/ic_launcher_foreground.png"
]

for p in paths:
    crop_and_maximize(p)
