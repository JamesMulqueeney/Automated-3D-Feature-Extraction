# Paper - How many specimens make a sufficient training set for 3D feature extraction? 

# Produce plots for Section 3.4 

# Author: James M. Mulqueeney 

# Date Last Modified: 04/01/2024 

# Results : Section 3.4 Shape comparison  

#########################################################################################

# Load in libraries
library(ggplot2)
library(patchwork)
library(gridExtra)
library (viridis)
library(cowplot)
library(dplyr)

#########################################################################################

# Internal Shape #

# Read in the Internal shape .csv data 
Internal.Shape <- read.csv("/path/to/your/directory/Attempt 2/Internal_Shape_Comparison_Data.csv")

#########################################################################################

# PC1 #

# Figure 7a - PC1 of Internal Shape 
P7 <- ggplot(Internal.Shape, aes(x = Man.PC1, y = AI.PC1, color = as.factor(Number.of.Specimens), linetype=Data.Type, shape = Data.Type)) +
  geom_point(size = 1.5) +
  geom_smooth(method = "lm", se = FALSE, size = 1, ) +
  labs(x = "Manual Shape (PC1)", y = "AI Shape (PC1)",color ="Number of Specimens", linetype = "Data Type", shape = "Data Type") +
  theme_minimal() +
  theme(panel.grid.major = element_blank(), panel.grid.minor = element_blank(),
        panel.background = element_blank(), axis.line = element_line(colour = "black"), axis.ticks = element_line(colour = "black"))+
  geom_abline(intercept = 0, slope = 1, linetype = "dashed", color = "black", size=1) +
  scale_x_continuous(limits = c(-0.05, 0.045)) +
  scale_y_continuous(limits = c(-0.05, 0.045))   

P7

#########################################################################################

# Stats # 

# Perform ANOVA to test differences between groups
lm_results <- lm(Man.PC1 ~ AI.PC1 * Name.of.Training.Set, data = Internal.Shape)
anova_results <- anova(lm_results)
print(anova_results)

# Extract coefficients for each training set
coefficients_df <- coef(summary(lm_results))
print(coefficients_df)

# Individual line regressions (max vs min)

# Min (T0_AI_1_Images)
Min_vol <- subset(Internal.Shape, Name.of.Training.Set == "T0_AI_1_Images")
correlation_matrix <- cor(Min_vol$Man.PC1, Min_vol$AI.PC1)
r_squared_min <- correlation_matrix^2
print (r_squared_min)

# Max (Aug_T5_AI_20_Images)
Max_vol <- subset(Internal.Shape, Name.of.Training.Set == "Aug_T5_AI_20_Images")
correlation_matrix <- cor(Max_vol$Man.PC1, Max_vol$AI.PC1)
r_squared_max <- correlation_matrix^2
print (r_squared_max)

#########################################################################################

# PC2 # 

# Figure 7c - PC2 of Internal Shape 
P8 <- ggplot(Internal.Shape, aes(x = Man.PC2, y = AI.PC2, color = as.factor(Number.of.Specimens), linetype=Data.Type, shape = Data.Type)) +
  geom_point(size = 1.5) +
  geom_smooth(method = "lm", se = FALSE, size = 1, ) +
  labs(x = "Manual Shape (PC2)", y = "AI Shape (PC2)", color ="Number of Specimens", linetype = "Data Type", shape = "Data Type") +
  theme_minimal() +
  theme(panel.grid.major = element_blank(), panel.grid.minor = element_blank(),
        panel.background = element_blank(), axis.line = element_line(colour = "black"),axis.ticks = element_line(colour = "black"))+
  geom_abline(intercept = 0, slope = 1, linetype = "dashed", color = "black", size=1) +
  scale_x_continuous(limits = c(-0.035, 0.040)) +
  scale_y_continuous(limits = c(-0.035, 0.040))  

P8

#########################################################################################

# Stats # 

# Perform ANOVA to test differences between groups
lm_results <- lm(Man.PC2 ~ AI.PC2 * Name.of.Training.Set, data = Internal.Shape)
anova_results <- anova(lm_results)
print(anova_results)

# Extract coefficients for each training set
coefficients_df <- coef(summary(lm_results))
print(coefficients_df)

#########################################################################################

# PC3 # 

# Figure 7e - PC3 of Internal Shape 
P9 <- ggplot(Internal.Shape, aes(x = Man.PC3, y = AI.PC3, color = as.factor(Number.of.Specimens), linetype=Data.Type, shape = Data.Type)) +
  geom_point(size = 1.5) +
  geom_smooth(method = "lm", se = FALSE, size = 1, ) +
  labs(x = "Manual Shape (PC3)", y = "AI Shape (PC3)", color ="Number of Specimens", linetype = "Data Type", shape = "Data Type") +
  theme_minimal() +
  theme(panel.grid.major = element_blank(), panel.grid.minor = element_blank(),
        panel.background = element_blank(), axis.line = element_line(colour = "black"), axis.ticks = element_line(colour = "black"))+
  geom_abline(intercept = 0, slope = 1, linetype = "dashed", color = "black", size=1) +
  scale_x_continuous(limits = c(-0.040, 0.040)) +
  scale_y_continuous(limits = c(-0.040, 0.040))  

P9

#########################################################################################

# Stats # 

# Perform ANOVA to test differences between groups
lm_results <- lm(Man.PC3 ~ AI.PC3 * Name.of.Training.Set, data = Internal.Shape)
anova_results <- anova(lm_results)
print(anova_results)

# Extract coefficients for each training set
coefficients_df <- coef(summary(lm_results))
print(coefficients_df)

