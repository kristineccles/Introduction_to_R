#############################################################
# Lecture 2 Exercise 1 - Introduction to R 
#############################################################
# Load Libraries
library(datasets)
library(OneR)
library(ggplot2)
library(psych) 
library(car) 
library(corrplot)
library(stats)
library(lmtest)
library(factoextra)

# Load the data
df=airquality

# Is there any missing data?
df_clean=na.omit(df)

# Do you need to modify the data in any way?
#for the sake of doing a t-test we need to dive up temp to high and low 
df_clean$temp_bin=bin(df_clean$Temp, nbins = 2, labels = c('low','high'), method = c("content"))

# Any other modifications?
df_clean$month_cat=as.factor(df_clean$Month)

df_clean$log_ozone=log10(df_clean$Ozone)

#############################################################
# Exploratory Data Analysis
#### Descriptive Statistcs ####
summary(df_clean)

describe(df_clean)

# Make a histogram for all continuous variables
multi.hist(df_clean[,1:6])

# Do you think there might be any issues meeting assumptions? 

#### T-Test #####
# plot the data
plot1 = ggplot(df_clean, aes(x=temp_bin, y=log_ozone))+
  geom_boxplot()
plot1

# Test assumptions
# test for normality of raw data
shapiro.test(df_clean$Ozone)

# If you fail try a transofmration
shapiro.test(log10(df_clean$Ozone))

# test homogenity of variance
leveneTest(log_ozone ~ temp_bin, data=df_clean)
# the variance is homogenous between the two groups


# Run the T-test
t.test(log_ozone ~ temp_bin, data=df_clean)

# Is the test significant?

# Can you interpret the results?

#### ANOVA ####
# plot the data 
plot2 = ggplot(df_clean, aes(x=month_cat, y=log_ozone))+
  stat_boxplot(geom ='errorbar') + 
  geom_boxplot()+
  # add error bars to the plot
  xlab("Month")+
  ylab("Ozone")+
  theme_minimal()
plot2

# What are the little black dots on this plot?

# Test assumptions
# test for normality of raw data
shapiro.test(df_clean$log_ozone)
# fail
hist(df_clean$log_ozone)
# not normal but ok

# test homogenity of variance
leveneTest(log_ozone ~ month_cat, data=df_clean)
# the variance is homogenous between the groups

# This is a typeI anova- testing between groups
anova1=anova(lm(log_ozone ~ month_cat, data=df_clean))
anova1
# Is the test significant? Should we do a post-hoc follow up?

# p-value is low so we reject the H0, there is a difference between the groups
# need to follow this up with a Tukey's post-hoc test
Tukey1= TukeyHSD(aov(log_ozone ~ month_cat, data=df_clean))
Tukey1

# plot the differences
plot(Tukey1)

#What is your interpreation of these results?
# 7-5, 8-5, and 9-7 are different 
# This pattern appears to be early and late months- this may have something to do with temperature

#### Correlation #####
cor=cor(df_clean [,1:6])
cor
# visualize the correlations using corrplot
corrplot(cor)

# testing single correlation
?cor.test
cor.test(df_clean$Temp, df_clean$log_ozone)

#What is your interpreation of these results?
# positive association between Temp and Ozone

#### Linear Regression ####
# Make a plot
ggplot(data = df_clean, aes(x = Temp, y = log_ozone)) + 
  geom_point(color='blue') +
  geom_smooth(method = "lm", se = TRUE)
# Looks pretty linear

# Linear model
lm1=lm(log_ozone~Temp, data=df_clean)
summary(lm1)

# test assumptions on RESIDUALS
resettest(lm1) # pass
dwtest(lm1) # pass
bptest(lm1) # fail
shapiro.test(resid(lm1)) # fail
hist(resid(lm1))

# Are there any other variables that can be used?
lm2 = lm(log_ozone~Temp+Wind+Solar.R, data=df_clean)
summary(lm2)

# test assumptions on RESIDUALS
resettest(lm2) # fail
dwtest(lm2) # fail
bptest(lm2) # pass
shapiro.test(resid(lm2)) # pass
hist(resid(lm2))

vif(lm2)

# Adjusted R-squared:  0.655, p-value: < 2.2e-16

#### PCA ####
# Example 1 
pca1 = prcomp(df_clean[,1:6], center = TRUE, scale. = TRUE)
pca1

# plots 
# scree
fviz_eig(pca1)

# biplot
fviz_pca_biplot(pca1)
fviz_pca_biplot(pca1, label ="var", col.ind="cos2") +
  theme_minimal()

pca2 = prcomp(df_clean[,2:6], center = TRUE, scale. = TRUE)
pca2

# get the loadings (eigvenvectors)
loadings= pca2$rotation
loadings
