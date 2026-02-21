from rembg import remove
from PIL import Image

input_path = r'C:\Users\adamw\.gemini\antigravity\brain\9bffbac0-f614-408d-906f-9d976b1eafde\blue_tit_cartoon_1771690021943.png'
output_path = r'C:\Users\adamw\.gemini\antigravity\scratch\bird_quiz\blue_tit_out.png'

input_image = Image.open(input_path)
output_image = remove(input_image)
output_image.save(output_path)
print(f"Saved to {output_path}")

