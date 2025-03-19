# Sentiment Analysis of Consumer Complaints

## Author - Abhib Lal Amatya

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
|-|:--: |
|1| received |
|2| capital |
|3| one |
|4| charge |
|5| card |
|6| offer |
|7| applied |
|8| accepted |
|9| limit |
|10| activated |

## Data Analysis

### Bing Lexicon

1. ![sentiment_score](https://github.com/user-attachments/assets/8073c932-5bbb-4c0b-a1ee-ec788fb37b3d)

* The chart shows the sentiment analysis of consumer complaints, where most sentiment scores are negative, indicating widespread dissatisfaction. 
* There is high variability in scores, with some complaints showing extreme negativity and very few having neutral or slightly positive sentiment. 
* This suggests that complaints are overwhelmingly negative, which is expected.
* Further analysis could help identify the most common issues, trends over time, and comparisons with general customer feedback to gain deeper insights into consumer concerns.

### Using Pie Chart to make the disctinction clearer 

2. ![pv+ vs n-](https://github.com/user-attachments/assets/f1f4aa94-7ffa-4a66-8e84-ac3cb83c8a39)
* The pie chart illustrates the proportion of positive and negative sentiments in consumer complaints.
* The majority of the complaints are negative, as shown by the larger red section, while a smaller portion is positive.
* This indicates that consumers primarily express dissatisfaction in their feedback.
* Analyzing the reasons behind the negative sentiment could help identify key issues and improve customer experience.

#### Bing lexicon categorizes words into binary form - positive and negative. So I also used NRC Lexicon because it categorizes words into eight emotions. Since NRC covers multiple emotions, it provides a more nuanced understanding of sentiment beyong just binary classification.

### NRC Lexicon
![nrc_analysis](https://github.com/user-attachments/assets/ce4e390b-6efc-4c6e-8faa-6df766ac6ffb)

* The bar chart displays sentiment analysis using the NRC lexicon.
* Positive sentiment and trust are the most frequently expressed emotions.
* The analysis highlights diverse emotional responses in consumer complaints.
* Understanding these sentiments can help businesses improve customer relations.

### Word Cloud
![word_cloud](https://github.com/user-attachments/assets/619fdd8e-362c-4630-8cd9-bff33ad37d2d)

This visualization shows that most common words in the consumer complaints. The criteria to appear in this word cloud is that the words should appear at least 50 times in the complaints. On the pre-cleaned data, the most common words were XXXX, XXXXX, XXX which were simply hidden numbers that are confidential. So I removed those words so that it wouldn't interfere with my analysis.

## Conclusion
* Negative sentiment outweighs positive sentiment, indicating that complaints and criticisms dominate the dataset.
* Reveals that while trust and anticipation are significant, negative emotions like sadness, anger, and fear are also prominent. This suggests that while some customers have faith in the service provider, many express frustration and dissatisfaction.
* Customers mostly have complains about credit, account, loan, bank and payment
  



