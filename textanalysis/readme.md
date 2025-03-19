# Sentiment Analysis of Consumer Complaints

## Author
Abhib Lal Amatya

## Introduction
I will use tidytext package in R Studio to analyze consumer complaints using NRC and Bing Lexicons to find the polarity of the complaints.

## Dictionary 
The column that was used after tidying is:
Consumer.complaint.narrative: complaints sent by consumers in its original format

## Data Cleaning
Cleaned version of the original data set (df) created by filtering out missing values in "Consumer.complaint.narrative" column and selecting only that column

```
df_clean <- df %>% 
  filter(!is.na(Consumer.complaint.narrative) & Consumer.complaint.narrative != "") %>% 
  select(Consumer.complaint.narrative)

```

## Data Pre-processing
Remove punctuation, extra spaces and numbers

```
df_clean$Consumer.complaint.narrative <- df_clean$Consumer.complaint.narrative %>% 
  str_replace_all("[[:punct:]]", "") %>%  # remove punctuation
  str_replace_all("[[:digit:]]", "") %>%  # remove numbers
  str_squish()

```

## Remove Stopwords 
Remove words such as (the, an, I, me, you) to focus on more significant words.
```
df_clean <- df_clean %>% 
  mutate(Consumer.complaint.narrative = removeWords(Consumer.complaint.narrative, stop_words$word))

```

## Tokenization
Convert full complaint texts into tidy format where each row represents a single word (token) to better analyze word frequency, sentiments and trends

```
df_words <- df_clean %>% 
  unnest_tokens(word, Consumer.complaint.narrative)

# remove custom unwanted words (eg: "XXXX", "XXX", "XXXXX") because they appear the most but do not add value to our analysis
df_words <- df_words %>% 
  filter(!str_detect(word, "^x+$"))

```

## Export to CSV file

```
write.csv(df_words, "~/Documents/r_projects/textanalysis/clean_data.csv", row.names = FALSE)

```
---
## Data Summary
| | Word |

