# loading libraries
library(ggplot2)
library(dplyr)
library(tidyverse)
library(readxl)
library(tidyr)

rm(list=ls())

# setting working directory
setwd('~/Documents/r_projects/more_trucking')


# loading data

df_truck_1769 <- read_excel('truck data 1769.xlsx', 
                            sheet = 2, skip = 3, .name_repair = "universal")

df_truck_0001 <- read_excel('truck data 0001.xlsx', 
                            sheet = 2, skip = 3, .name_repair = "universal")

df_pay <- read_excel('Driver Pay Sheet.xlsx', .name_repair = "universal")

df_truck_1478 <- read_excel('truck data 1478.xlsx', 
                            sheet = 2, skip = 3, .name_repair = "universal")

df_truck_1226 <- read_excel('truck data 1226.xlsx', 
                            sheet = 2, skip = 3, .name_repair = "universal")

df_truck_1442 <- read_excel('truck data 1442.xlsx', 
                            sheet = 2, skip = 3, .name_repair = "universal")

df_truck_0369 <- read_excel('truck data 0369.xlsx', 
                            sheet = 2, skip = 3, .name_repair = "universal")

df_truck_1539 <- read_excel('truck data 1539.xlsx', 
                            sheet = 2, skip = 3, .name_repair = "universal")

# union data

df_union <- rbind(df_truck_0001, df_truck_0369, df_truck_1226, df_truck_1442, 
            df_truck_1478, df_truck_1539, df_truck_1769)
# joining pay data

df_union <- left_join(df_union, df_pay, by = c('Truck.ID'))

# counting locations

# extracting city names from starting locations

df_starting <- df_union %>%
  mutate(location = str_trim(gsub(",.*", "", Starting.Location))) %>%  
  count(location, name = "starting_count")

# extracting city names from delivery locations

df_delivery <- df_union %>%
  mutate(location = str_trim(gsub(",.*", "", Delivery.Location))) %>%  
  count(location, name = "delivery_count")

# combining counts
locations <- full_join(df_starting, df_delivery, by = "location") %>%
  mutate(total = rowSums(select(., starting_count, delivery_count), na.rm = TRUE))

# calculating driver pay
df_driverpay <- df %>%
  group_by(Truck.ID, first, last) %>%
  summarize(
    total_miles = sum(Odometer.Ending - Odometer.Beginning, na.rm = TRUE),
    labor_per_mil = first(labor_per_mil),  
    .groups = 'drop'
  ) %>%
  mutate(total_pay = total_miles * labor_per_mil)

# bar chart

ggplot(df_driverpay, aes(
  x = reorder(paste(first, last), total_pay),  
  y = total_pay,
  fill = factor(Truck.ID)  
)) +
  geom_col() +
  scale_fill_brewer(palette = "Set1") + 
  labs(
    title = "Driver Pay",
    x = "Driver",
    y = "Total Pay ($)",
    fill = "Truck ID"
  ) +
  theme_minimal() +
  theme(axis.text.x = element_text(angle = 60, hjust = 1))
