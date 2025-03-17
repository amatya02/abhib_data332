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
df <- read.csv("Consumer_Complaints.csv", stringsAsFactors = FALSE)

# data cleaning: cleaned version of the original data set (df) created by filtering out missing values in "Consumer.complaint.narrative" column and selecting only that column
df_clean <- df %>% 
  filter(!is.na(Consumer.complaint.narrative) & Consumer.complaint.narrative != "") %>% 
  select(Consumer.complaint.narrative)

# data pre-processing: remove punctuation, extra spaces and numbers
df_clean$Consumer.complaint.narrative <- df_clean$Consumer.complaint.narrative %>% 
  str_replace_all("[[:punct:]]", "") %>%  # remove punctuation
  str_replace_all("[[:digit:]]", "") %>%  # remove numbers
  str_squish()                            # remove extra spaces

# remove stopwords: remove words such as (the, an, I, me, you) to focus on more significant words
df_clean <- df_clean %>% 
  mutate(Consumer.complaint.narrative = removeWords(Consumer.complaint.narrative, stop_words$word))

# tokenization: convert full complaint texts into tidy format where each row represents a single word (token) to better analyze word frequency, sentiments and trends
df_words <- df_clean %>% 
  unnest_tokens(word, Consumer.complaint.narrative)

# remove custom unwanted words (eg: "XXXX", "XXX", "XXXXX") because they appear the most but do not add value to our analysis
df_words <- df_words %>% 
  filter(!str_detect(word, "^x+$"))

write.csv(df_words, "~/Documents/r_projects/textanalysis/clean_data.csv", row.names = FALSE)