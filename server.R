library(shiny)
library(datasets)

# Define server logic required to summarize and view the selected
# dataset

binom <-  function(n){ 
        # The Binomial Distribution
        mu <<- .5; sigma <<- .5
        rbinom(n, size = 1, prob = .5) 
}
exp <- function(n) { 
        # The Exponential Distribution
        mu <<- 1; sigma <<- 1
        rexp(n, rate = 1) 
}
f <- function(n) { 
        # The F Distribution
        d1 <- 4; d2 <- 6
        mu <<- d2 / (d2 - 2)
        sigma <<- sqrt(2) * d2 * sqrt(d1 + d2 - 2) / sqrt(d1) / (d2 - 2) / sqrt(d2 - 4)
        rf(n, df1 = d1, df2 = d2) 
}
logis <- function(n) { 
        # The Logistic Distribution
        m <- 0; s <- 1
        mu <<- m; sigma <<- s ^ 2 * pi ^ 2 / 3
        rlogis(n, location = m, scale = s) 
}
pois <- function(n) { 
        # The Poisson Distribution
        lambda = 5
        mu <<- lambda; sigma <<- sqrt(lambda)
        rpois(n, lambda) 
}
t <- function(n) { 
        # The Student t Distribution
        v <- 4  
        mu <<- 0; sigma <<- sqrt(v / (v - 2))  # v > 2
        rt(n, df = v) 
}
unif <- function(n) { 
        # The Uniform Distribution
        a <- 0; b <- 1
        mu <<- (a + b) / 2; sigma <<- (b - a) / sqrt(12)
        runif(n, min = a, max = b) 
}




shinyServer(function(input, output) {
        # Return the requested dataset
        distInput <- reactive({
                switch(input$distribution, "Binomial" = binom, "Exponential" = exp,
                       "F" = f, "Logistic" = logis, "Poisson" = pois, "Student t" = t, "Uniform" = unif)
        })
        
        # Generate a summary of the dataset
        output$distFunc <- renderPrint({
                rdist <- distInput()
                rdist
        })
        
        # Show the first "n" observations
        output$view <- renderTable({
                head(distInput(), n = input$obs)
        })
        
        # plot
        output$distPlot <- renderPlot({
                num <<- input$num
                rdist <- distInput()
                
                samples <- NULL
                for (i in 1:1000) samples <- c(samples, mean(rdist(num)))
                library(ggplot2)
                normalize_mean <- function(x, mu, sigma, n){sqrt(n) * (x - mu) / sigma}
                dat <- data.frame(
                        x = sapply(samples, normalize_mean, mu, sigma, n = num),
                        num = factor(rep(num, 1000)))
                
                g <- ggplot(dat, aes(x = x, fill = num)) + geom_histogram(binwidth=.3, colour = "black",
                                                                           aes(y = ..density..)) 
                g <- g + stat_function(fun = dnorm, size = 2)
                g + facet_grid(. ~ num)
        })
})