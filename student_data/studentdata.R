# load libraries
library(dplyr)
library(ggplot2)
library(readxl)
library(tidyr)

#load data and read data
rm(list=ls())
setwd("~/Documents/r_projects/studentdata")
course <- read_excel('~/Documents/r_projects/studentdata/Course.xlsx')
registration <- read_excel("Registration.xlsx")
student <- read_excel("Student.xlsx")

#left join data
merged_df <- registration %>% 
  left_join(student, by = "Student ID") %>% 
  left_join(course, by = "Instance ID")

#extract birth year
merged_df$`Birth Date` <- as.Date(merged_df$`Birth Date`)
merged_df$`Birth Year` <- format(merged_df$`Birth Date`, "%Y")

# pivot table
pivot_table <- merged_df %>% 
  group_by(Title, `Payment Plan`) %>% 
  summarise(
    TotalCost = sum(`Total Cost`, na.rm = TRUE),
    TotalBalanceDue = sum(`Balance Due`, na.rm = TRUE),
    AverageCost = mean(`Total Cost`, na.rm = TRUE),
    StudentCount = n()
  )

print(pivot_table)

# chart on the number of majors (TITLE)
ggplot(merged_df, aes(x = Title)) +
  geom_bar(fill = "steelblue") +
  labs(title = "Number of Students per Major", x = "Major", y = "Count") +
  theme(axis.text.x = element_text(angle = 80, hjust = 1))

# chart on the birth year of the student
ggplot(merged_df, aes(x = as.numeric(`Birth Year`))) +
  geom_histogram(binwidth = 5, fill = "orange", color = "black") +
  labs(title = "Distribution of Students' Birth Years", x = "Birth Year", y = "Count")

# total cost per major, segmented by payment plan
total_cost <- merged_df %>% 
  group_by(Title, `Payment Plan`) %>% 
  summarise(TotalCost = sum(`Total Cost`, na.rm = TRUE))

ggplot(total_cost, aes(x = Title, y = TotalCost, fill = factor(`Payment Plan`))) +
  geom_bar(stat = "identity", position = "dodge") +
  labs(title = "Total Cost per Major Segmented by Payment Plan", x = "Major", y = "Total Cost") +
  scale_fill_manual(values = c("green", "red"), labels = c("No Payment Plan", "Payment Plan")) +
  theme(axis.text.x = element_text(angle = 80, hjust = 1.2)) +
  scale_y_continuous(labels = scales::comma, breaks = seq(0, max(total_cost$TotalCost, na.rm = TRUE), by = 50000))

# total balance due by major, segmented by payment plan
total_balance <- merged_df %>% 
  group_by(Title, `Payment Plan`) %>% 
  summarise(TotalBalance = sum(`Balance Due`, na.rm = TRUE))

ggplot(total_balance, aes(x = Title, y = TotalBalance, fill = factor(`Payment Plan`))) +
  geom_bar(stat = "identity", position = "dodge") +
  labs(title = "Total Balance Due by Major Segmented by Payment Plan", x = "Major", y = "Balance Due") +
  scale_fill_manual(values = c("purple", "blue"), labels = c("No Payment Plan", "Payment Plan")) +
  theme(axis.text.x = element_text(angle = 80, hjust = 1.2)) +
  scale_y_continuous(labels = scales::comma, breaks = seq(0, max(total_cost$TotalCost, na.rm = TRUE), by = 5000))

# more insights

# average cost per payment plan by major
avg_cost <- merged_df %>% 
  group_by(Title, `Payment Plan`) %>% 
  summarise(AverageCost = mean(`Total Cost`, na.rm = TRUE))

ggplot(avg_cost, aes(x = Title, y = AverageCost, fill = factor(`Payment Plan`))) +
  geom_bar(stat = "identity", position = "dodge") +
  labs(title = "Average Cost per Major Segmented by Payment Plan", x = "Major", y = "Average Cost") +
  scale_fill_manual(values = c("pink", "black"), labels = c("No Payment Plan", "Payment Plan")) +
  theme(axis.text.x = element_text(angle = 45, hjust = 1)) +
  scale_y_continuous(labels = scales::comma, breaks = seq(0, max(total_cost$TotalCost, na.rm = TRUE), by = 2000))

# total cost by major and payment plan - stacked bar chart
ggplot(total_cost, aes(x = Title, y = TotalCost, fill = factor(`Payment Plan`))) +
  geom_bar(stat = "identity") +
  labs(title = "Total Cost by Major (Stacked) Segmented by Payment Plan", x = "Major", y = "Total Cost") +
  scale_fill_manual(values = c("cyan", "coral2"), labels = c("No Payment Plan", "Payment Plan")) +
  theme(axis.text.x = element_text(angle = 45, hjust = 1)) +
  scale_y_continuous(labels = scales::comma, breaks = seq(0, max(total_cost$TotalCost, na.rm = TRUE), by = 50000))

# payment plan proportion by major
total_cost_percent <- total_cost %>% 
  group_by(Title) %>% 
  mutate(Percentage = TotalCost / sum(TotalCost) * 100)

ggplot(total_cost_percent, aes(x = Title, y = Percentage, fill = factor(`Payment Plan`))) +
  geom_bar(stat = "identity") +
  labs(title = "Payment Plan Proportion by Major (Percent Stacked)", x = "Major", y = "Percentage") +
  scale_fill_manual(values = c("brown1", "darkcyan"), labels = c("No Payment Plan", "Payment Plan")) +
  theme(axis.text.x = element_text(angle = 45, hjust = 1)) +
  scale_y_continuous(labels = scales::comma, breaks = seq(0, max(total_cost$TotalCost, na.rm = TRUE), by = 10))

