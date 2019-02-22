#
# This is the user-interface definition of a Shiny web application. You can
# run the application by clicking "Run App" above.
#
# Find out more about building applications with Shiny here:
# 
#    http://shiny.rstudio.com/
#

library(shiny)
library(ggplot2)
library(dplyr)
#library(scales)
#library(pastecs)


loan_data <- read.csv("Loan_Clean.csv")

# set order for appearance of the states with a vector called "statesorder" 
  statesorder <- c("DC", "DE", "MD", "VA", "WV")

library(data.table)
outlierReplace = function(dataframe, cols, rows, newValue = NA) {
  if (any(rows)) {
    set(dataframe, rows, cols, newValue)
  }
}

# Define server logic for random distribution application
shinyServer(function(input, output) {
  
  # The outlier replace below removes the extreme outliers that do not represent much in the analysis.
  
  outlierReplace(loan_data, "Loan_Amount_000", which(loan_data$Loan_Amount_000 > 1000), NA)
  
  # Generate a plot of the data. Also uses the inputs to build the 
  # plot label. Note that the dependencies on both the inputs and
  # the 'data' reactive expression are both tracked, and all expressions 
  # are called in the sequence implied by the dependency graph
  output$plot_loan <- renderPlot({
    
    loans_plot <- loan_data
    
    if (input$year != "All"){
      loans_plot <- filter(loans_plot, As_of_Year %in% input$year)
    }
    
    if(input$loanPurpose != "All"){
      loans_plot <- filter(loans_plot,Loan_Purpose_Description %in% input$loanPurpose)
    }
    

    ggplot(loans_plot, aes(Loan_Amount_000)) +
      geom_histogram(fill = "Black",color = "White") 
  } + xlim(c(0, 1500)))
  
  
  # Generate a plot of the data. Also uses the inputs to build the 
  # plot label. Note that the dependencies on both the inputs and
  # the 'data' reactive expression are both tracked, and all expressions 
  # are called in the sequence implied by the dependency graph
  output$income <- renderPlot({
    
    loans_plot <- loan_data
    
    
    if (input$year != "All"){
      loans_plot <- filter(loans_plot, As_of_Year %in% input$year)
    }

    
    ggplot(loans_plot, aes(x = As_of_Year, y = Applicant_Income_000, fill = State)) + 
      geom_bar(stat = 'identity')
    
  })
  

  # Generate a plot of the data. Also uses the inputs to build the 
  # plot label. Note that the dependencies on both the inputs and
  # the 'data' reactive expression are both tracked, and all expressions 
  # are called in the sequence implied by the dependency graph
  output$loan_income <- renderPlot({
    
    loans_plot <- loan_data
    

    if (input$states != "All"){
      loans_plot <- filter(loans_plot, State %in% input$states)
    }
  
  
    ggplot(data=loans_plot, aes(x=Applicant_Income_000, y=Loan_Amount_000, fill=State))+
      geom_point(size=5, na.rm=TRUE, aes(color=State, shape=State))   
    
 
     })
  
  # Generate a plot of the data. Also uses the inputs to build the 
  # plot label. Note that the dependencies on both the inputs and
  # the 'data' reactive expression are both tracked, and all expressions 
  # are called in the sequence implied by the dependency graph
  output$applications <- renderPlot({
    
    loans_plot <- loan_data
    
    
    if (input$loanPurpose != "All"){
      loans_plot <- filter(loans_plot, Loan_Purpose_Description %in% input$loanPurpose)
    }
    
    
    ggplot(data = loans_plot, aes(x = Agency_Code_Description, fill = Loan_Purpose_Description)) + geom_bar(stat = "count", position = "dodge", alpha = 0.7) + 
      scale_fill_brewer(name = "Legend", palette = "PuBuGn", direction = 1) + scale_y_continuous("Count of Applications") + scale_x_discrete("Agency") + theme_dark()
    
  })
  
  
})