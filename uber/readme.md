# NYC Uber Data Analysis

## Overview

This project is a Shiny web application for exploring NYC Uber trip data (April–September 2014). It features interactive charts, tables, heatmaps, a geospatial map, and a predictive model.

## Features

Pivot Table: Trips by hour (0–23).

Line & Bar Charts: Trips by hour, day of month, day of week × month, and month.

Heatmaps: Hour vs. weekday, day vs. month, week vs. month, month vs. weekday, base vs. weekday.

Leaflet Map: Geospatial plot of pickup locations with clustering.

Predictive Model: Random Forest regression predicting hourly trip counts based on hour, weekday, and month.


## Required Packages

```
library(readr)  
library(dplyr)  
library(lubridate)
library(tidyr)
library(shiny)
library(DT)
library(ggplot2)
library(leaflet)
library(rsample)
library(parsnip)
library(workflows)
library(yardstick)
library(ranger)
```

## Loading and Preparing Data

```
urls <- c(
  "https://raw.githubusercontent.com/amatya02/abhib_data332/main/uber/uber-raw-data-apr14.csv.zip",
  "https://raw.githubusercontent.com/amatya02/abhib_data332/main/uber/uber-raw-data-aug14.csv.zip",
  "https://raw.githubusercontent.com/amatya02/abhib_data332/main/uber/uber-raw-data-jul14.csv.zip",
  "https://raw.githubusercontent.com/amatya02/abhib_data332/main/uber/uber-raw-data-jun14.csv.zip",
  "https://raw.githubusercontent.com/amatya02/abhib_data332/main/uber/uber-raw-data-may14.csv.zip",
  "https://raw.githubusercontent.com/amatya02/abhib_data332/main/uber/uber-raw-data-sep14.csv.zip"
)

# Create a folder to extract to
if (dir.exists("uber_data")) { 
  unlink("uber_data", recursive = TRUE) 
}
dir.create("uber_data")

# Function to download, unzip, and read each file
read_uber_data <- function(url) {
  tmp_zip <- tempfile(fileext = ".zip")
  download.file(url, tmp_zip, mode = "wb")
  unzip(tmp_zip, exdir = "uber_data")
  csv_file <- list.files("uber_data", pattern = "\\.csv$", full.names = TRUE)
  read_csv(csv_file[length(csv_file)])  # read the last extracted CSV
}

# binding all the data together
uber_data_list <- lapply(urls, read_uber_data)
combined_uber_data <- bind_rows(uber_data_list)
```

## Changing the date column to date schema

```
# changing the date column to date schema
combined_uber_data <- combined_uber_data %>%
  # 1) parse full timestamp into POSIXct
  mutate(
    datetime = mdy_hms(`Date/Time`),
    # 2) extract the hour (0–23) for grouping
    hour = hour(datetime)
  )
```
## Pivot table to display trips by hour
```
# 1. Parse and extract hour
uber_hourly <- combined_uber_data %>%
  mutate(
    datetime = mdy_hms(`Date/Time`),   # parse full timestamp
    hour     = hour(datetime)          # extract hour (0–23)
  )

# 2. Tally trips by hour
trips_by_hour <- uber_hourly %>%
  count(hour, name = "num_trips") %>%
  arrange(hour)

# 3. Pivot to wide format (columns 0 through 23)
pivot_trips <- trips_by_hour %>%
  pivot_wider(
    names_from  = hour,
    values_from = num_trips,
    values_fill = 0
  )

# View result
print(pivot_trips)
```

