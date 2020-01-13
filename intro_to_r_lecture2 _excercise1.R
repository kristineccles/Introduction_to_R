#############################################################
# Lecture 2 Exercise 1 - Introduction to R 
#############################################################
# Load Libraries
library(datasets)
library(OneR)

# Load the data
df=airquality

# Is there any missing data?

df_clean =na.omit(df)

# Do you need to modify the data in any way?
#for the sake of doing a t-test we need to dive up temp to high and low 
df_clean$temp_bin=bin(df_clean$Temp, nbins = 2, labels = c('low','high'), method = c("content"))

# Any other modifications?


#############################################################
#### Exploratory Data Analysis ####
# Descriptive Statistcs #


# Make a histogram for all continuous variables


# Do you think there might be any issues meeting assumptions? If so, how would you address this?

#### T-Test #####
# plot the data


# Test assumptions


# Run the T-test


# Is the test significant?What is the interpreation of the results?

#### ANOVA ####
# plot the data 

# What are the little black dots on this plot?

# Test assumptions

# Is the test significant? Should we do a post-hoc follow up?

# Tukey post hoc test

# plot the differences


#What is your interpreation of these results?

#### Correlation #####

# visualize the correlations using corrplot


# testing single correlation


#What is your interpreation of these results?


#### Linear Regression ####
# Make a plot


# Linear model


# test assumptions on RESIDUALS


# Are there any other variables that can be used?


# test assumptions on RESIDUALS


# Adjusted R-squared:  0.655, p-value: < 2.2e-16


#### PCA ####
# PCA

# plots 
# scree


# biplot

# What are your conclusions about your PCA results