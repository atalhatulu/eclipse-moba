#!/usr/bin/env python3
import sys, os, json
from PIL import Image

def slice_batch(batch_idx: int, img_path: str, out_dir: str = "/home/teha/Documents/GitHub/Godot/eclipse-moba/assets/icons/items"):
    os.makedirs(out_dir, exist_ok=True)
    
    with open("/home/teha/Documents/GitHub/Godot/eclipse-moba/data/items.json", "r") as f:
        data = json.load(f)
    items = data.get("items", [])
    
    start_i = (batch_idx - 1) * 12
    end_i = min(start_i + 12, len(items))
    b_items = items[start_i:end_i]
    
    img = Image.open(img_path)
    w, h = img.size
    cell_w = w / 4.0
    cell_h = h / 3.0
    
    saved_files = []
    for idx, it in enumerate(b_items):
        iid = it["id"]
        row = idx // 4
        col = idx % 4
        
        left = col * cell_w + cell_w * 0.05
        right = (col + 1) * cell_w - cell_w * 0.05
        top = row * cell_h + cell_h * 0.05
        bottom = (row + 1) * cell_h - cell_h * 0.05
        
        cropped = img.crop((left, top, right, bottom))
        cropped = cropped.resize((128, 128), Image.Resampling.LANCZOS)
        
        out_file = os.path.join(out_dir, f"item_{iid}.png")
        cropped.save(out_file, "PNG")
        saved_files.append(out_file)
        
    print(f"Batch {batch_idx}: Successfully sliced {len(saved_files)} icons (IDs {start_i+1}-{end_i}) to {out_dir}")

if __name__ == "__main__":
    if len(sys.argv) < 3:
        print("Usage: python3 slice_item_icons.py <batch_number: 1-10> <image_path>")
        sys.exit(1)
    slice_batch(int(sys.argv[1]), sys.argv[2])
