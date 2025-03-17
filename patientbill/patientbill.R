# loading libraries
library(readxl)
library(dplyr)
library(ggplot2)
library(tidyr)

# load datasets
rm(list=ls())
setwd("~/Documents/r_projects/patientbill")
billing <- read_excel("Billing.xlsx")
patient <- read_excel("Patient.xlsx")
visit <- read_excel("Visit.xlsx")

# merge datasets with relational keys
visit_patient <- merge(visit, patient, by = "PatientID", all.x = TRUE)
full_data <- merge(visit_patient, billing, by = "VisitID", all.x = TRUE)

# convert date columns to date format
full_data$VisitDate <- as.Date(full_data$VisitDate)
full_data$InvoiceDate <- as.Date(full_data$InvoiceDate)

# extract month and year
full_data$Month <- format(full_data$VisitDate, "%B")
full_data$Year <- format(full_data$VisitDate, "%Y")

# sort months properly
full_data$Month <- factor(full_data$Month, levels = month.name)

# reason for visit by month
ggplot(full_data, aes(x = Month, fill = Reason)) +
  geom_bar(position = "stack") +
  scale_fill_manual(values = rainbow(length(unique(full_data$Reason)))) +
  labs(title = "Reason for Visit by Month",
       x = "Month", y = "Number of Visits") +
  theme(axis.text.x = element_text(angle = 45, hjust = 1))

# reason for visit based on walk-in or not
full_data$WalkInStatus <- ifelse(full_data$WalkIn, "Walk-In", "Not Walk-In")
ggplot(full_data, aes(x = Reason, fill = WalkInStatus)) +
  geom_bar(position = "dodge") +
  labs(title = "Reason for Visit Based on Walk-in Status",
       x = "Reason for Visit", y = "Count", fill = "Walk-in Status") +
  theme(axis.text.x = element_text(angle = 45, hjust = 1))

# reason for visit by city/state
ggplot(full_data, aes(x = City, fill = Reason)) +
  geom_bar(position = "stack") +
  scale_fill_manual(values = rainbow(length(unique(full_data$Reason)))) +
  labs(title = "Reason for Visit by City",
       x = "City", y = "Count") +
  theme(axis.text.x = element_text(angle = 45, hjust = 1))

# total invoice amount based on reason for visit, by payment status
full_data$InvoicePaidStatus <- ifelse(full_data$InvoicePaid, "Yes", "No")
ggplot(full_data, aes(x = Reason, y = InvoiceAmt, fill = InvoicePaidStatus)) +
  geom_bar(stat = "identity", position = "stack") +
  scale_fill_manual(values = c("purple", "blue")) +
  labs(title = "Total Invoice Amount Based on Reason for Visit",
       x = "Reason for Visit", y = "Total Invoice Amount", fill = "Invoice Paid") +
  theme(axis.text.x = element_text(angle = 45, hjust = 1))

# additional insight: average invoice amount by walk-in status
ggplot(full_data, aes(x = WalkInStatus, y = InvoiceAmt, fill = WalkInStatus)) +
  geom_bar(stat = "summary", fun = "mean", position = "dodge") +
  scale_fill_manual(values = c("cyan", "red")) +
  labs(title = "Average Invoice Amount by Walk-in Status",
       x = "Walk-in Status", y = "Average Invoice Amount") +
  theme_minimal()

# analysis: the graph shows that walk-in visits have considerably higher average invoice amount than not-walk-in visits

