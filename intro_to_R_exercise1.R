#############################################################
# Exercise 1 - Introduction to R 
# By: Kristin Eccles
# Written in R 3.5.0

#############################################################
# Load Libraries
# Requires the ggplot2 package that is not part of base installation
# To install the package, uncomment the following line
# install.packages("ggplot2", dependencies=TRUE)
library(ggplot2)

# Load data
# note this assumes data is in the same folder as script
sturgeon= read.csv("sturgeon.csv")

#############################################################
# Check to see if we have missing data
is.na(sturgeon)

# Summarize the contents of the sturgeon dataframe
summary(sturgeon)
# you will also see missing data in this summary 

# another way to take a look at the data is look at its sturcture
str(sturgeon)

#and finally, a check that the data itself (not summarized in any way) looks good
head(sturgeon)

# Clean the data (if necessary)
# create new dataset without missing data 
sturgeon_clean=na.omit(sturgeon)

#############################################################
# Visualize the data 
# Make a histogram of the variable fklngth in the sturgeon
# this uses the base R plotting 
hist(sturgeon_clean$fklngth)

# Make variables in the sturgeon data.frame directly callable by attaching
attach(sturgeon_clean)

# Redo the same histogram as before
ls()
hist(fklngth)

# use "sturgeon" dataframe to make plot called mygraph
# and define x axis as representing fklngth

plot1 <- ggplot(sturgeon_clean) +
  geom_histogram(aes(x = fklngth, y = ..density..),
                 binwidth = 10, fill = "grey", color = "black")
plot1
# Try changing the binwidth- what happens?

# Data distribution fklngth by subsets of sex and year
# split previous graph per year (rows) and sex (columns)
plot2 <- ggplot(sturgeon_clean) +
  geom_histogram(aes(x = fklngth, y = ..density..),
                 binwidth = 5, fill = "grey", color = "black")+
  facet_grid(sex ~ year)
plot2

# QQ plot of fklngth
qqnorm(fklngth)
qqline(fklngth)
# Are there outliers?

# Wilks-Shapiro test of normality on fklngth
shapiro.test(fklngth)

# Boxplot of fklngth by sex, with whiskers
# base graphics
boxplot(fklngth ~ sex, notch = TRUE)

#ggplot2 version
plot3<-ggplot(sturgeon_clean, aes(x=sex, y=fklngth))
plot3+ geom_boxplot()

# Scatterplot of fklngth as a function of age
# base graphics
plot(fklngth ~ age)

#ggplot2 version
plot4<-ggplot(sturgeon_clean, aes(x=age, y=fklngth))
plot4+ geom_point()

# Matrix of scatterplots of all pairs of variables in dataframe sturgeon, with lowess trace
pairs(sturgeon, panel = panel.smooth)

# Create a subset with only females captured in 1978
sturgeon.female.1978 <- subset(sturgeon_clean, sex == "FEMALE" &
                                 year == "1978")

# Create a histogram of fklngth from a subset for females in 1979 and 1980
mysubset = subset(sturgeon_clean, sex == "FEMALE" & (year == "1979" | year == "1980"))
hist(mysubset$fklngth)

