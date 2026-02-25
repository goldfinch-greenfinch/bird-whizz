import os
import re
import random
from pathlib import Path

def get_name(filename):
    stem = Path(filename).stem
    if stem == 'male_common_eide':
        stem = 'male_common_eider'
    stem = re.sub(r'_\d+$', '', stem)
    parts = stem.split('_')
    return ' '.join([p.capitalize() for p in parts if p])

photos_dir = Path('assets/bird_photos')
nuthatch_dir = Path('assets/nuthatch_birds')

existing_names = set()
for f in photos_dir.glob('*'):
    if f.suffix.lower() in ['.webp', '.png', '.jpg', '.jpeg']:
        existing_names.add(get_name(f.name))

new_names = set()
for f in nuthatch_dir.glob('*'):
    if f.suffix.lower() in ['.webp', '.png', '.jpg', '.jpeg']:
        new_names.add(get_name(f.name))

all_names = list(existing_names.union(new_names))

def find_similar(name, pool, exclude, count=3):
    words = set(name.split())
    # Try to find birds sharing the last word (e.g. "Warbler")
    last_word = name.split()[-1]
    
    candidates = []
    for other in pool:
        if other == exclude:
            continue
        other_words = other.split()
        if other_words[-1] == last_word:
            candidates.append(other)
            
    # If not enough, find sharing any word
    if len(candidates) < count:
        for other in pool:
            if other == exclude or other in candidates:
                continue
            if len(set(other.split()).intersection(words)) > 0:
                candidates.append(other)
                
    # If still not enough, take random
    if len(candidates) < count:
        remaining = [x for x in pool if x not in candidates and x != exclude]
        random.shuffle(remaining)
        candidates.extend(remaining[:count - len(candidates)])
        
    # shuffle the candidates to not always have the closest at the same index
    random.shuffle(candidates)
    return candidates[:count]

with open('lib/data/identification_data.dart', 'r', encoding='utf-8') as f:
    content = f.read()

# Remove the trailing '};'
content = re.sub(r'};?\s*$', '', content)

new_entries = []
for name in sorted(list(new_names)):
    # If it's already in the file, skip (whether from bird_photos or an earlier run)
    if f"'{name}':" in content: continue
    
    distractors = find_similar(name, all_names, name, 3)
    d_str = ", ".join(['"' + d.replace('"', '\\"') + '"' for d in distractors])
    clean_name = name.replace('"', '\\"')
    new_entries.append(f"  \"{clean_name}\": [{d_str}],")

with open('lib/data/identification_data.dart', 'w', encoding='utf-8') as f:
    f.write(content.rstrip())
    if not content.rstrip().endswith(','):
        f.write(',\n')
    else:
        f.write('\n')
    for e in new_entries:
        f.write(e + '\n')
    f.write('};\n')
