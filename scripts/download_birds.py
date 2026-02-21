import requests
import os
import json
from dotenv import load_dotenv
import time

load_dotenv()

# Configuration
API_KEY = os.environ.get("NUTHATCH_API_KEY")  # Get one at nuthatch.lastelm.software
BASE_URL = "https://nuthatch.lastelm.software/birds" # Using standard endpoint, can adjust if needed
SAVE_DIR = "assets/nuthatch_birds_raw"
LIMIT = 2000  # Try to fetch as many as possible

# Create directory
if not os.path.exists(SAVE_DIR):
    os.makedirs(SAVE_DIR)

# Load existing metadata to avoid duplicates and preserve previous entries
metadata_path = os.path.join(SAVE_DIR, 'metadata.json')
metadata_list = []
downloaded_names = set()

if os.path.exists(metadata_path):
    try:
        with open(metadata_path, 'r') as f:
            metadata_list = json.load(f)
            for entry in metadata_list:
                downloaded_names.add(entry.get('commonName'))
    except json.JSONDecodeError:
        pass

# 1. Fetch Metadata
all_birds = []
page = 1
while True:
    params = {'page': page, 'limit': 100, 'pageSize': 100}
    headers = {'api-key': API_KEY}
    print(f"Fetching metadata page {page}...")
    try:
        response = requests.get(BASE_URL, params=params, headers=headers)
        if response.status_code == 200:
            data = response.json()
            new_birds = []
            if isinstance(data, list):
                new_birds = data
            elif isinstance(data, dict):
                new_birds = data.get('entities', data.get('data', []))
            
            if not new_birds:
                print("No more birds returned.")
                break
                
            all_birds.extend(new_birds)
            
            # If we received less than we asked for, we've likely hit the end
            if len(new_birds) < 50:
                print("Hit end of Nuthatch API pagination.")
                break
            page += 1
            time.sleep(1) # be nice to the API
        else:
            print(f"Error fetching page {page}: {response.status_code}")
            break
    except Exception as e:
        print(f"Exception fetching page {page}: {e}")
        break

print(f"Found {len(all_birds)} birds from API.")

# 2. Process and Download
download_count = 0

for i, bird in enumerate(all_birds):
    if download_count >= LIMIT:
        break
        
    common_name = bird.get('commonName')
    if common_name in downloaded_names:
        continue # Skip duplicates
        
    name = bird.get('name') or common_name or f'bird_{i}'
    name = str(name).replace(" ", "_").replace("/", "_").replace("\\", "_")
    
    images = bird.get('images', [])
    img_url = images[0] if images else None
    
    if img_url:
        try:
            # Download Image
            img_response = requests.get(img_url, timeout=10)
            img_response.raise_for_status()
            img_data = img_response.content
            
            file_extension = 'jpg'
            content_type = img_response.headers.get('content-type', '')
            if 'png' in content_type:
                file_extension = 'png'
            elif 'webp' in content_type:
                file_extension = 'webp'
            elif 'gif' in content_type:
                file_extension = 'gif'
                
            filename = f"{name}.{file_extension}"
            
            with open(os.path.join(SAVE_DIR, filename), 'wb') as f:
                f.write(img_data)

            # Save Metadata entry
            metadata_list.append({
                "commonName": common_name,
                "sciName": bird.get('sciName'),
                "status": bird.get('status'),
                "local_file": filename
            })
            downloaded_names.add(common_name)
            print(f"Downloaded: {filename}")
            download_count += 1
        except Exception as e:
            print(f"Failed to download {name}: {e}")

# 3. Save all metadata to a single JSON file
with open(metadata_path, 'w') as f:
    json.dump(metadata_list, f, indent=4)

print(f"Finished! Processed {download_count} new birds. Total birds in dataset: {len(metadata_list)}")