from PIL import Image
import os

def resize_image(input_path, output_path, size):
    try:
        if not os.path.exists(input_path):
            print(f"File not found: {input_path}")
            return
        
        with Image.open(input_path) as img:
            img = img.resize(size, Image.Resampling.LANCZOS)
            img.save(output_path)
            print(f"Resized {input_path} to {size} and saved as {output_path}")
    except Exception as e:
        print(f"Error resizing {input_path}: {e}")

# Resize Icon to 512x512
resize_image('store_assets/play_store_icon.png', 'store_assets/icon_512.png', (512, 512))

# Resize Feature Graphic to 1024x500
resize_image('store_assets/feature_graphic.png', 'store_assets/feature_graphic_1024x500.png', (1024, 500))
