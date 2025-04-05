install.packages("shiny")
library(shiny)
library(ggplot2)
ui <- fluidPage(
  "Hello, world!"
)
server <- function(input, output, session) {
}
shinyApp(ui, server)

ui <- fluidPage(
  selectInput("dataset", label = "Dataset", choices = ls("package:datasets")),
  verbatimTextOutput("summary"),
  tableOutput("table")
)

server <- function(input, output, session) {
  output$summary <- renderPrint({
    dataset <- get(input$dataset, "package:datasets")
    summary(dataset)
  })
  
  output$table <- renderTable({
    dataset <- get(input$dataset, "package:datasets")
    dataset
  })
}


dataset <- get(input$dataset, "package:datasets")

server <- function(input, output, session) {
  # Create a reactive expression
  dataset <- reactive({
    get(input$dataset, "package:datasets")
  })
  
  output$summary <- renderPrint({
    # Use a reactive expression by calling it like a function
    summary(dataset())
  })
  
  output$table <- renderTable({
    dataset()
  })
}


shinyApp(ui, server)



# exercise
#1

# Define UI
ui <- fluidPage(
  textInput("name", "What is your name ?"),  
  textOutput("greeting")                  
)

# Define server logic
server <- function(input, output, session) {
  output$greeting <- renderText({
    paste0("Hello ", input$name)  # Generate greeting message
  })
}

# Run the app
shinyApp(ui = ui, server = server)


#2

ui <- fluidPage(
  sliderInput("x", label = "If x is", min = 1, max = 50, value = 30),  # User selects x
  "then x times 5 is",
  textOutput("product")  # Displays the result
)

server <- function(input, output, session) {
  output$product <- renderText({ 
    input$x * 5  # Use input$x to access the slider value
  })
}

shinyApp(ui, server)


#3
ui <- fluidPage(
  sliderInput("x", label = "If x is ", min = 1, max = 50, value = 30),  # User selects x
  sliderInput("y", label = "If y is ", min = 1, max = 50, value = 5),   # User selects y
  "then, x times y is",
  textOutput("product")  # Displays x * y
)

server <- function(input, output, session) {
  output$product <- renderText({ 
    input$x * input$y  # Multiply x by y
  })
}

shinyApp(ui, server)

#4
ui <- fluidPage(
  sliderInput("x", "If x is", min = 1, max = 50, value = 30),
  sliderInput("y", "and y is", min = 1, max = 50, value = 5),
  "then, (x * y) is", textOutput("product"),
  "and, (x * y) + 5 is", textOutput("product_plus5"),
  "and (x * y) + 10 is", textOutput("product_plus10")
)

server <- function(input, output, session) {
  # Define a reactive expression to compute product
  product <- reactive({ input$x * input$y })
  
  output$product <- renderText({ product() })  # Use reactive value
  output$product_plus5 <- renderText({ product() + 5 })  # Use computed product
  output$product_plus10 <- renderText({ product() + 10 })  # Use computed product
}

shinyApp(ui, server)

#5
datasets <- c("economics", "faithfuld", "seals")

ui <- fluidPage(
  selectInput("dataset", "Dataset", choices = datasets),
  verbatimTextOutput("summary"),
  plotOutput("plot")  # Changed tableOutput to plotOutput
)

server <- function(input, output, session) {
  dataset <- reactive({
    get(input$dataset, envir = asNamespace("ggplot2"))  # Ensure dataset is fetched properly
  })
  
  output$summary <- renderPrint({
    summary(dataset())
  })
  
  output$plot <- renderPlot({
    plot(dataset())  # Use dataset() correctly
  }, res = 96)
}

shinyApp(ui, server)

