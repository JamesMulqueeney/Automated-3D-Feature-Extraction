# Paper - How many specimens make a sufficient training set for 3D feature extraction? 

# Produce plots and stats for Section 3.1 

# Author: James M. Mulqueeney 

# Date Last Modified: 04/01/2024 

# Results : Section 3.1 Early stopping vs. 200 epochs 

#########################################################################################

# Load in libraries
library(ggplot2)
library(patchwork)
library(gridExtra)
library (viridis)
library(cowplot)
library(dplyr)

#########################################################################################

# Read in Data & Set up Orders # 

# Load in Dice Score .csv data 
Dice <- read.csv("/path/to/your/directory/2023-07-05_J_Mul_Dice_v2.csv")

# Subset the data for Original and Augmentation Data 
original_subset <- subset(Dice, Dice$Data.Type == "Original") # subset for original data
augmentation_subset <- subset(Dice, Dice$Data.Type == "Augmented") # subset for augmentation data

# Create variables for the mean Dice Scores 

# Calculate the mean values for each combination of variables, excluding NaN rows
mean_data <- Dice %>%
  group_by(Number.of.Specimens, Data.Type, Name.of.Training.Set) %>%
  summarise(Mean_Dice_ES_25 = mean(Dice.Score.ES.25, na.rm = TRUE),
            Mean_Dice_200_Epochs = mean(Dice.Score.200.Epochs, na.rm = TRUE),
            Mean_Duration_Segmentation = mean(`Approx..Duration.of.Segmentation..Mins.`, na.rm = TRUE),
            Mean_Training_Time_ES_25 = mean(`Training.Time.ES.25..Mins.`, na.rm = TRUE)) %>%
  ungroup()

# Assign the data types to the means (Original & Augmentation)
Data_type_order <- c("Original","Augmentation" )
mean_data$Data.Type <- factor(mean_data$Data.Type, levels = Data_type_order)

#########################################################################################

# Produce Figure Plot # 

# Figure 4 - Plot the mean Dice scores (Early stopping vs 200 epochs)
P1 <- ggplot(mean_data, aes(x = Mean_Dice_200_Epochs, y= Mean_Dice_ES_25,  )) +
  geom_point(size = 3) +
  geom_smooth(method = "lm", se = TRUE, size = 1) +
  geom_abline(intercept = 0, slope = 1, linetype = "dashed", color = "black", size = 1) +
  labs(x = "Mean Dice Score (200 Epochs)", y = "Mean Dice Score (ES 25)") +
  scale_x_continuous(limits = c(0.85, 0.975)) +
  scale_y_continuous(limits = c(0.85, 0.975)) +
  theme(panel.grid.major = element_blank(), panel.grid.minor = element_blank(),
        panel.background = element_blank(), axis.line = element_line(colour = "black"))

# Figure 1 (4.5' x 4.5')
P1

#########################################################################################

# Stats # 

# Calculate the R2 Value 
L3<-lm (Mean_Dice_ES_25 ~ Mean_Dice_200_Epochs, mean_data)
summary(L3)

# Likelihood test 
Linear2<-lm (Mean_Dice_ES_25 ~ 1, mean_data, offset = Mean_Dice_200_Epochs)
anova(L3, Linear2)

