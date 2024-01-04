# Paper - How many specimens make a sufficient training set for 3D feature extraction? 

# Code for Creating .Tiff Stacks from .tiff images 

# Author: James M. Mulqueeney 

# Date Last Modified: 04/01/2024 

# Load in libraries 
from wand.image import Image
import os

# Create a new folder for the output files
output_dir = "path/to/tif/files/output"
os.makedirs(output_dir, exist_ok=True)

# Specify parent directory 
parent_dir = "path/to/tif/files"

# Apply to all Subdirectories within a Parent Directory
for dir_path, subdirs, files in os.walk(parent_dir):
    for subdir in subdirs:
        subdir_path = os.path.join(dir_path, subdir)
        file_list = sorted([os.path.join(subdir_path, f) for f in os.listdir(subdir_path) if f.endswith((".tif", ".tiff"))], key=lambda x: int(os.path.splitext(os.path.basename(x))[0]))
        output_img = Image(filename=file_list[0])
        for i in range(1, len(file_list)):
            img = Image(filename=file_list[i])
            output_img.sequence.append(img)
        output_filename = f"{subdir}.tiff"
        output_path = os.path.join(output_dir, output_filename)
        output_img.compression = 'lzw'
        output_img.save(filename=output_path)
