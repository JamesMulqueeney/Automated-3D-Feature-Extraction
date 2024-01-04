# Paper - How many specimens make a sufficient training set for 3D feature extraction? 

# Produce plots for Section 3.2 

# Author: James M. Mulqueeney 

# Date Last Modified: 04/01/2024 

# Results : Section 3.2 Network accuracy

#########################################################################################

# Load libraries
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

# Figure 5 - Plot Dice Scores mean values across the different training sets 
P2 <- ggplot(Dice, aes(x = Number.of.Specimens, y = Dice.Score.ES.25, colour = Data.Type)) +
  geom_point(size = 3) +
  geom_line(stat = "summary", size = 1) +
  labs(x = "Number of Specimens", y = "Dice Score") +
  theme(panel.grid.major = element_blank(), panel.grid.minor = element_blank(),
        panel.background = element_blank(), axis.line = element_line(colour = "black")) +
  scale_x_continuous(breaks = seq(0, 20, 2), labels = seq(0, 20, 2))

# Figure 4 (4.5' x 6.5' )
P2

#########################################################################################

# Stats # 

# Calculate means for each Data.Type
means <- Dice %>%
  group_by(Name.of.Training.Set) %>%
  summarize(mean_dice = mean(Dice.Score.ES.25))

# Create a new dataframe
mean_df <- data.frame(Name.of.Training.Set = means$Name.of.Training.Set, Mean_Dice = means$mean_dice)

# Export to a CSV file
write.csv(mean_df, "D:/CTData/James Mulqueeney/Papers/Write Up Papers/Paper 1- 3D AI Augmentation Paper/Dice Similarity Coefficient Results/Training Data Results/Training_Set_Means.csv", row.names = FALSE)

# Print the new dataframe
print(mean_df)

# Perform t-test (for Training Set)
anova_training_set <- aov(Dice.Score.ES.25 ~ Name.of.Training.Set, data = Dice)

# Summarize the ANOVA results
summary(anova_training_set)

# Perform t-test for data types
ttest_result <- t.test(original_subset$Dice.Score.ES.25, augmentation_subset$Dice.Score.ES.25)

# Perform t-test for data types
ttest_result <- t.test(original_subset$Dice.Score.ES.25[9:12], augmentation_subset$Dice.Score.ES.25[9:12])

# Print t-test results
print(ttest_result)

# Average differences 

# Subset the dataframe into two groups
augmented_data <- mean_df[1:6, ]
original_data <- mean_df[7:12, ]

# Calculate the mean for each group
mean_augmented <- mean(augmented_data$Mean_Dice)
mean_original <- mean(original_data$Mean_Dice)

# Calculate the percentage difference (of max vs min): Change numbers as you please 

# Original (T0 vs T5)
original_percentage_difference <- ((0.9622667 - 0.8565333) / 0.8565333) * 100
print (original_percentage_difference)

# Augmented (Aug_T0 vs Aug_T5)
augmented_percentage_difference <- ((0.9682333 - 0.9250333) / 0.9250333) * 100
print (augmented_percentage_difference)

#########################################################################################

# Generalised linear model with a quasibinomial error 

# Create original box plot
g1 <- ggplot(data = Dice, aes(x = Number.of.Specimens, y = Dice.Score.ES.25, color = Data.Type))
g1 + geom_point() + facet_grid(~Data.Type) + geom_smooth(method = "glm", method.args = list(family = "quasibinomial"))
# but the fits are really bad
g1 + geom_boxplot() + facet_grid(~Data.Type)


# Apply GLM's and plot 
m1 <- glm(Dice.Score.ES.25 ~ Number.of.Specimens*Data.Type, data = Dice, family = quasibinomial)
m2 <- glm(Dice.Score.ES.25 ~ Number.of.Specimens+Data.Type, data = Dice, family = quasibinomial)
anova(m1, m2, test = "Chi")
plot(m2)
par(mfrow=c(2,2))

# no detectable differences between the model with the interaction and that without
# i.e. a consistent difference (on a logit scale account for bounding at 1) btw augmented and original

# try with logs as we are doubling the power (number of specimens each time)
m1a <- glm(Dice.Score.ES.25 ~ log(Number.of.Specimens)*Data.Type, data = Dice, family = quasibinomial)
m2a <- glm(Dice.Score.ES.25 ~ log(Number.of.Specimens)+Data.Type, data = Dice, family = quasibinomial)
anova(m1a, m2a, test = "Chi")
# now a detectable differences between the model with the interaction and that without
# i.e., the difference between the two methods gets smaller as the log(number of specimens gets bigger)

g2 <- ggplot(data = Dice, aes(x = log(Number.of.Specimens), y = Dice.Score.ES.25, color = Data.Type))
g2 + geom_point() + facet_grid(~Data.Type) + geom_smooth(method = "glm", method.args = list(family = "quasibinomial"))

par(mfrow=c(2,2))
plot(m1a)
# first residual plot still a bit curvy, but everything else looks excellent so prob ok
# in essence, not really enough variation!

# GLMs have a link transform that transforms the mean of the data, not the data itself
# to get back to the original scale, you take the numbers in the output and ...
# ... apply the inverse transform. We have logits on the link function so need inverse logits
# to back-transform effects for when logN = 1, i.e. just over 2 individuals
1/(1+(1/exp(2.48413 + 0.31433*1)))
#0.9425925
1/(1+(1/exp(2.48413 + (0.31433+0.21129)*1 - 0.63267)))
#0.9150628
# to back-transform effects for when logN = 3, i.e. 20 individuals
1/(1+(1/exp(2.48413 + 0.31433*3)))
#0.9685414
1/(1+(1/exp(2.48413 + (0.31433+0.21129)*3 - 0.63267)))
#0.968578

