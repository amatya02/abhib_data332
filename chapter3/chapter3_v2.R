#int and string
int <- c(-1L, 2L, 4L)
int

text <- c("Hello", "World")
text

typeof(int)
typeof(text)

#exercise: atomic vector that stores just the face names of the cards in a royal flush
hand <- c("ace", "king", "queen", "jack", "ten")
hand

typeof(hand)

#exercise: matrix which stores the name and suit of every card in a royal flush
hand1 <- c("ace", "king", "queen", "jack", "ten", "spades", "spades", "spades", "spades", "spades")
matrix(hand1, nrow = 5)
matrix(hand1, ncol = 2)
dim(hand1) <- c(5, 2)

hand2 <- c("ace", "spades", "king", "spades", "queen", "spades", "jack", "spades", "ten", "spades")
matrix(hand2, nrow = 5, byrow = TRUE)
matrix(hand2, ncol = 2, byrow = TRUE)

#exercise: virtual playing card by combining "ace", "heart", and 1 into a vector.
#type of resulting atomic vector 
card <- c("ace", "hearts", 1)
card
typeof(card) # character type vector

card <- list("ace", "hearts", 1)
card
typeof(card) # list type vector

# data frame
df <- data.frame(face = c("ace", "two", "six"), 
                 suit = c("clubs", "clubs", "clubs"), value = c(1, 2, 3))
df

#deck.csv
write.csv(deck, file = "cards.csv, row.names = FALSE") # copy of the csv file stored to the designated folder

getwd() #"/Documents/r_projects/chapter3/deck"
