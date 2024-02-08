# Paper - How many specimens make a sufficient training set for 3D feature extraction? 

# Perform TIFF Rotation for Data Augmentation 

# Author: James M. Mulqueeney 

# Date Last Modified: 04/01/2024 

# Load in libraries 
import numpy as np
import tifffile as tiff
import os

# Set path to input folder containing TIFF stacks
input_folder = 'path/to/input/folder/'

# Set path to output folder where rotated images will be saved
output_folder = 'path/to/output/folder/rotated_images/'

# Get list of all TIFF stacks in the input folder
tiff_stacks = [f for f in os.listdir(input_folder) if f.endswith('.tif') or f.endswith('.tiff')]
# Loop through each TIFF stack in the input folder
for tiff_stack in tiff_stacks:
    # Load the TIFF stack as a sequence of images
    images = tiff.imread(os.path.join(input_folder, tiff_stack))
    # Get the image spacing from the original TIFF stack
    with tiff.TiffFile(os.path.join(input_folder, tiff_stack)) as tif:
        spacing = (tif.pages[0].tags['XResolution'].value[0] / tif.pages[0].tags['XResolution'].value[1]) * 100
    # Save the Original File as X-Y-Z
    tiff.imwrite(os.path.join(output_folder, "xyz_" + tiff_stack), images, compression="lzw", imagej=True, resolution=(1/spacing, 1/spacing))
    # Rotate into X-Z-Y orientation
    rotated_images = np.transpose(images, (1, 0, 2))
    tiff.imwrite(os.path.join(output_folder, "xzy_" + tiff_stack), rotated_images, compression="lzw", imagej=True, resolution=(1/spacing, 1/spacing))
    # Rotate into Y-X-Z orientation
    rotated_images = np.transpose(images, (0, 2, 1))
    tiff.imwrite(os.path.join(output_folder, "yxz_" + tiff_stack), rotated_images, compression="lzw", imagej=True, resolution=(1/spacing, 1/spacing))
    # Rotate into Y-Z-X orientation
    rotated_images = np.transpose(images, (1, 2, 0))
    tiff.imwrite(os.path.join(output_folder, "yzx_" + tiff_stack), rotated_images, compression="lzw", imagej=True, resolution=(1/spacing, 1/spacing))
    # Rotate into Z-X-Y orientation
    rotated_images = np.transpose(images, (2, 0, 1))
    tiff.imwrite(os.path.join(output_folder, "zxy_" + tiff_stack), rotated_images, compression="lzw", imagej=True, resolution=(1/spacing, 1/spacing))
    # Rotate into Z-Y-X orientation
    rotated_images = np.transpose(images, (2, 1, 0))
    tiff.imwrite(os.path.join(output_folder, "zyx_" + tiff_stack), rotated_images, compression="lzw", imagej=True, resolution=(1/spacing, 1/spacing))
