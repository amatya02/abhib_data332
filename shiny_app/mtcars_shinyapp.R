# step 1: setting up a basic shiny app with a histogram

# Load required libraries
library(shiny)
# Define UI
ui <- fluidPage(
  titlePanel("Basic Histogram in Shiny"),
  sidebarLayout(
    sidebarPanel(),
    mainPanel(
      plotOutput("histPlot") # Placeholder for histogram
    )
  )
)
# Define server logic
server <- function(input, output) {
  output$histPlot <- renderPlot({
    hist(mtcars$mpg, col = "blue", main = "Histogram of MPG", xlab =
           "MPG")
  })
}
# Run the app
shinyApp(ui = ui, server = server)

# step 2: switching to ggplot2 for better visualization
# Load required libraries
library(ggplot2)
# Define UI
ui <- fluidPage(
  titlePanel("Histogram with ggplot2"),
  sidebarLayout(
    sidebarPanel(),
    mainPanel(
      plotOutput("histPlot") # ggplot histogram
    )
  )
)
# Define server logic
server <- function(input, output) {
  output$histPlot <- renderPlot({
    ggplot(mtcars, aes(x = mpg)) +
      geom_histogram(fill = "blue", color = "black", bins = 10) +
      labs(title = "Histogram of MPG", x = "MPG", y = "Count")
  })
}
# Run the app
shinyApp(ui = ui, server = server)

# step 3: adding user interaction with a dropdown menu
# Define UI
ui <- fluidPage(
  titlePanel("Interactive Histogram with ggplot2"),
  sidebarLayout(
    sidebarPanel(
      selectInput("var", "Choose a Variable:",
                  choices = c("MPG" = "mpg", "Horsepower" = "hp",
                              "Weight" = "wt"),
                  selected = "mpg") # Default selection
    ),
    mainPanel(
      plotOutput("histPlot") # Interactive plot
    )
  )
)
# Define server logic
server <- function(input, output) {
  output$histPlot <- renderPlot({
    ggplot(mtcars, aes_string(x = input$var)) + # Uses user-selected variable
      
    geom_histogram(fill = "blue", color = "black", bins = 10) +
      labs(title = paste("Histogram of", input$var), x = input$var, y =
             "Count")
  })
}
# Run the app
shinyApp(ui = ui, server = server)