## More parsing to create more charts
```
uber_df <- combined_uber_data %>%
  mutate(
    date     = as_date(datetime),
    day      = day(datetime),
    month    = month(datetime, label = TRUE, abbr = FALSE),
    weekday  = wday(datetime, label = TRUE, abbr = FALSE),
    week     = week(datetime)
  )
```
## Summarizing
```
hour_month_df      <- uber_df %>% count(month, hour, name = "trips")
hourly_df          <- uber_df %>% count(hour, name = "trips")
daily_df           <- uber_df %>% count(day, name = "trips")
day_month_df       <- uber_df %>% count(month, weekday, name = "trips")
monthly_df         <- uber_df %>% count(month, name = "trips")
base_month_df      <- uber_df %>% count(Base, month, name = "trips")
heat_hour_day_df   <- uber_df %>% count(hour, weekday, name = "trips")
heat_month_day_df  <- uber_df %>% count(day, month, name = "trips")
heat_month_week_df <- uber_df %>% count(week, month, name = "trips")
heat_base_wk_df    <- uber_df %>% count(Base, weekday, name = "trips")
heat_month_wday_df <- uber_df %>% count(month, weekday, name = "trips")
```
## Building prediction model
```
model_df <- uber_df %>%
  count(hour, weekday, month, name = "trips") %>%
  mutate(
    hour    = as.integer(hour),
    weekday = factor(weekday, levels = c("Sunday","Monday","Tuesday","Wednesday","Thursday","Friday","Saturday")),
    month   = factor(month,  levels = month.name)
  )

set.seed(2025)
split    <- initial_split(model_df, prop = 0.8, strata = trips)
train_df <- training(split)

rf_spec <- rand_forest(mtry = 2, trees = 500, min_n = 5) %>%
  set_engine("ranger") %>%
  set_mode("regression")

rf_wf <- workflow() %>%
  add_model(rf_spec) %>%
  add_formula(trips ~ hour + weekday + month)

rf_fit <- rf_wf %>% fit(data = train_df)
```
## Shiny App
```
ui <- fluidPage(
  titlePanel("Uber Trips Dashboard"),
  tabsetPanel(
    tabPanel("Hour & Month",    plotOutput("hour_month_plot")),
    tabPanel("Every Hour",       plotOutput("hourly_plot")),
    tabPanel("Daily Totals Table",       DTOutput("daily_table")),
    tabPanel("Daily Totals Plot",       plotOutput("daily_plot")),
    tabPanel("Day×Month",             plotOutput("day_month_plot")),
    tabPanel("By Month",              plotOutput("monthly_plot")),
    tabPanel("Base×Month",            plotOutput("base_month_plot")),
    tabPanel("Heatmaps",
             fluidRow(
               column(6, plotOutput("heat_hour_day")),
               column(6, plotOutput("heat_month_day"))
             ),
             fluidRow(
               column(6, plotOutput("heat_month_week")),
               column(6, plotOutput("heat_base_wk"))
             )
    ),
    tabPanel("Map", leafletOutput("map", height = "600px")),
    tabPanel("Predict Trips",        # ← new tab
             sidebarLayout(
               sidebarPanel(
                 sliderInput("in_hour", "Hour of Day:", min = 0, max = 23, value = 12),
                 selectInput("in_weekday", "Day of Week:",
                             choices = c("Sunday","Monday","Tuesday","Wednesday",
                                         "Thursday","Friday","Saturday"),
                             selected = "Monday"),
                 selectInput("in_month", "Month:",
                             choices = month.name,
                             selected = "January"),
                 actionButton("goPredict", "Predict")
               ),
               mainPanel(
                 h3("Predicted Number of Trips:"),
                 verbatimTextOutput("predicted_trips")
               )
             )
    )
  )
)

server <- function(input, output, session) {
  # … existing renderDT / renderPlot / renderLeaflet blocks unchanged …
  
  output$hour_month_plot <- renderPlot({
    ggplot(hour_month_df, aes(hour, trips, color=month, group=month))+
      geom_line()+labs(x="Hour",y="Trips")+theme_minimal()
  })
  output$hourly_plot <- renderPlot({
    ggplot(hourly_df, aes(x = hour, y = trips, fill = trips)) +
      geom_col() +
      scale_fill_viridis_c(option = "plasma", direction = -1) +
      labs(x = "Hour", y = "Trips", fill = "Trips") +
      theme_minimal()
  })
  output$daily_table <- renderDT({
    datatable(daily_df, colnames=c("Day","Total Trips"),
              options=list(pageLength=31, dom='t'))
  })
  output$daily_plot <- renderPlot({
    ggplot(daily_df, aes(x = day, y = trips, fill = trips)) +
      geom_col() +
      scale_x_continuous(breaks = 1:31) +
      scale_fill_viridis_c(option = "plasma", direction = -1) +
      labs(
        title = "Trips by Day of Month",
        x     = "Day of Month",
        y     = "Total Trips",
        fill  = "Trips"
      ) +
      theme_minimal()
  })
  output$day_month_plot <- renderPlot({
    ggplot(day_month_df, aes(month, trips, fill=weekday))+
      geom_col(position="dodge")+labs(x="Month",y="Trips")+theme_minimal()
  })
  output$monthly_plot <- renderPlot({
    ggplot(monthly_df, aes(x = month, y = trips, fill = trips)) +
      geom_col() +
      scale_fill_viridis_c(option = "plasma", direction = -1) +
      labs(
        x     = "Month",
        y     = "Trips",
        fill  = "Trips"
      ) +
      theme_minimal()
  })
  output$base_month_plot <- renderPlot({
    ggplot(base_month_df, aes(Base, trips, fill=month))+
      geom_col(position="dodge")+labs(x="Base",y="Trips")+
      theme_minimal()+ theme(axis.text.x=element_text(angle=45,hjust=1))
  })
  output$heat_hour_day <- renderPlot({
    ggplot(heat_hour_day_df, aes(hour, weekday, fill=trips))+
      geom_tile()+theme_minimal()+labs(x="Hour",y="Weekday")
  })
  output$heat_month_day <- renderPlot({
    ggplot(heat_month_day_df, aes(day, month, fill=trips))+
      geom_tile()+theme_minimal()+labs(x="Day",y="Month")
  })
  output$heat_month_week <- renderPlot({
    ggplot(heat_month_week_df, aes(week, month, fill=trips))+
      geom_tile()+theme_minimal()+labs(x="Week of Year",y="Month")
  })
  output$heat_base_wk <- renderPlot({
    ggplot(heat_base_wk_df, aes(weekday, Base, fill=trips))+
      geom_tile()+theme_minimal()+labs(x="Weekday",y="Base")+
      theme(axis.text.x=element_text(angle=45,hjust=1))
  })
  output$map <- renderLeaflet({
    samp <- uber_df %>% sample_n(min(20000, n()))
    leaflet(samp) %>% addTiles() %>%
      addCircleMarkers(lng=~Lon, lat=~Lat, radius=3,
                       stroke=FALSE, fillOpacity=0.4,
                       clusterOptions=markerClusterOptions())
  })
  ```
## Prediction Server Logic
```
  observeEvent(input$goPredict, {
    newdata <- tibble(
      hour    = as.integer(input$in_hour),
      weekday = ordered(
        input$in_weekday,
        levels = c("Sunday","Monday","Tuesday","Wednesday",
                   "Thursday","Friday","Saturday")
      ),
      month   = ordered(
        input$in_month,
        levels = month.name
      )
    )
    pred <- predict(rf_fit, newdata)$.pred
    output$predicted_trips <- renderText(round(pred, 0))
  })
}
```
## Running the Shiny App
```
shinyApp(ui, server)
``
