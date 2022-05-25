#
# This is the server logic of a Shiny web application. 
#

library(shiny)
library(caret)


shinyServer(function(input, output) {
  # Model building
  ## Input 2021 data from SWD field trap collection in Indiana
  swd <- read.csv("SWD 2021 for ML.csv")
  ## Shuffle rows
  rowShuffle <- sample (x=1:nrow(swd),size=nrow(swd),replace=FALSE)
  swd <- swd[rowShuffle,4:8]
  ## 10-fold CV with 10 repeats
  fitControl <- trainControl(
    method = "repeatedcv",
    number = 10,
    repeats = 10)
  
  # Boosted Generalized Additive Model
  gamB <- train(Total.adults~Latitude_N+Longitude_W+CDD+Precipitation_in, data = swd, 
               method = "gamboost", 
               trControl = fitControl)
  
  Num <- predict(gamB,
                 data.frame(Latitude_N=input$lat, Longitude_W=input$long,
                            CDD=input$CDD, Precipitation_in=input$prep))

    output$number <- renderText({
        paste0("The estimated number of adults today is ", Num, ".")
    })

})
