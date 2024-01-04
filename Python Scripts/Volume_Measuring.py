# Paper - How many specimens make a sufficient training set for 3D feature extraction? 

# Measure volume of internal & external labels using voxel sizes from .TIFF Stacks  

# Author: James M. Mulqueeney 

# Date Last Modified: 04/01/2024

# Load in libraries 
import os
import numpy as np
from skimage import io, measure
import csv
import tifffile

# Set the directory paths
voxel_dir = "/path/to/voxel/files" # Image Data
pixel_dir = "/path/to/pixel/files" # Segmentation Data
output_file = "/path/to/output/file.csv"

# Function to calculate the scaled volume for each structure in a single file
def calculate_volumes(image, voxel_size):
    # Pre-process the image to isolate the objects
    foreground_1 = (image == 1)  # Pixels with value 1 are foreground structure 1
    foreground_2 = (image == 2)  # Pixels with value 2 are foreground structure 2
    # Label the connected components in the binary image for structure 1
    labeled_1 = measure.label(foreground_1)
    # Get the properties of the regions in the labeled image for structure 1
    regions_1 = measure.regionprops(labeled_1, intensity_image=image)
    # Calculate the volume of the foreground region for structure 1
    foreground_volume_1 = 0
    for region in regions_1:
        if np.mean ((region.intensity_image) == 1):
            foreground_volume_1 += region.area
    # Label the connected components in the binary image for structure 2
    labeled_2 = measure.label(foreground_2)
    # Get the properties of the regions in the labeled image for structure 2
    regions_2 = measure.regionprops(labeled_2, intensity_image=image)
    # Calculate the volume of the foreground region for structure 2
    foreground_volume_2 = 0
    for region in regions_2:
        if np.mean((region.intensity_image) == 2):
            foreground_volume_2 += region.area
    # Scaled volume for structure 1 (microns^3)
    scaled_volume_microns_1 = foreground_volume_1 * voxel_size**3
    # Scaled volume for structure 2 (microns^3)
    scaled_volume_microns_2 = foreground_volume_2 * voxel_size**3
    return scaled_volume_microns_1, scaled_volume_microns_2

# Note both sets of files must have matching names, so must be .tiff or .tif

# Create a CSV file to store the results
with open(output_file, 'w', newline='') as csvfile:
    fieldnames = ['Filename', 'External Volume', 'Internal Volume', 'Total Volume', 'Percentage Calcite']
    writer = csv.DictWriter(csvfile, fieldnames=fieldnames)
    writer.writeheader()
    # Process all files in the pixel directory
    for filename in os.listdir(pixel_dir):
        if filename.endswith('.tif') or filename.endswith('.tiff'):
            # Load the image
            image = io.imread(os.path.join(pixel_dir, filename))
            # Find the corresponding voxel file
            voxel_filename = filename.replace("_pixel", "_voxel")
            voxel_filepath = os.path.join(voxel_dir, voxel_filename)
            # Open the voxel image and get the voxel size
            with tifffile.TiffFile(voxel_filepath) as tif:
                metadata = tif.pages[0].tags    
                x_resolution = metadata['XResolution'].value       
                voxel_size = x_resolution[1] / x_resolution[0]
            # Calculate the volumes
            scaled_volume_microns_1, scaled_volume_microns_2 = calculate_volumes(image, (voxel_size))
            scaled_volume_microns_1 = scaled_volume_microns_1*1e12
            scaled_volume_microns_2 = scaled_volume_microns_2*1e12
            total_volume = scaled_volume_microns_1 + scaled_volume_microns_2
            percentage_calcite = (scaled_volume_microns_1/total_volume)*100
            # Write the results to the CSV file
            writer.writerow({
                'Filename': filename,
                'External Volume': scaled_volume_microns_1,
                'Internal Volume': scaled_volume_microns_2,
                'Total Volume' : total_volume,
                'Percentage Calcite' : percentage_calcite})
