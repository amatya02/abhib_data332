# word cloud

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

wordcloud(words = df_words$word, min.freq = 50, max.words = 200, colors = brewer.pal(8, "Dark2"))
