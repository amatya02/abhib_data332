# building the shinny app
library(readxl)
library(dplyr)
library(writexl)
library(dplyr)
library(shiny)
library(DT)
library(ggplot2)
library(httr)
library(scales)
# load the master data from GitHub
data_url <- "https://raw.githubusercontent.com/amatya02/abhib_data332/main/combined_cars/master_data.xlsx"
tmp <- tempfile(fileext = ".xlsx")
GET(data_url, write_disk(tmp, overwrite = TRUE))
df <- read_excel(tmp)

# define speed limit
speed_limit <- 30

# UI
ui <- fluidPage(
  titlePanel("Counting Cars Project"),
  
  sidebarLayout(
    sidebarPanel(
      selectInput("variable", "Select Variable:",
                  choices = c("Initial_Speed", "Final_Speed", "Difference")),
      tags$p(strong("Speed limit is 30 mph"))
    ),
    
    mainPanel(
      tabsetPanel(
        tabPanel("Histogram & Summary",
                 plotOutput("histPlot"),
                 tableOutput("summaryTable")
        ),
        
        tabPanel("Comparison",
                 h4("Summary Statistics by Vehicle Type"),
                 tableOutput("comparisonTable")
        ),
        
        tabPanel("Exceedance",
                 h4("Counts of Vehicles Exceeding 30 mph by Type"),
                 plotOutput("barInitial"),
                 plotOutput("barFinal"),
                 h4("Proportion Exceeding vs. Not by Type"),
                 plotOutput("propInitial"),
                 plotOutput("propFinal"),
                 h4("Speed Distributions with 30 mph Limit"),
                 plotOutput("distInitial"),
                 plotOutput("distFinal")
        ),
        
        tabPanel("Slowdown",
                 h4("Vehicles Slowing Down After Radar by Type"),
                 tableOutput("slowdownTable"),
                 plotOutput("slowdownBar")
        )
      )
    )
  )
)

# Server
server <- function(input, output, session) {
  
  # reactive shorthand
  var <- reactive(input$variable)
  
  # histogram andsummary
  output$histPlot <- renderPlot({
    df2 <- df
    m   <- mean(df2[[var()]], na.rm = TRUE)
    med <- median(df2[[var()]], na.rm = TRUE)
    
    ggplot(df2, aes_string(x = var())) +
      geom_histogram(bins = 30, fill = "lightblue", color = "black") +
      geom_vline(xintercept = m,   linetype = "dashed", color = "red") +
      geom_vline(xintercept = med, linetype = "dotted", color = "darkgreen") +
      labs(title = paste(var(), "Distribution"), x = var(), y = "Count") +
      theme_minimal()
  })
  
  output$summaryTable <- renderTable({
    v <- df[[var()]]
    data.frame(
      Statistic = c("Mean", "Median", "Min", "Max"),
      Value     = c(mean(v, na.rm = TRUE),
                    median(v, na.rm = TRUE),
                    min(v, na.rm = TRUE),
                    max(v, na.rm = TRUE))
    )
  })
  
  # comparison by Body_Style
  output$comparisonTable <- renderTable({
    df %>%
      group_by(Body_Style) %>%
      summarise(
        Mean   = mean(.data[[var()]], na.rm = TRUE),
        Median = median(.data[[var()]], na.rm = TRUE)
      ) %>%
      ungroup()
  })
  
  # precompute exceedance flags
  exceed_df <- df %>%
    mutate(
      ExceedInitial = Initial_Speed >  speed_limit,
      ExceedFinal   = Final_Speed   >  speed_limit
    )
  
  # exceedance plots
  output$barInitial <- renderPlot({
    exceed_df %>%
      filter(ExceedInitial) %>%
      count(Body_Style) %>%
      ggplot(aes(Body_Style, n, fill = Body_Style)) +
      geom_col() +
      labs(title = "Initial Speed Exceedances", x = "Type", y = "Count") +
      theme_minimal()
  })
  
  output$barFinal <- renderPlot({
    exceed_df %>%
      filter(ExceedFinal) %>%
      count(Body_Style) %>%
      ggplot(aes(Body_Style, n, fill = Body_Style)) +
      geom_col() +
      labs(title = "Final Speed Exceedances", x = "Type", y = "Count") +
      theme_minimal()
  })
  
  output$propInitial <- renderPlot({
    exceed_df %>%
      count(Body_Style, ExceedInitial) %>%
      group_by(Body_Style) %>%
      mutate(prop = n / sum(n)) %>%
      ggplot(aes(Body_Style, prop, fill = ExceedInitial)) +
      geom_col(position = "dodge") +
      scale_fill_manual(
        values = c("TRUE" = "#d9534f", "FALSE" = "#5bc0de"),
        labels = c("Exceed", "Not Exceed")
      ) +
      labs(title = "Initial: Proportion Exceeding", x = "Type", y = "Proportion") +
      theme_minimal()
  })
  
  output$propFinal <- renderPlot({
    exceed_df %>%
      count(Body_Style, ExceedFinal) %>%
      group_by(Body_Style) %>%
      mutate(prop = n / sum(n)) %>%
      ggplot(aes(Body_Style, prop, fill = ExceedFinal)) +
      geom_col(position = "dodge") +
      scale_fill_manual(
        values = c("TRUE" = "#d9534f", "FALSE" = "#5bc0de"),
        labels = c("Exceed", "Not Exceed")
      ) +
      labs(title = "Final: Proportion Exceeding", x = "Type", y = "Proportion") +
      theme_minimal()
  })
  
  output$distInitial <- renderPlot({
    ggplot(exceed_df, aes(Initial_Speed, color = Body_Style, fill = Body_Style)) +
      geom_density(alpha = 0.3) +
      geom_vline(xintercept = speed_limit, linetype = "dashed", color = "red") +
      labs(title = "Initial Speed Distribution", x = "Speed (mph)", y = "Density") +
      theme_minimal()
  })
  
  output$distFinal <- renderPlot({
    ggplot(exceed_df, aes(Final_Speed, color = Body_Style, fill = Body_Style)) +
      geom_density(alpha = 0.3) +
      geom_vline(xintercept = speed_limit, linetype = "dashed", color = "red") +
      labs(title = "Final Speed Distribution", x = "Speed (mph)", y = "Density") +
      theme_minimal()
  })
  
  # slowdown analysis
  slowdown_df <- df %>%
    mutate(SlowDown = Final_Speed < Initial_Speed) %>%
    group_by(Body_Style) %>%
    summarise(
      Count_Slowdown  = sum(SlowDown, na.rm = TRUE),
      Total_Vehicles  = n(),
      Proportion_Slow = Count_Slowdown / Total_Vehicles
    ) %>%
    ungroup()
  
  output$slowdownTable <- renderTable(slowdown_df)
  
  output$slowdownBar <- renderPlot({
    ggplot(slowdown_df, aes(Body_Style, Proportion_Slow, fill = Body_Style)) +
      geom_col() +
      scale_y_continuous(labels = percent_format()) +
      labs(title = "Proportion of Vehicles Slowing Down", x = "Type", y = "Proportion") +
      theme_minimal()
  })
}

# run the app
shinyApp(ui, server)