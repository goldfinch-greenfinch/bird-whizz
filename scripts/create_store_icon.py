
import os
from PIL import Image

def create_store_icon():
    base_dir = r"c:\Users\adamw\.gemini\antigravity\scratch\bird_quiz\store_assets"
    fg_path = os.path.join(base_dir, "bird-whizz-transparent-icon.png")
    bg_path = os.path.join(base_dir, "adaptive_background.png")
    output_path = os.path.join(base_dir, "play_store_512.png")

    try:
        print(f"Loading foreground: {fg_path}")
        foreground = Image.open(fg_path).convert("RGBA")
        
        print(f"Loading background: {bg_path}")
        background = Image.open(bg_path).convert("RGBA")

        # Resize background to 512x512 if needed (Store requirement)
        if background.size != (512, 512):
            print(f"Resizing background from {background.size} to (512, 512)")
            background = background.resize((512, 512), Image.Resampling.LANCZOS)
            
        # Resize foreground to match if needed, preserving aspect ratio fits usually best, 
        # but for adaptive icons, foregrounds are often 108x108 viewport logic. 
        # However, for the store icon, we usually want it full size.
        # Let's assume the user wants the foreground centered and relatively large.
        # If the foreground is already 512x512, we just paste it.
        
        if foreground.size != (512, 512):
             print(f"Resizing foreground from {foreground.size} to (512, 512)")
             foreground = foreground.resize((512, 512), Image.Resampling.LANCZOS)

        # Composite
        print("Compositing images...")
        final_image = Image.alpha_composite(background, foreground)
        
        # Save as PNG (Play store accepts PNG) - flattening just in case, though PNG handles it.
        # Actually Google Play prefers 32-bit PNGs so alpha is technically 'allowed' in the file format,
        # but the visual result should be opaque. 
        # But 'Image.alpha_composite' returns an RGBA.
        # If we want a truly opaque file (no alpha channel), we should convert to RGB.
        final_image_opaque = final_image.convert("RGB")
        
        print(f"Saving to {output_path}")
        final_image_opaque.save(output_path, "PNG")
        print("Success!")

    except Exception as e:
        print(f"Error: {e}")

if __name__ == "__main__":
    create_store_icon()
