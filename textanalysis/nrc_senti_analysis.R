# sentiment analysis using bing lexicon

# install packages and load libraries
install.packages('syuzhet')
install.packages('tm')
library(dplyr)
library(tidytext)
library(janeaustenr)
library(stringr)
library(tidyverse)
library(wordcloud)
library(syuzhet)
library(tm)
library(ggplot2)

# set up working directory and load & read the csv file
rm(list=ls())
setwd("~/Documents/r_projects/textanalysis/data")
df_words <- read.csv("clean_data.csv", stringsAsFactors = FALSE)

# sentiment analysis using NRC 

# analysis 1
sent_nrc <- df_words %>% 
  inner_join(get_sentiments("nrc")) %>% 
  count(sentiment, sort = TRUE)

sent_nrc %>% 
  ggplot(aes(x = reorder(sentiment, n), y = n, fill = sentiment)) + 
  geom_col(show.legend = FALSE) + 
  coord_flip() + 
  labs(title = "Sentiment Analysis (NRC)", x = "Sentiment", y = "Count")