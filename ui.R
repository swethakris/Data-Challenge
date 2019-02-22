#
# This is the user-interface definition of a Shiny web application. You can
# run the application by clicking "Run App" above.
#
# Find out more about building applications with Shiny here:
# 
#    http://shiny.rstudio.com/
#

library(shiny)


# Define UI for random distribution application 
shinyUI(pageWithSidebar(
  
  # Application title
  headerPanel("Loan_Income Distribution"),
  
  # Sidebar with controls to select the random distribution type
  # and number of observations to generate. Note the use of the br()
  # element to introduce extra vertical spacing
  sidebarPanel(
    selectInput("loanPurpose", "Loan Purpose",
                choices = c("All","Purchase", "Refinance")),
    selectInput("year", "Year",
                label=HTML('<p style="color:Black; font-size: 12pt"> Year </p>'),
                choices = c("All",2012:2014)),
    selectInput("states", "States",
              label=HTML('<p style="color:Black; font-size: 12pt"><b> States</b></p>'),
              choices = c("All","DC", "DE", "MD", "VA", "WV"))
  
  ),
  
  # Show a tabset that includes a Loan_Amount, Summary, and table view
  # of the generated distribution
  mainPanel(
    tabsetPanel(
      tabPanel("Loan_Applications", plotOutput("applications")),
      tabPanel("Loan_Amount", plotOutput("plot_loan")), 
      tabPanel("Applicant_Income", plotOutput("income")), 
      tabPanel("Loan_Income", plotOutput("loan_income"))
    )
  )
))