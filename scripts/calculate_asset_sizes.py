
import os

def get_dir_size(path):
    total_size = 0
    for dirpath, dirnames, filenames in os.walk(path):
        for f in filenames:
            fp = os.path.join(dirpath, f)
            # skip if it is symbolic link
            if not os.path.islink(fp):
                total_size += os.path.getsize(fp)
    return total_size

assets_dir = r"c:\Users\adamw\.gemini\antigravity\scratch\bird_quiz\assets"
subdirs = [os.path.join(assets_dir, d) for d in os.listdir(assets_dir) if os.path.isdir(os.path.join(assets_dir, d))]

print(f"{'Folder':<20} | {'Size (MB)':<10}")
print("-" * 33)

for subdir in subdirs:
    size_bytes = get_dir_size(subdir)
    size_mb = size_bytes / (1024 * 1024)
    folder_name = os.path.basename(subdir)
    print(f"{folder_name:<20} | {size_mb:.2f} MB")
