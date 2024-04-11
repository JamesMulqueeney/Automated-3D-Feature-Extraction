# Automated-3D-Feature-Extraction
Code linked to the paper: How many specimens make a sufficient training set for automated 3D feature extraction? DOI:

If you use this code please cite: Mulqueeney, James M., et al. "How many specimens make a sufficient training set for automated 3D feature extraction?." bioRxiv (2024): 2024-01.

# Data 
All data stored here is used in the results section of the paper. These data can be analysed/ visualised using the R scripts within the the 'R Scripts' Folder. This is as follows:

1. `Dice_Score_Results.csv`: Dice score results for each of the training sets, used in the code for Sections 3.1 and 3.2.
2. `Training_Set_Means.csv`: Mean Dice Scores, used in the code for Section 3.2 (also generated within).
3. `Volumetric_Comparison_Data.csv`: Volumetric Data used in the Manual vs AI comparison within Section 3.3. 
4. `Internal_Shape_Comparison_Data.csv`: Internal Shape Data, used in the Manual vs AI comparison with Section 3.4.
5. `External_Shape_Comparison_Data.csv`: External Shape Data, used in the Manual vs AI comparison with Section 3.4.

# R Scripts 
All R Scripts used in the visualisation and statistical analyis of data are found here. These are used in each of the results sections: 

1. Section 3.1 - `Section_3.1_Early_stopping_vs_200_epochs.R`
2. Section 3.2 - `Section_3.2_Network_Accuracy.R`
3. Section 3.3 - `Section_3.3_Volumetric_Comparison.R` 
4. Section 3.4 - `Section_3.4_Shape_Comparison.R`

# Python Scripts 
Python Scripts used in the analysis, mainly in the processing and generating data. These are as follows: 

1. `Batch_Tiff_Image_to_Stack_Conversion.py`: Used to concatenate single .tiff images together to produce .tiff stacks. 
2. `Tiff_Rotation_Augmentation.py`: Used to rotate the original .tiff stack into 5 new orientations (6 outputs in total).
3. `Volume_Measuring.py`: Used to measure the volume of each of the labels (here internal & external volumes) directly from the image. This extracts and uses the voxel size (image spacing) in the images to give the true size value. 
4. `Mesh_Generation_From_Images.py`: Used to generate mesh files from the segmented image files through marching cubes.
5. `Mesh_Processing.py`: Used to batch process the meshes for analysis. This includes code for decimating, smoothing and scaling (cleaning) the meshes. Code can be edited to perform these individually or all together.
6. `Batch_Convert_Ply_to_VTK.py` : Used to batch convert .ply meshes to .vtk format for use in Deterministic Atlas Analysis.
7. `XML_Generation.py`: Used to generate the data_set.xml file used in the Deterministic Atlas Analysis. 
