# load necessary libraries
install.packages("writexl")
library(readxl)
library(dplyr)
library(writexl)
# Read the Excel file
setwd("~/Documents/r_projects/combined_cars")
data3 <- read_excel("type3.xlsx")
data4 <- read_excel("type4.xlsx")
data5 <- read_excel("type5.xlsx")
data1 <- read_excel("type1.xlsx")

# tidying data 3
# Transform
edited_data3 <- data3 %>%
  # 1) keep only the raw columns
  select(mph, vehicle_style, `if_they_slow_down_(YES/ NO)`) %>%
  
  # 2) rename & recode + add blank speed cols
  mutate(
    Initial_Speed = NA_real_,                    # blank
    Final_Speed   = mph,                         # rename mph → Final_Speed
    Difference    = NA_real_,                    # blank
    Slow = ifelse(
      `if_they_slow_down_(YES/ NO)` %in% c(TRUE, 1, "1", "TRUE", "Yes", "yes"),
      "YES", "NO"
    ),
    Body_Style = case_when(                      # rename & standardize
      tolower(vehicle_style) == "suv"          ~ "Suv",
      tolower(vehicle_style) == "pickup_truck" ~ "Truck",
      TRUE                                     ~ "Sedan"
    )
  ) %>%
  
  # 3) drop intermediate cols and reorder
  select(Initial_Speed, Final_Speed, Difference, Body_Style, Slow)

# tidying data 4

edited_data4 <- data4 %>%
  select(Initial_Read, Final_Read, Difference_In_Readings, Type_of_Car) %>%
  filter(!Type_of_Car %in% c(1, 7)) %>%
  mutate(
    Body_Style = case_when(
      Type_of_Car %in% c(2,3,8)  ~ "Sedan",
      Type_of_Car %in% c(4,5,6)  ~ "Suv",
      Type_of_Car %in% c(9,10)   ~ "Truck",
      TRUE                       ~ NA_character_
    ),
    Initial_Speed = Initial_Read,
    Final_Speed   = Final_Read,
    Difference    = Difference_In_Readings,
    Slow = case_when(
      Difference >  0        ~ "Yes",
      Difference <  0        ~ "No",
      is.na(Difference)      ~ NA_character_
    )
  ) %>%
  select(Initial_Speed, Final_Speed, Difference, Body_Style, Slow)


# tidying data 5

edited_data5 <- data5 %>%
  select(init_speed, final_speed, speed_change, vehicle_type) %>%
  rename(
    Initial_Speed = init_speed,
    Final_Speed   = final_speed,
    Difference    = speed_change,
    Body_Style    = vehicle_type
  ) %>%
  mutate(
    Slow = case_when(
      Difference >  0        ~ "Yes",
      Difference <  0        ~ "No",
      is.na(Difference)      ~ NA_character_
    )
  ) %>%
  select(Initial_Speed, Final_Speed, Difference, Body_Style, Slow)


# tidying data 1

# Transform:
edited_data1 <- data1 %>%
  select(Speed, `Type of Car`) %>%
  rename(
    Final_Speed = Speed,
    Body_Style  = `Type of Car`
  ) %>%
  mutate(
    Body_Style = case_when(
      Body_Style %in% c("SUV", "Van", "Minivan") ~ "Suv",
      Body_Style == "Coupe"                     ~ "Sedan",
      TRUE                                      ~ Body_Style
    ),
    Initial_Speed = NA_real_,
    Difference    = NA_real_,
    Slow = case_when(
      Difference >  0        ~ "Yes",
      Difference <  0        ~ "No",
      is.na(Difference)      ~ NA_character_
    )
  ) %>%
  select(Initial_Speed, Final_Speed, Difference, Body_Style, Slow)


# tidying data 2

aashish <- read_excel("type2.xlsx", sheet = "Aashish")
abhib   <- read_excel("type2.xlsx", sheet = "Abhib")
kritan  <- read_excel("type2.xlsx", sheet = "Kritan")

combined_data <- bind_rows(
  aashish %>% mutate(Group = "Aashish"),
  abhib   %>% mutate(Group = "Abhib"),
  kritan  %>% mutate(Group = "Kritan")
)
data2 <- combined_data %>% select(-Group)

# Add Slow column 
edited_data2 <- data2 %>%
  mutate(
    Slow = case_when(
      Difference >  0   ~ "Yes",
      Difference <  0   ~ "No",
      TRUE              ~ NA_character_
    )
  ) %>%
  select(Initial_Speed, Final_Speed, Difference, Body_Style, Slow)

# combining all data sets to form a master data set
# 1) Combine all five cleaned tibbles
master_data <- bind_rows(
  edited_data1,
  edited_data2,
  edited_data3,
  edited_data4,
  edited_data5
)

# 2) Write the result to an Excel file in your target folder
write_xlsx(
  master_data,
  path = "~/Documents/r_projects/combined_cars/master_data.xlsx"
)