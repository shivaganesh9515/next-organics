import os
from rembg import remove
from PIL import Image
import io

def process_logo():
    source_path = "IMG_7682.PNG"
    output_dir = "admin-web/public/images"
    favicon_path = "admin-web/public/favicon.ico"

    if not os.path.exists(source_path):
        print(f"Error: Source file {source_path} not found.")
        return

    print("Processing logo...")
    
    # Read the input image
    with open(source_path, 'rb') as i:
        input_data = i.read()
        
    # Remove background
    print("Removing background...")
    output_data = remove(input_data)
    
    # Convert to PIL Image for resizing
    img = Image.open(io.BytesIO(output_data))
    
    # Save Main Logo (512x512) - Keep aspect ratio, contain in square
    print("Saving logo.png...")
    base_size = (512, 512)
    img_ratio = img.width / img.height
    
    if img_ratio > 1:
        new_width = base_size[0]
        new_height = int(base_size[1] / img_ratio)
    else:
        new_width = int(base_size[0] * img_ratio)
        new_height = base_size[1]
        
    resized_img = img.resize((new_width, new_height), Image.Resampling.LANCZOS)
    
    # Create transparent canvas
    new_img = Image.new("RGBA", base_size, (255, 255, 255, 0))
    paste_pos = ((base_size[0] - new_width) // 2, (base_size[1] - new_height) // 2)
    new_img.paste(resized_img, paste_pos)
    
    new_img.save(os.path.join(output_dir, "logo.png"))
    
    # Save Icon Logo (128x128)
    print("Saving logo-icon.png...")
    icon_size = (128, 128)
    icon_img = new_img.resize(icon_size, Image.Resampling.LANCZOS)
    icon_img.save(os.path.join(output_dir, "logo-icon.png"))
    
    # Save Favicon (32x32)
    print("Saving favicon.ico...")
    favicon_size = (32, 32)
    favicon_img = new_img.resize(favicon_size, Image.Resampling.LANCZOS)
    favicon_img.save(favicon_path, format='ICO')

    # Save for Flutter (frontend/assets/images)
    flutter_dir = "frontend/assets/images"
    if os.path.exists("frontend"):
        if not os.path.exists(flutter_dir):
            os.makedirs(flutter_dir)
        print("Saving Flutter assets...")
        new_img.save(os.path.join(flutter_dir, "logo.png"))
        icon_img.save(os.path.join(flutter_dir, "logo-icon.png"))
    
    print("Logo processing complete!")

if __name__ == "__main__":
    process_logo()
