# sentiment analysis using bing lexicon

# install packages and load libraries
install.packages('syuzhet')
install.packages('tm')
install.packages("lubridate")
library(dplyr)
library(tidytext)
library(janeaustenr)
library(stringr)
library(tidyverse)
library(wordcloud)
library(syuzhet)
library(tm)
library(ggplot2)
library(lubridate)
# set up working directory and load & read the csv file
rm(list=ls())
setwd("~/Documents/r_projects/textanalysis/data")
df_words <- read.csv("clean_data.csv", stringsAsFactors = FALSE)

# analysis 1: sentiment scores

sent_bing1 <- df_words%>%
  inner_join(get_sentiments("bing")) %>%  # join with bing sentiment lexicon
  mutate(index = row_number() %/% 80) %>% # create an index for grouping
  count(index, sentiment) %>%             # count occurrences of positive/negative words
  pivot_wider(names_from = sentiment, values_from = n, values_fill = 0) %>%
  mutate(sentiment_score = positive - negative) # calculate net sentiment score

ggplot(sent_bing1, aes(index, sentiment_score, fill = 'orange' )) +
  geom_col(show.legend = FALSE) +
  labs(title = "Sentiment Analysis of Consumer Complaints",
       x = "Index (Grouped Complaints)",
       y = "Sentiment Score") +
  theme_minimal()

# since all the sentiment scores are negative, it means that the consumer complaints predominantly contain more negative words than positive words according to the bing sentiment lexicon.
# this is even more clear with the following proportional analysis

# analysis 2: sentiment proportion

sent_bing2 <- df_words %>%
  inner_join(get_sentiments("bing"), by = "word") %>%
  count(sentiment) %>%
  mutate(proportion = n / sum(n))  # Calculate proportion

ggplot(sent_bing2, aes(x = "", y = proportion, fill = sentiment)) +
  geom_bar(stat = "identity", width = 1) +
  coord_polar(theta = "y") +  # Convert to pie chart
  theme_void() +
  labs(title = "Sentiment Proportion (Positive vs Negative)")
