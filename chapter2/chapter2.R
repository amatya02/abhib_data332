install.packages("ggplot2")

qplot

library("ggplot2")
qplot

#figure 3.1
x <- c(-1, -0.8, -0.6, -0.4, -0.2, 0, 0.2, 0.4, 0.6, 0.8, 1)
x
y <- x^3
y

qplot(x,y)

#figure 3.2
x <- c(1, 2, 2, 2, 3, 3)
qplot(x, binwidth = 1)

x2 <- c(1, 1, 1, 1, 1, 2, 2, 2, 2, 3, 3, 4)
qplot(x2, binwidth = 1)

#exercise 3.1
x3 <- c(0, 1, 1, 2, 2, 2, 3, 3, 4)
replicate(3, 1 + 1)

#defining roll function
roll <- function() {
  die <- 1:6
  dice <- sample(die, size = 2, replace = TRUE) 
  sum(dice) 
}
replicate(10, roll())

#replicating
rolls <- replicate(10000, roll())
qplot(rolls, binwidth = 1)

#getting help
?sqrt
?log10
?sample

??log
?sample

#exercise 3.2
roll <- function() {
  die <- 1:6
  dice <- sample(die, size = 2, replace = TRUE)
  prob = c(1/8, 1/8, 1/8, 1/8, 1/8, 3/8)
  sum(dice)
}

#figure 3.5
rolls <- replicate(10000, roll())
qplot(rolls, binwidth = 1)


