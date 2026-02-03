from PIL import Image, ImageOps
import os

# Source Image
SOURCE_IMAGE_PATH = r"C:/Users/adamw/.gemini/antigravity/brain/d87b257f-6f25-499b-85ff-495a82b656e9/bird_launch_icon_1769894920793.png"

# Destination directories and sizes
DEST_DIRS = {
    'drawable-mdpi': 108,
    'drawable-hdpi': 162,
    'drawable-xhdpi': 216,
    'drawable-xxhdpi': 324,
    'drawable-xxxhdpi': 432
}

BASE_RES_DIR = r"c:/Users/adamw/.gemini/antigravity/scratch/bird_quiz/android/app/src/main/res"

def process_and_distribute_icon():
    print(f"Loading source image: {SOURCE_IMAGE_PATH}")
    try:
        img = Image.open(SOURCE_IMAGE_PATH).convert("RGBA")
        
        # Simple hack to remove background if it is solid color (like white or black)
        # We check the top-left pixel.
        bg_color = img.getpixel((0, 0))
        # If alpha is 0, it's already transparent.
        if bg_color[3] != 0:
            print(f"Detected background color: {bg_color}. Attempting to remove...")
            # Create a mask for this color with clear tolerance
            # This is a basic background removal, assuming the icon is fairly distinct.
            datas = img.getdata()
            new_data = []
            target = bg_color[:3]
            tolerance = 30 
            
            for item in datas:
                # Check strict equality for now or small tolerance
                if all(abs(item[i] - target[i]) <= tolerance for i in range(3)):
                    new_data.append((255, 255, 255, 0))
                else:
                    new_data.append(item)
            
            img.putdata(new_data)
        
        # Now maximize the content (crop empty space)
        bbox = img.getbbox()
        if bbox:
            img = img.crop(bbox)
            
        # Distribute to folders
        for folder, size in DEST_DIRS.items():
            target_dir = os.path.join(BASE_RES_DIR, folder)
            if not os.path.exists(target_dir):
                print(f"Directory not found: {target_dir}, skipping.")
                continue
                
            target_path = os.path.join(target_dir, "ic_launcher_foreground.png")
            
            # Smart Resize
            # We want the bird to fill the 108dp canvas almost entirely.
            # But the 'safe zone' is a circle in the middle.
            # If we make it 100% size, corners get cut. 
            # If we make it 66% size (standard), user says it's too small.
            # Let's target 90% of the canvas size for the image content.
            
            canvas = Image.new("RGBA", (size, size), (0,0,0,0))
            
            # Scale content to 95% of canvas
            content_scale = 0.95
            target_w = int(size * content_scale)
            target_h = int(size * content_scale)
            
            # Preserve aspect ratio of the bird
            img_ratio = img.width / img.height
            if img_ratio > 1:
                final_w = target_w
                final_h = int(target_w / img_ratio)
            else:
                final_h = target_h
                final_w = int(target_h * img_ratio)
                
            resized_bird = img.resize((final_w, final_h), Image.Resampling.LANCZOS)
            
            # Center it
            x = (size - final_w) // 2
            y = (size - final_h) // 2
            
            canvas.paste(resized_bird, (x, y))
            canvas.save(target_path)
            print(f"Saved {size}x{size} to {target_path}")

    except Exception as e:
        print(f"Error: {e}")

if __name__ == "__main__":
    process_and_distribute_icon()
