library(shiny)

# Define UI for Central Limited Theorem application
shinyUI(fluidPage(
        
        # Application title
        titlePanel("Central Limited Theorem"),
        
        # Sidebar with controls to select a dataset and specify the
        # number of observations to view
        sidebarLayout(
                sidebarPanel(
                        selectInput("distribution", "Choose a distribution:", 
                                    choices = c("Binomial", "Exponential", "F",
                                                "Logistic", "Poisson", "Student t", "Uniform")),
                        
                        sliderInput("num", "Number of points need to mean:",
                                    min = 1, max = 40, step = 39, value = 1)
                ),
                
                # Show a summary of the dataset and an HTML table with the 
                # requested number of observations
                mainPanel(
                        verbatimTextOutput("distFunc"),
                        
                        plotOutput("distPlot")
                )
        )
))