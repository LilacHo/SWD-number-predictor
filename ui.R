#
# This is the user-interface definition of a Shiny web application. 
#

library(shiny)

# Define UI for application that draws a histogram
shinyUI(fluidPage(

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
    mainPanel(h2("Input your parameters")),
    # Input latitude
    numericInput("lat", "Latitude (N)", value = 40.2672, min = 0, max = 90),
    # Input longitude
    numericInput("long", "Longitude (W)", value = 86.1349, min = 0, max = 180),
    # Input Degree day
    numericInput("CDD", "Cumulative Degree day", value = 0, min = 0, max = 10000),
    p("Degree-day Calculation starts on January 1st each year, using a lower threshold of 7.2°C and upper threshold of 31.5°C."),
    # Input latitude
    numericInput("prep", "Precipitation (inch)", value = 0, min = 0, max = 500),
    
    # Output
    #mainPanel(h2("Output")),
    
    # Output the predicted number
    textOutput("number")


    )
)
