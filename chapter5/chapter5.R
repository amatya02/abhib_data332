# changing values in place
vec <- c(0, 0, 0, 0, 0, 0)
vec

# selecting first value of vec
vec[1]

# modification 
vec[1] <- 1000
vec

# replacing multiple values at once
vec[c(1, 3, 5)] <- c(1, 1, 1)
vec

vec[4:6] <- vec[4:6] + 1
vec

# creating values that do not exist yet
vec[7] <- 0
vec

# creating suffle and deck2 
shuffle <- function(cards) {
  random <- sample(1:52, size = 52)
  cards[random, ]
}
deck2 <- shuffle(deck)

# adding new variables to data set
deck2$new <- 1:52
head(deck2)

# removing columns from a data frame by assigning them the symbol NULL
deck2$new <- NULL
head(deck2)

# change value of aces from 1 to 14
deck2[c(13, 26, 39, 52), ]

# single out just the values of aces by subsetting the columns dimensions of deck2
deck2[c(13, 26, 39, 52), 3]

deck2$value[c(13, 26, 39, 52)]

# assign new sets of values to these old values
deck2$value[c(13, 26, 39, 52)] <- c(14, 14, 14, 14)
# or
deck2$value[c(13, 26, 39, 52)] <- 14
head(deck2, 13)

# shuffling deck again
deck3 <- shuffle(deck)
head(deck3)
  
# logical subsetting
vec
vec[c(FALSE, FALSE, FALSE, FALSE, TRUE, FALSE, FALSE)]

# logical tests
1 > 2
1 > c(0, 1, 2)
c(1, 2, 3) == c(3, 2, 1)

1 %in% c(3, 4, 5)
c(1, 2) %in% c(3, 4, 5)
c(1, 2, 3) %in% c(3, 4, 5)
c(1, 2, 3, 4) %in% c(3, 4, 5)

# exercise1
# extracting face column with R's $ notation
deck2$face

# using == operator to test whether each value is equal to ace
deck2$face == "ace"

# using sum to quickly count the numbers of True in the previous vector
sum(deck2$face == "ace")

# spot and change aces in deck
deck3$face == "ace"

# single out ace point values
deck3$value[deck3$face == "ace"]

# using assignment to change the ace values in deck3
deck3$value[deck3$face == "ace"] <- 14
head(deck3)

# putting logical subsetting to use with a new game
deck4 <- deck
deck4$value <- 0
head(deck4, 13)

# exercise2
deck4$suit == "hearts"

# using test to select the values of these cards
deck4$value[deck4$suit == "hearts"]

#assign a new number to these values
deck4$value[deck4$suit == "hearts"] <- 1
  
#all hearts cards have been updated
deck4$value[deck4$suit == "hearts"]

# finding all queens          
deck4[deck4$face == "queen", ]

# finding all spades
deck4[deck4$suit == "spades", ]

# when used with vectors, boolean operators will follow the same element-wise execution as arithmetic and logical operators
a <- c(1, 2, 3)
b <- c(1, 2, 3)
c <- c(1, 2, 4)
a == b

b == c

a == b & b == c

# using boolean operators to locate queen of spades in deck
deck4$face == "queen" & deck4$suit == "spades"
queenOfSpades <- deck4$face == "queen" & deck4$suit == "spades"

# using the test as an index to select the value of the queen of spades
deck4[queenOfSpades, ]
deck4$value[queenOfSpades]

# updating queens value
deck4$value[queenOfSpades] <- 13
deck4[queenOfSpades, ]

# exercise3
w <- c(-1, 0, 1)
x <- c(5, 15)
y <- "February"
z <- c("Monday", "Tuesday", "Friday")

w > 0
10 < x & x < 20
y == "February"
all(z %in% c("Monday", "Tuesday", "Wednesday", "Thursday", "Friday",
             "Saturday", "Sunday"))

# blackjack
deck5 <- deck
head(deck5, 13)

# changing value of face cards in one fell swoop
facecard <- deck5$face %in% c("king", "queen", "jack")
deck5[facecard, ]

deck5$value[facecard] <- 10
head(deck5, 13)

# missing information
# NA an be used as placeholder for missing information
1 + NA

# r will return a second piece of missing information
NA == 1

# na.rm
c(NA, 1:50)
mean(c(NA, 1:50))

mean(c(NA, 1:50), na.rm = TRUE)

# is.na
NA == NA
c(1, 2, 3, NA) == NA
is.na(NA)
vec <- c(1, 2, 3, NA)
is.na(vec)

# seting ace values to NA in the same way like setting them to a number
deck5$value[deck5$face == "ace"] <- NA
head(deck5, 13)

