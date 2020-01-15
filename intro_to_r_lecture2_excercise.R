#############################################################
# Introduction to R 
# Lecture 2- Statistics
# By: Kristin Eccles
# Written in R 3.6.2
############################################################

# Install Libraries
# only need to run this once 
#install.packages(c("psych", "car", "stats", "corrplot", "factoextra","lmtest", "devtools"))

# Load Libraries
library(ggplot2)
library(psych) # describe and mutli.hist
library(car) #stats
library(corrplot)
library(stats)# cor, princomp, prcomp
library(lmtest)
library(factoextra) #pca plots

library(devtools) #pca plots
install_github("vqv/ggbiplot")
library(ggbiplot)

# Load data
# Dataset and metadata can be found at: https://archive.ics.uci.edu/ml/datasets/Abalone
# Abalone is a common name for any of a group of small to 
# very large sea snails, marine gastropod molluscs in the family Haliotidae

# Objective: Predicting the age of abalone from physical measurements

abalone=read.csv("abalone.csv")

#Modify the data to create a subset of just mature abalones (Male and Female)
abalone_mature=subset(abalone, sex=="M" | sex=="F")

#Modify the data to create a subset of male abalones
abalone_male=subset(abalone, sex=="M")

#Modify the data to create a subset of female abalones
abalone_female=subset(abalone, sex=="F")
#############################################################
# Exploratory data analysis
#### Descriptive Statistcs #####
summary(abalone)
# no missing data
describe(abalone)

# Make a histogram for all continuous variables
multi.hist(abalone[,2:9])

#### T-Test #####
# plot the data
plot1 = ggplot(abalone_mature, aes(x=sex, y=whole_weight))+
  geom_boxplot()
plot1

# Test assumptions
# test for normality of raw data
shapiro.test(abalone_mature$whole_weight)
# fail- these test are highly influenced by n
hist(abalone_mature$whole_weight)
# not normal but ok

# test homogenity of variance
leveneTest(whole_weight ~ sex, data=abalone_mature)
# the variance is not homogenous between the two groups- we must we the Welch's two sample t-test
# This is the default

# Run the T-test
t.test(data=abalone_mature,whole_weight~sex)

# There is a difference of 0.05g between male and females. On average this is 5.4% higher (difference/mean weight).
# While this is statistically significant it may not be biologically significant. 

#### ANOVA ####
# plot the data 
plot2 = ggplot(abalone, aes(x=sex, y=whole_weight))+
  geom_boxplot()
plot2

# Reorder factors
abalone$sex_order = factor(abalone$sex, levels = c("I", "F", "M"))

plot3 = ggplot(abalone, aes(x=sex_order, y=whole_weight))+
  stat_boxplot(geom ='errorbar') + 
  geom_boxplot()+
  # add error bars to the plot
  xlab("Sex")+
  ylab("Whole Weight (grams)")+
  theme_minimal()
plot3

# Test assumptions
# test for normality of raw data
shapiro.test(abalone$whole_weight)
# fail- these test are highly influenced by n
hist(abalone$whole_weight)
# not normal but ok

# sqrt the variable
abalone$sqrt_whole_weight = sqrt(abalone$whole_weight)
# test for normality of raw data
shapiro.test(abalone$sqrt_whole_weight)
# fail- these test are highly influenced by n
hist(abalone$sqrt_whole_weight)
# not normal but histogram looks better


# test homogenity of variance
leveneTest(sqrt_whole_weight ~ sex, data=abalone)
# the variance is not homogenous between the three groups
# This is the default


# This is a typeI anova- testing between groups
anova1=anova(lm(sqrt_whole_weight~sex, data=abalone))
anova1

# p-value is low so we reject the H0, there is a difference between the groups
# need to follow this up with a Tukey's post-hoc test
Tukey1= TukeyHSD(aov(sqrt_whole_weight~sex, data=abalone))
Tukey1
# I is lower than male and female- biologically this makes sense
# M is lower F - same results as above 

# plot the differences
plot(Tukey1)

#### Correlation #####
cor=cor(abalone_mature[,2:9])
cor
# visualize the correlations using corrplot
# https://cran.r-project.org/web/packages/corrplot/vignettes/corrplot-intro.html
corrplot(cor)

