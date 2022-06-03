#
# This is a Shiny web application. You can run the application by clicking
# the 'Run App' button above.
#
# Find out more about building applications with Shiny here:
#
#    http://shiny.rstudio.com/
#

library(shiny)
library(caret)
library(brnn)

# Model building
## Input 2021 data from SWD field trap collection in Indiana
swd <- read.csv("SWD 2021 for ML.csv")
# Select columns we need
swd <- swd[,4:8]
## 10-fold CV with 10 repeats
fitControl <- trainControl(
    method = "repeatedcv",
    number = 10,
    repeats = 10)

# Bayesian Regularized Neural Networks
model <- train(Total.adults~Latitude_N+Longitude_W+CDD+Precipitation_in, data = swd, 
               method = "brnn", 
               trControl = fitControl
               )


# Define UI for application that draws a histogram
ui <- fluidPage(

    # Application title
    titlePanel("Spotted-wing Drosophila (SWD) number predictor"),
    # A brief description
    mainPanel(
        h2("About this model"),
        p("This model is to provide an estimate number of Spotted-wing Drosophila (", 
          em("Drosophila suzukii"),
          ") at a certain timing, measured as ",
          HTML("<a href='http://ipm.ucanr.edu/WEATHER/ddconcepts.html#note'>Degree Day</a>"),
          ". It is trained based on Scentry trap adult catch on blueberry in Indiana. 
          Please regard the result only as a reference if you are using it on other crops in other States in  
          the continental United States and consult your local extension coordinator for more information."),
    ),
    
    # Input
    mainPanel(h2("Input your parameters"),
              # Input latitude
              numericInput("lat", "Latitude (N)", value = 40.2672, min = 0, max = 90),
              # Input longitude
              numericInput("long", "Longitude (W)", value = 86.1349, min = 0, max = 180),
              # Input Degree day
              numericInput("CDD", "Cumulative Degree day", value = 0, min = 0, max = 10000),
              p("Degree-day Calculation starts on January 1st each year, using a lower threshold of 7.2°C and upper threshold of 31.5°C."),
              # Input latitude
              numericInput("prep", "Precipitation (inch)", value = 0, min = 0, max = 500)),
    
    # Output
    mainPanel(h2("Output"),
              # Output the predicted number
              textOutput("number")),
    
    )


# Define server logic required to draw a histogram
server <- function(input, output,session) {

    Lat <- reactive(input$lat)
    Long <- reactive(input$long)
    cdd <- reactive(input$CDD)
    Prep <- reactive(input$prep)
    
    Num <- reactive(predict(model,
                   data.frame(Latitude_N=Lat(), Longitude_W=Long(),
                              CDD=cdd(), Precipitation_in=Prep())))
    
    output$number <- renderText({paste0("The estimated number of adults today is ", round(Num(),digit=0), ".")
    })
    
}

# Run the application 
shinyApp(ui = ui, server = server)
