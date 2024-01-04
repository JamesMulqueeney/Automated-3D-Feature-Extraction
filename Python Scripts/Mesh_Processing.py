# Paper - How many specimens make a sufficient training set for 3D feature extraction? 

# Code for Processing Meshes (Smoothing, Decimating and Scaling)

# For Mesh Alignment use GPSA.bat after running this code 

# Author: James M. Mulqueeney 

# Date Last Modified: 04/01/2024

# Load in libraries 
import os
import numpy as np
from skimage import io
from skimage import measure
import trimesh

###########

# External
input_dir = external_dir
output_dir = 'external_processed'

# Create output directory if it does not exist
if not os.path.exists(output_dir):
    os.makedirs(output_dir)

# Loop through input directory
for filename in os.listdir(input_dir):
    if filename.endswith('.ply'):
        # Load the input mesh
        mesh = trimesh.load(os.path.join(input_dir, filename))
        # Smooth the mesh
        smoothed_mesh = trimesh.smoothing.filter_laplacian(mesh, lamb=0.5, iterations=10) 
        # Decimate the mesh
        decimated_mesh = mesh.simplify_quadratic_decimation(50000)
        # Calculate the centroid of the mesh
        centroid = decimated_mesh.centroid
        # Calculate the maximum distance from the centroid
        distances = decimated_mesh.vertices - centroid
        max_distance = np.max(np.sqrt(np.sum(distances ** 2, axis=1)))
        # Scale the mesh to a standard size and position
        scale_factor = 1 / max_distance
        decimated_mesh.apply_translation(-centroid)
        decimated_mesh.apply_scale(scale_factor)
        # Define output file path
        output_filepath = os.path.join(output_dir, os.path.splitext(filename)[0] + '.ply')
        # Save the processed mesh
        decimated_mesh.export(output_filepath)

###########

# Internal
input_dir = internal_dir
output_dir = 'internal_processed'

# Create output directory if it does not exist
if not os.path.exists(output_dir):
    os.makedirs(output_dir)

# Loop through input directory
for filename in os.listdir(input_dir):
    if filename.endswith('.ply'):
        # Load the input mesh
        mesh = trimesh.load(os.path.join(input_dir, filename))
        # Smooth the mesh
        smoothed_mesh = trimesh.smoothing.filter_laplacian(mesh, lamb=0.5, iterations=10)
        # Decimate the mesh
        decimated_mesh = mesh.simplify_quadratic_decimation(50000)
        # Calculate the centroid of the mesh
        centroid = decimated_mesh.centroid
        # Calculate the maximum distance from the centroid
        distances = decimated_mesh.vertices - centroid
        max_distance = np.max(np.sqrt(np.sum(distances ** 2, axis=1)))
        # Scale the mesh to a standard size and position
        scale_factor = 1 / max_distance
        decimated_mesh.apply_translation(-centroid)
        decimated_mesh.apply_scale(scale_factor)
        # Define output file path
        output_filepath = os.path.join(output_dir, os.path.splitext(filename)[0] + '_processed.ply')
        # Save the processed mesh
        decimated_mesh.export(output_filepath)


    
