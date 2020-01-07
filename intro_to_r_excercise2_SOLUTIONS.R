#############################################################
# Exercise 2 - Introduction to R 
#############################################################
# Load Libraries
library(datasets)
# Need to install ggplot
library(ggplot2)

# Load data
# the dataset we will use is a a dataset built into R and be called from the datasets package
data(airquality)

#############################################################
# Summarize the dataframe
summary(airquality)

# Check for missing data and address it if necessary
clean_df <- na.omit(airquality)

#############################################################
# Visualize the data 
# Make a histogram of the variable ozone

plot1 <- ggplot(clean_df) +
  geom_histogram(aes(x = Ozone, y = ..density..),
                 binwidth = 10, fill = "grey", color = "black")
plot1
# Try changing the binwidth- what happens?

# Data distribution ozone by subsets month
plot2 <- ggplot(clean_df) +
  geom_histogram(aes(x = Ozone, y = ..density..),
                 binwidth = 20, fill = "grey", color = "black")+
  facet_grid( ~ Month)
plot2

# Boxplot of ozone by month, with whiskers
# Hint: What type of variable is month? Boxplots require 1 cateogrical variables and 
# 1 continuous variable
plot3<-ggplot(clean_df, aes(x=as.factor(Month), y=Ozone))+ 
  geom_boxplot()
plot3

# Scatterplot of ozone as a function of temperature
plot4<-ggplot(clean_df, aes(x=Temp, y=Ozone))+
  geom_point()
plot4

# Now colour the points by month
plot5<-ggplot(clean_df, aes(x=Temp, y=Ozone, color=as.factor(Month)))+
  geom_point()
plot5
# This uses the default R colours

# Extra code for changing the colour palletts
# You can use a colour or a hexcode (e.g.#fc120c )
plot5<-ggplot(clean_df, aes(x=Temp, y=Ozone, color=as.factor(Month)))+
  geom_point()+
  scale_color_manual(values=c("blue","#fc120c","yellow","orange","purple"))
plot5

# or you can use pre-created colour palletts
install.packages("viridis")
library(viridis)

plot6<-ggplot(clean_df, aes(x=Temp, y=Ozone, color=as.factor(Month)))+
  geom_point()+
  scale_color_viridis(discrete=TRUE)+
  theme_bw()+
  xlab("Temperature")+
  xlab("Ozone")+
  labs(colour = "Months") 
plot6

# Matrix of scatterplots of all pairs of variables in air quality dataset
pairs(clean_df, panel = panel.smooth)

# Think of some hyoptheses that that could be tested. We will work on these next week. 