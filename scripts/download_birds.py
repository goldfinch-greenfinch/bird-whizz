import requests
import os
import json
from dotenv import load_dotenv

load_dotenv()

# Configuration
API_KEY = os.environ.get("NUTHATCH_API_KEY")  # Get one at nuthatch.lastelm.software
BASE_URL = "https://nuthatch.lastelm.software/v2/birds"
SAVE_DIR = "bird_dataset"
LIMIT = 200  # Total birds to fetch

# Create directory
if not os.path.exists(SAVE_DIR):
    os.makedirs(SAVE_DIR)

# 1. Fetch Metadata
# Nuthatch allows 'pageSize' up to 250 in some versions, 
# but let's use 100 per page to be safe.
all_birds = []
for page in [1, 2]:
    params = {'page': page, 'pageSize': 100}
    headers = {'api-key': API_KEY}
    response = requests.get(BASE_URL, params=params, headers=headers)
    
    if response.status_code == 200:
        data = response.json()
        all_birds.extend(data.get('entities', []))
    else:
        print(f"Error: {response.status_code}")

# 2. Process and Download
metadata_list = []

for i, bird in enumerate(all_birds[:LIMIT]):
    name = bird.get('commonName', f'bird_{i}').replace(" ", "_")
    img_url = bird.get('images', [None])[0] # Get first image if available
    
    if img_url:
        try:
            # Download Image
            img_data = requests.get(img_url).content
            file_extension = img_url.split('.')[-1].split('?')[0]
            filename = f"{name}.{file_extension}"
            
            with open(os.path.join(SAVE_DIR, filename), 'wb') as f:
                f.write(img_data)
            
            # Save Metadata entry
            metadata_list.append({
                "commonName": bird.get('commonName'),
                "sciName": bird.get('sciName'),
                "status": bird.get('status'),
                "local_file": filename
            })
            print(f"Downloaded: {filename}")
        except Exception as e:
            print(f"Failed to download {name}: {e}")

# 3. Save all metadata to a single JSON file
with open(os.path.join(SAVE_DIR, 'metadata.json'), 'w') as f:
    json.dump(metadata_list, f, indent=4)

print(f"Finished! Check the '{SAVE_DIR}' folder.")