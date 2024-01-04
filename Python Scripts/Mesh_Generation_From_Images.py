# Paper - How many specimens make a sufficient training set for 3D feature extraction? 

# Code for Creating Meshes from .TIFF Stacks (Internal, External, Background) 

# Author: James M. Mulqueeney 

# Date Last Modified: 04/01/2024 

import os
import numpy as np
from skimage import io
from skimage import measure
import trimesh

# Define the directories to save the external and internal meshes to
input_directory = 'input/directory'
external_dir = 'external_meshes'
internal_dir = 'internal_meshes'

# Create the directories if they don't already exist
if not os.path.exists(external_dir):
    os.makedirs(external_dir)

if not os.path.exists(internal_dir):
    os.makedirs(internal_dir)

# Get a list of all .tif and .tiff files in the input directory
image_files = [f for f in os.listdir(input_directory) if f.endswith('.tif') or f.endswith('.tiff')]

for filename in image_files:
    # Load the image file
    image = io.imread(os.path.join(input_directory, filename))
    # Pre-process the image to isolate the objects
    foreground_1 = (image == 1)  # Pixels with value 1 are foreground structure 1
    foreground_1 = np.fliplr(foreground_1)
    # Pixels with value 1 are foreground structure 1
    foreground_2 = (image == 2)  # Pixels with value 2 are foreground structure 2
    foreground_2 = np.fliplr(foreground_2)
    # Apply the Marching Cubes algorithm to extract a mesh for the external structure
    vertices, faces, _, _ = measure.marching_cubes(foreground_1)
    # Create a trimesh object from the vertices and faces
    mesh = trimesh.Trimesh(vertices=vertices, faces=faces)
    # Fix the normals
    mesh.fix_normals()
    # Export the mesh to a file with a name that indicates it's for the external structure and which image file it came from,
    # in the external_meshes directory
    mesh.export(os.path.join(external_dir, "" + filename[:-4] + ".ply"), file_type="ply")
    # Apply the Marching Cubes algorithm to extract a mesh for the internal structure
    vertices, faces, _, _ = measure.marching_cubes(foreground_2)
    # Create a trimesh object from the vertices and faces
    mesh = trimesh.Trimesh(vertices=vertices, faces=faces)
    # Fix the normals
    mesh.fix_normals()
    # Export the mesh to a file with a name that indicates it's for the internal structure and which image file it came from,
    # in the internal_meshes directory
    mesh.export(os.path.join(internal_dir, "" + filename[:-4] + ".ply"), file_type="ply")

