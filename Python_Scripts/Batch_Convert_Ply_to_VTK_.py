# Paper - How many specimens make a sufficient training set for 3D feature extraction? 

# Code for Converting .ply files to .vtk files  

# Author: James M. Mulqueeney 

# Date Last Modified: 04/01/2024

# Load in libraries 
import os
import vtk

# specify the directory containing the .ply files
input_dir = "/path/to/input/directory"

# create a list of all .ply files in the directory
ply_files = [f for f in os.listdir(input_dir) if f.endswith('.ply')]

# create a directory to save the vtk files
output_dir = os.path.join(input_dir, "VTK Files")
if not os.path.exists(output_dir):
    os.mkdir(output_dir)

# loop over each .ply file and convert it to .vtk format
for ply_file in ply_files:
    # create a reader for the ply file
    reader = vtk.vtkPLYReader()
    reader.SetFileName(os.path.join(input_dir, ply_file))
    reader.Update()
    # get the output of the reader (vtkPolyData object)
    polydata = reader.GetOutput()
    # create a writer for the vtk file
    vtk_file = os.path.splitext(ply_file)[0] + '.vtk'  # replace .ply extension with .vtk
    vtk_path = os.path.join(output_dir, vtk_file)
    writer = vtk.vtkPolyDataWriter()
    writer.SetFileName(vtk_path)
    writer.SetInputData(polydata)
    writer.Write()
    print(f"Converted {ply_file} to {vtk_file}")