# testing single correlation
?cor.test
cor.test(abalone$age, abalone$shell_weight)

#### Linear Regression ####
# Make a plot
ggplot(data = abalone, aes(x = shell_weight, y = age)) + 
  geom_point(color='blue') +
  geom_smooth(method = "lm", se = TRUE)

# Make a plot
ggplot(data = abalone, aes(x = sqrt(shell_weight), y = sqrt(age))) + 
  geom_point(color='blue') +
  geom_smooth(method = "lm", se = TRUE)+
  stat_smooth(method = "lm", formula = y ~ poly(x, 2), size = 1, color="black")

# Linear model
lm1=lm(age~shell_weight, data=abalone)
summary(lm1)

# test assumptions on RESIDUALS
resettest(lm1) # fail
dwtest(lm1) # fail 
bptest(lm1) # fail
shapiro.test(resid(lm1)) # fail
hist(resid(lm1))

lm2=lm(sqrt(age)~sqrt(shell_weight), data=abalone)
summary(lm1)

# test assumptions on RESIDUALS
resettest(lm2) # fail
dwtest(lm2) # fail 
bptest(lm2) # fail
shapiro.test(resid(lm2)) # fail
hist(resid(lm2))
# still all fail but are better

# Maybe a non-linear curve would be a better fit?
# Make a plot
ggplot(data = abalone, aes(x = sqrt(shell_weight), y = sqrt(age))) + 
  geom_point(color='blue') +
  geom_smooth(method = "lm", se = TRUE)+
  stat_smooth(method = "lm", formula = y ~ poly(x, 2), size = 1, color="black")

lm2.1=lm(sqrt(age)~poly(sqrt(shell_weight),2), data=abalone)
summary(lm2.1)

# test assumptions on RESIDUALS
resettest(lm2.1) # fail
dwtest(lm2.1) # fail 
bptest(lm2.1) # fail
shapiro.test(resid(lm2.1)) # fail
hist(resid(lm2.1))
# still all fail 

# could we make this a multivariate regression?


#### PCA ####
# Example 1 
mtcars.pca <- prcomp(mtcars[,c(1:7,10,11)], center = TRUE,scale. = TRUE)

#Variance explained
summary(mtcars.pca)

# scree plot
ggscreeplot(mtcars.pca)

# Biplots
ggbiplot(mtcars.pca)

ggbiplot(mtcars.pca, labels=rownames(mtcars))

mtcars.country <- c(rep("Japan", 3), rep("US",4), 
                    rep("Europe", 7),rep("US",3), "Europe", rep("Japan", 3),
                    rep("US",4), rep("Europe", 3), "US", rep("Europe", 3))

# Biplot
ggbiplot(mtcars.pca,ellipse=TRUE,  labels=rownames(mtcars), groups=mtcars.country)
ggbiplot(mtcars.pca,ellipse=TRUE,choices=c(3,4),   
         labels=rownames(mtcars), groups=mtcars.country)

###
# Example 2 with abalone 
pca1 = prcomp(abalone[,2:8], center = TRUE, scale. = FALSE)
pca1

# plots 
fviz_eig(pca1)
fviz_pca_biplot(pca1, habillage=abalone$sex)
fviz_pca_biplot(pca1, habillage=abalone$sex)+
  scale_color_brewer(palette="YlOrRd") +
  theme_minimal()

# get the loadings (eigvenvectors)
loadings= pca1$rotation
loadings

# make a dataframe with age aand scores
# the scores The coordinates of the individuals (observations) on the principal components.
pca_scores= pca1$x
pca_lm=as.data.frame(cbind(abalone$age, pca_scores))

# linear regression
lm1=lm(V1~PC1+PC2, data=pca_lm)
summary(lm1)

lm1=lm(V1~PC1+PC2+PC3+PC4+PC5, data=pca_lm)
summary(lm1)

resettest(lm1) # fail
dwtest(lm1) # fail 
bptest(lm1) # fail
shapiro.test(resid(lm1)) # fail
hist(resid(lm1))

vif(lm1)