#########################################################################################

# External Shape # 

# Read in the External shape .csv data 
External.Shape <- read.csv("/path/to/your/directory/Attempt 2/External_Shape_Comparison_Data.csv")

#########################################################################################

# PC1 # 

# Figure 7b - PC1 of External Shape 
P10 <- ggplot(External.Shape, aes(x = Man.PC1, y = AI.PC1, color = as.factor(Number.of.Specimens), linetype=Data.Type)) +
  geom_point(size = 1.5) +
  geom_smooth(method = "lm", se = FALSE, size = 1, ) +
  labs(x = "Manual Shape (PC1)", y = "AI Shape (PC1)", color ="Number of Specimens", linetype = "Data Type", shape = "Data Type") +
  theme_minimal() +
  theme(panel.grid.major = element_blank(), panel.grid.minor = element_blank(),
        panel.background = element_blank(), axis.line = element_line(colour = "black"))+
  geom_abline(intercept = 0, slope = 1, linetype = "dashed", color = "black", size=1) +
  scale_x_continuous(limits = c(-0.05, 0.05)) +
  scale_y_continuous(limits = c(-0.05, 0.05))   

P10 

#########################################################################################

# Stats # 

# Perform ANOVA to test differences between groups
lm_results <- lm(Man.PC1 ~ AI.PC1 * Name.of.Training.Set, data = External.Shape)
anova_results <- anova(lm_results)
print(anova_results)

# Extract coefficients for each training set
coefficients_df <- coef(summary(lm_results))
print(coefficients_df)

# Individual line regressions (max vs min)

# Min (T0_AI_1_Images)
Min_vol <- subset(External.Shape, Name.of.Training.Set == "T0_AI_1_Images")
correlation_matrix <- cor(Min_vol$Man.PC1, Min_vol$AI.PC1)
r_squared_min <- correlation_matrix^2
print (r_squared_min)

# Max (Aug_T5_AI_20_Images)
Max_vol <- subset(External.Shape, Name.of.Training.Set == "Aug_T5_AI_20_Images")
correlation_matrix <- cor(Max_vol$Man.PC1, Max_vol$AI.PC1)
r_squared_max <- correlation_matrix^2
print (r_squared_max)

#########################################################################################

# PC2 #

# Figure 7d - PC2 of External Shape 
P11 <- ggplot(External.Shape, aes(x = Man.PC2, y = AI.PC2, color = as.factor(Number.of.Specimens), linetype=Data.Type)) +
  geom_point(size = 1.5) +
  geom_smooth(method = "lm", se = FALSE, size = 1, ) +
  labs(x = "Manual Shape (PC2)", y = "AI Shape (PC2)", color ="Number of Specimens", linetype = "Data Type", shape = "Data Type") +
  theme_minimal() +
  theme(panel.grid.major = element_blank(), panel.grid.minor = element_blank(),
        panel.background = element_blank(), axis.line = element_line(colour = "black"))+
  geom_abline(intercept = 0, slope = 1, linetype = "dashed", color = "black", size=1) +
  scale_x_continuous(limits = c(-0.050, 0.045)) +
  scale_y_continuous(limits = c(-0.050, 0.045))  

P11

#########################################################################################

# Stats # 

# Perform ANOVA to test differences between groups
lm_results <- lm(Man.PC2 ~ AI.PC2 * Name.of.Training.Set, data = External.Shape)
anova_results <- anova(lm_results)
print(anova_results)

# Extract coefficients for each training set
coefficients_df <- coef(summary(lm_results))
print(coefficients_df)

#########################################################################################

# PC3 #

# Figure 7e - PC3 of External Shape 
P12 <- ggplot(External.Shape, aes(x = Man.PC3, y = AI.PC3, color = as.factor(Number.of.Specimens), linetype=Data.Type)) +
  geom_point(size = 1.5) +
  geom_smooth(method = "lm", se = FALSE, size = 1, ) +
  labs(x = "Manual Shape (PC3)", y = "AI Shape (PC3)", color ="Number of Specimens", linetype = "Data Type", shape = "Data Type") +
  theme_minimal() +
  theme(panel.grid.major = element_blank(), panel.grid.minor = element_blank(),
        panel.background = element_blank(), axis.line = element_line(colour = "black"))+
  geom_abline(intercept = 0, slope = 1, linetype = "dashed", color = "black", size=1) +
  scale_x_continuous(limits = c(-0.045, 0.045)) +
  scale_y_continuous(limits = c(-0.045, 0.045))  

P12   

#########################################################################################

# Stats # 

# Perform ANOVA to test differences between groups
lm_results <- lm(Man.PC3 ~ AI.PC3 * Name.of.Training.Set, data = External.Shape)
anova_results <- anova(lm_results)
print(anova_results)

# Extract coefficients for each training set
coefficients_df <- coef(summary(lm_results))
print(coefficients_df)

#########################################################################################

# Figure 7 # 

# Plot figure 7 using grid (save in ratio of 11.5 x 10.5)
figure_7 <- plot_grid(P7, P10, P8, P11, P9, P12, align = "h", 
                      labels = c("A", "B", "C", "D", "E", "F"), hjust = -1, ncol=2)

# Plot figure 7 using grid (save in ratio of 11.5 x 10.5) # Reversed Side  
figure_7 <- plot_grid(P10, P7, P11, P8, P12, P9, align = "h", 
                      labels = c("A", "B", "C", "D", "E", "F"), hjust = -1, ncol=2)

# Display the combined plot
print(figure_7)
