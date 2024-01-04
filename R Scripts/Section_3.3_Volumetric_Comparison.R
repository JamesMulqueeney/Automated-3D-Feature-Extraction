# Paper - How many specimens make a sufficient training set for 3D feature extraction? 

# Produce plots and stats for Section 3.3 

# Author: James M. Mulqueeney 

# Date Last Modified: 04/01/2024 

# Results : Section 3.3 Volumetric Comparison 

#########################################################################################

# Load in libraries
library(ggplot2)
library(patchwork)
library(gridExtra)
library (viridis)
library(cowplot)
library(dplyr)

#########################################################################################

# Read in the Volumetric .csv data 
Volumetric.Data <- read.csv("D:/CTData/James Mulqueeney/Papers/Write Up Papers/Paper 1- 3D AI Augmentation Paper/Dice Similarity Coefficient Results/Test Data Results/2023-10-10_AI_Volumetric_Comparison_Original_v3.csv")

## Total Volume ##

# Figure 6 - Total Volume and Percentage Calcite Manual vs AI Comparison #

# Figure 6a - Total Volume Comparison: Manual vs AI Segmentation across training sets 
P3 <- ggplot(Volumetric.Data, aes(x = log10(Man.Total.Volume), y = log10(TS.Total.Volume), color = as.factor(Number.of.Specimens), linetype=Data.Type, shape = Data.Type)) +
  geom_point(size = 1.5) +
  geom_smooth(method = "lm", se = FALSE, size = 1) +
  labs(x = expression(paste("log"[10], " (Manual Total Volume" ~ mu*m^2 ~")")),
       y = expression(paste("log"[10], " (AI Total Volume (" ~ mu*m^2 ~")")), color ="Number of Specimens", linetype = "Data Type", shape = "Data Type") +
  theme_minimal() +
  theme(panel.grid.major = element_blank(), panel.grid.minor = element_blank(),
        panel.background = element_blank(), axis.line = element_line(colour = "black"), axis.ticks = element_line(colour = "black"))+
  geom_abline(intercept = 0, slope = 1, linetype = "dashed", color = "black", size=1) +
  scale_x_continuous(limits = c(7.0, 8.5)) +
  scale_y_continuous(limits = c(7.0, 8.5))

P3  

#########################################################################################

# Stats # 

# Perform ANOVA to test differences between groups
lm_results <- lm(log10(TS.Total.Volume) ~ log10(Man.Total.Volume) * Name.of.Training.Set, data = Volumetric.Data)
anova_results <- anova(lm_results)
print(anova_results)

# Extract coefficients for each training set
coefficients_df <- coef(summary(lm_results))
print(coefficients_df)

# Individual line regressions (max vs min)

# Min (T0_AI_1_Images)
Min_vol <- subset(Volumetric.Data, Name.of.Training.Set == "T0_AI_1_Images")
correlation_matrix <- cor(Min_vol$Man.Total.Volume, Min_vol$TS.Total.Volume)
r_squared_min <- correlation_matrix^2
print (r_squared_min)

# Max (Aug_T5_AI_20_Images)
Max_vol <- subset(Volumetric.Data, Name.of.Training.Set == "Aug_T5_AI_20_Images")
correlation_matrix <- cor(Max_vol$Man.Total.Volume, Max_vol$TS.Total.Volume)
r_squared_max <- correlation_matrix^2
print (r_squared_max)

# Difference 
print(r_squared_max-r_squared_min)

#########################################################################################

## Percentage Calcite ##

# Figure 6b - Percentage Calcite Comparison: Manual vs AI Segmentation across training sets 
P4 <- ggplot(Volumetric.Data, aes(x = Man.Percentage.Calcite, y = TS.Percentage.Calcite, color = as.factor(Number.of.Specimens), linetype=Data.Type, shape = Data.Type)) +
  geom_point(size = 1.5) +
  geom_smooth(method = "lm", se = FALSE, size = 1) +
  labs(x = "Manual Percentage Calcite (%)",
       y = "AI Percentage Calcite (%)", color ="Number of Specimens", linetype = "Data Type", shape = "Data Type") +
  theme_minimal() +
  theme(panel.grid.major = element_blank(), panel.grid.minor = element_blank(),
        panel.background = element_blank(), axis.line = element_line(colour = "black"), axis.ticks = element_line(colour = "black"))+
  geom_abline(intercept = 0, slope = 1, linetype = "dashed", color = "black", size=1) +
  scale_x_continuous(limits = c(25, 65)) +
  scale_y_continuous(limits = c(25, 65)) 

P4

#########################################################################################

# Stats # 

# Perform ANOVA to test differences between groups
lm_results <- lm((TS.Percentage.Calcite) ~ (Man.Percentage.Calcite) * Name.of.Training.Set, data = Volumetric.Data)
anova_results <- anova(lm_results)
print(anova_results)

# Extract coefficients for each training set
coefficients_df <- coef(summary(lm_results))
print(coefficients_df)

# Individual line regressions (max vs min)

# Min (T0_AI_1_Images)
Min_vol <- subset(Volumetric.Data, Name.of.Training.Set == "T0_AI_1_Images")
correlation_matrix <- cor(Min_vol$Man.Percentage.Calcite, Min_vol$TS.Percentage.Calcite)
r_squared_min <- correlation_matrix^2
print (r_squared_min)

# Max (Aug_T5_AI_20_Images)
Max_vol <- subset(Volumetric.Data, Name.of.Training.Set == "Aug_T5_AI_20_Images")
correlation_matrix <- cor(Max_vol$Man.Percentage.Calcite, Max_vol$TS.Percentage.Calcite)
r_squared_max <- correlation_matrix^2
print (r_squared_max)

# Difference 
print(r_squared_max-r_squared_min)

#########################################################################################

# Create the Plot for Figure 6 # 

# Plot figure 6 using grid (save in ratio of 3.5 x 10.5)
figure_6 <- plot_grid(P3, P4, align = "h", labels = c("A", "B"), hjust = -1)

# Display the combined plot
print(figure_6)

