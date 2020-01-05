#############################################################
# Introduction to R 
# By: Kristin Eccles
# Written in R 3.5.0
#############################################################

#### Vectors  ####
# Basic Operations
2 + 2 # addition
3 - 5 # subtraction
3 * 2 # multiplication
(2 + 2)^(3 / 3.5) # exponents and brackets

#You can construct longer vectors using the c(...) function (c stands for “combine.”)
# Create a vector of the prime number
primes <- c(2, 3, 5, 7, 11, 13)

# Now we can do operations on this vector
primes
primes + 1
primes / 2
primes == 3

#You can also enter expressions with characters:
"Hello world."
#This is called a character vector in R.
c("Hello world", "Hello R interpreter")

# Factor
kids = factor(c(1,0,1,0,0,0), levels = c(0, 1),
                labels = c("boy", "girl"))
kids

# you can covert numbers (coded variables) to factors using as.factor(varname) 
# or can convert cateogrical data to numeric using as.numberic(varname)

#Numeric
as.numeric(kids)

#### Martrix ####
# a matrix is a 2D array
mymatrix = matrix(1:6, nrow=3, ncol =2)
mymatrix
# try changing the ncol. What happens?

##### Functions ####
length(primes)
sum(primes)
mean(primes) 
sd(primes)
var(primes)
summary(primes)

#### Dataframe ####
teams <- c("PHI","NYM","FLA","ATL","WSN")
wins <- c(92, 89, 94, 72, 59)
loses <- c(70, 73, 77, 90, 102)
df <- data.frame(teams,wins,loses)
df

# Referencing 
# The $ sign is used to reference a column by name 
df$teams
# just a certain columns
df[,2:3]
# reference certain rows
df[2:3,]
#reference certain rows and columns
df[1:2,1:2]

# calculate average of wins
mean(df[,2])
# calculate average of wins and losses for year team
rowMeans(df[,2:3])

# we can then add this as a new column
df$w_l_avg <- rowMeans(df[,2:3])
df




