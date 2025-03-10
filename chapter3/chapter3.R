# chapter 3

# install packages
install.packages("ggplot2")

# load packages
# will not find function unless the package is loaded
qplot 
# loading package
library("ggplot2")
qplot

# using qplot
x <- c(-1, -0.8, -0.6, -0.4, -0.2, 0, 0.2, 0.4, 0.6, 0.8, 1)
x

y <- x^3
y

qplot(x, y)

# creating histogram
x <- c(1, 2, 2, 2, 3, 3)
qplot(x, binwidth = 1)

x2 <- c(1, 1, 1, 1, 1, 2, 2, 2, 2, 3, 3, 4)
qplot(x2, binwidth = 1)

# exercise 3.1 - visualize a histogram
x3 <- c(0, 1, 1, 2, 2, 2, 3, 3, 4)

replicate(3, 1 + 1)

replicate(10, roll())

rolls <- replicate(10000, roll())
qplot(rolls, binwidth = 1)

# getting help
?sqrt
?log10
?sample

??log

# exercise 3.2 - roll a pair of dice

# writing the roll function

roll <- function() {
  die <- 1:6
  dice <- sample(die, size = 2, replace = TRUE)
  sum(dice)
}

# adding prob argument to the sample function instead of roll to sample the numbers one through five with probability 1/8 and the number 6 with probability 3/8.

roll <- function() {
  die <- 1:6
  dice <- sample(die, size = 2, replace = TRUE, 
                 prob = c(1/8, 1/8, 1/8, 1/8, 1/8, 3/8))
  sum(dice)
}

rolls <- replicate(10000, roll())
qplot(rolls, binwidth = 1)
 
# extra - comparing the histogram before and after using prob argument

roll_np <- function() {
  die <- 1:6
  dice <- sample(die, size = 2, replace = TRUE)
  sum(dice)
}

rolls_np <- replicate(10000, roll_np())
qplot(rolls_np, binwidth = 1)