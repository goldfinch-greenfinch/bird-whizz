import requests
import os
import json
from dotenv import load_dotenv
import time

load_dotenv()

# Configuration
API_KEY = os.environ.get("NUTHATCH_API_KEY")  # Get one at nuthatch.lastelm.software
BASE_URL = "https://nuthatch.lastelm.software/v2/birds" # Using v2 endpoint for proper pagination
SAVE_DIR = "assets/nuthatch_birds_raw"
LIMIT = 500  # Try to fetch as many as possible

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

download_count = 0
page = 1

while download_count < LIMIT:
    params = {'page': page, 'limit': 100, 'pageSize': 100}
    headers = {'api-key': API_KEY}
    print(f"\nFetching metadata page {page}...")
    try:
        response = requests.get(BASE_URL, params=params, headers=headers)
        if response.status_code != 200:
            print(f"Error fetching page {page}: {response.status_code}")
            break
            
        data = response.json()
        new_birds = []
        if isinstance(data, list):
            new_birds = data
        elif isinstance(data, dict):
            new_birds = data.get('entities', data.get('data', []))
        
        if not new_birds:
            print("No more birds returned by API.")
            break
            
        print(f"Processing {len(new_birds)} birds from page {page}...")
        
        # Process birds immediately on the fly
        birds_added_from_page = 0
        for i, bird in enumerate(new_birds):
            if download_count >= LIMIT:
                break
                
            # v2 API uses 'name', v1 used 'commonName'
            common_name = bird.get('name') or bird.get('commonName')
            if not common_name:
                common_name = f'bird_{page}_{i}'
                
            if common_name in downloaded_names:
                continue # Skip duplicates
                
            name = str(common_name).replace(" ", "_").replace("/", "_").replace("\\", "_")
            
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
                    
                    # Update local json continuously so we don't lose data on crash
                    with open(metadata_path, 'w') as f_meta:
                        json.dump(metadata_list, f_meta, indent=4)
                        
                    downloaded_names.add(common_name)
                    print(f"Downloaded: {filename} ({download_count + 1}/{LIMIT})")
                    download_count += 1
                    birds_added_from_page += 1
                except Exception as e:
                    print(f"Failed to download {name}: {e}")
                    
        print(f"Added {birds_added_from_page} new birds from page {page}")
        
        # If we received less than we asked for, we've likely hit the end of the DB
        if len(new_birds) < 50:
            print("Hit end of Nuthatch API pagination.")
            break
            
        page += 1
        time.sleep(1) # be nice to the API
        
    except Exception as e:
        print(f"Exception on page {page}: {e}")
        break

print(f"\nFinished! Processed {download_count} new birds. Total birds in dataset: {len(metadata_list)}")