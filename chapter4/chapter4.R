# need to write a function that selects the first row of values in data frame like deal(deck)

# selecting values
deck[,]

# positive integers
head(deck)
deck[1,1]

# extract more than one value, use vector of positive integers
deck[1, c(1, 2, 3)]

# saving new set to an r object with r's assignment operator
new <- deck[1, c(1, 2, 3)]
new

# subset a vector with a single index
vec <- c(6, 1, 3, 6, 10, 5)
vec[1:3]

# selecting two or more columns from a data frame
deck[1:2, 1:2]

# if a single column is selected, r will return a vector
deck[1:2, 1]

# optional argument drop = FALSE
deck[1:2, 1, drop = FALSE]

# negative integers
deck[-(2:52), 1:3]

# r will return an error if we try to pair negative integer with a positive integer in the same index
deck[c(-1, 1), 1]

# zero
deck[0, 0]

# blank spaces
deck[1, ] 

# logical values
deck[1, c(TRUE, TRUE, FALSE)]

rows <- c(TRUE, F, F, F, F, F, F, F, F, F, F, F, F, F, F, F,
          F, F, F, F, F, F, F, F, F, F, F, F, F, F, F, F, F, F, F, F, F, F,
          F, F, F, F, F, F, F, F, F, F, F, F, F, F)
deck[rows, ]

# names
deck[1, c("face", "suit", "value")]
deck[ , "value"]

# exercise
# deal a card
deal <- function(cards) {
  cards[1, ]
}

# function becomes less impressive if you run deal over and over again
deal(deck)

# shuffle the deck
deck2 <- deck[1:52, ]
head(deck2)

#extract the rows in a different order
deck3 <- deck[c(2, 1, 3:52), ]
head(deck3)

# generating random collection of integers
random <- sample(1:52, size = 52)
random

deck4 <- deck[random, ]
head(deck4)

# exercise
# shuffle functions
shuffle <- function(cards) {
  random <- sample(1:52, size = 52)
  cards[random, ]
}

# shuffling cards between each deal
deal(deck)
deck2 <- shuffle(deck)
deal(deck2)

# dollar signs and double brackets
deck$value
mean(deck$value)
median(deck$value)

# use the same $ notation with elements of a list
lst <- list(numbers = c(1, 2), logical = TRUE, strings = c("a", "b", "c"))
lst

# subset it
lst[1]

# will return an error
sum(lst[1])

# use $ notation to return the selected values as they are
lst$numbers

# immediately feed the results to a function
sum(lst$numbers)

# can use two brackets if elements in the list do not have names
lst[[1]]

# single brackets vs double brackets
lst["numbers"]
lst[["numbers"]]

