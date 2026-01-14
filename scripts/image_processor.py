from PIL import Image
import os
import argparse
import sys

def process_image(input_path, output_path=None, size=(512, 512), quality=85):
    """
    Process an image: resize to square with padding (or crop), optimize, and save.
    
    Args:
        input_path (str): Path to source image.
        output_path (str): Path to save processed image. If None, overwrites input.
        size (tuple): Target size (width, height). Default (512, 512).
        quality (int): JPEG quality (1-100). Default 85.
    """
    try:
        if not os.path.exists(input_path):
            print(f"Error: Input file not found: {input_path}")
            return False

        img = Image.open(input_path)
        
        # Convert to RGB if necessary (e.g. PNG with transparency)
        if img.mode in ('RGBA', 'P'):
            img = img.convert('RGB')

        # Calculate aspect ratio preserving resize
        img.thumbnail(size, Image.Resampling.LANCZOS)
        
        # Create a new square background
        new_img = Image.new("RGB", size, (255, 255, 255))
        
        # Paste the resized image onto the center
        paste_x = (size[0] - img.width) // 2
        paste_y = (size[1] - img.height) // 2
        new_img.paste(img, (paste_x, paste_y))

        # Save
        save_path = output_path if output_path else input_path
        new_img.save(save_path, "JPEG", optimize=True, quality=quality)
        
        print(f"Success: Processed {input_path} -> {save_path} ({size[0]}x{size[1]})")
        return True

    except Exception as e:
        print(f"Error processing {input_path}: {str(e)}")
        return False

def main():
    parser = argparse.ArgumentParser(description="Nextgen Organics Image Processor")
    parser.add_argument("input", help="Input image file or directory")
    parser.add_argument("--output", help="Output file or directory (optional)")
    parser.add_argument("--size", type=int, default=512, help="Target square size (default 512)")
    parser.add_argument("--quality", type=int, default=85, help="JPEG Quality (default 85)")
    
    args = parser.parse_args()
    
    target_size = (args.size, args.size)
    
    if os.path.isdir(args.input):
        # Batch process directory
        output_dir = args.output if args.output else args.input
        if not os.path.exists(output_dir):
            os.makedirs(output_dir)
            
        accepted_exts = ('.jpg', '.jpeg', '.png', '.webp')
        count = 0
        for filename in os.listdir(args.input):
            if filename.lower().endswith(accepted_exts):
                in_path = os.path.join(args.input, filename)
                out_path = os.path.join(output_dir, os.path.splitext(filename)[0] + ".jpg")
                if process_image(in_path, out_path, size=target_size, quality=args.quality):
                    count += 1
        print(f"Batch processing complete. {count} images processed.")
        
    else:
        # Single file process
        process_image(args.input, args.output, size=target_size, quality=args.quality)

if __name__ == "__main__":
    main()
