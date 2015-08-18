library(shiny)

shinyUI(pageWithSidebar(
    headerPanel("Naive Wage Prediction"), 
    sidebarPanel(h5("This application attempts to predict your wage."),
                 sliderInput("age", "How old are you?", value = 30, min = 15, max = 85, step = 1),
                 radioButtons("edu", "What is your education level?", c("1. < High School", "2. High School", "3. College", "4. Advanced Degree")),
                 radioButtons("maritl", "What is your Marital Status?", c("1. Never Married", "2. Married", "3. Widowed", "4. Divorced", "5. Separated")),
                 radioButtons("race", "What is your Ethnicity?", c("1. Caucasian", "2. East Asian", "3. African Descent", "4. Others"))
                 ), 
    mainPanel(verbatimTextOutput("Wage"),
              plotOutput("scatter")
              )
))