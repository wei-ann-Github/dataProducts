library(ggplot2)
library(shiny)
library(ISLR)

data("Wage")
names(Wage)
x <- c(3,4,5,6)

lmfit <- lm(wage ~ age + maritl + race + education, data = Wage)

pred_lm <- function(age=NULL, race=NULL, edu=NULL, maritl=NULL) {
    edu_func <- edu
    race_func <- NULL
    if(edu == "1. < High School")
        edu_func = "1. < HS Grad"
    if(edu == "2. High School") 
        edu_func = "2. HS Grad"
    if(edu == "3. College")
        edu_func = "4. College Grad"
    if(edu == "4. Advanced Degree")
        edu_func = "5. Advanced Degree"
    
    if(race == "1. Caucasian")
        race_func = "1. White"
    if(race == "2. East Asian")
        race_func = "3. Asian"
    if(race == "3. African Descent")
        race_func = "2. Black"
    if(race == "4. Others")
        race_func = "4. Other"
    
    pred <- predict(lmfit, newdata = data.frame(age = age, race = race_func, education = edu_func, maritl = maritl), interval = "prediction")
    wage <- list()
    wage[[1]] <- paste("Your predicted annual wage is from $", round(ifelse(as.numeric(pred[2]) < 0, 0, pred[2]), 2),  "K to $", round(as.numeric(pred[3]), 2), "K with a mean of $", round(as.numeric(pred[1]), 2), "K")
    wage[[2]] <- round(as.numeric(pred[1]), 2)
    return(wage)
}

scatterPlot <- function(age=NULL, race=NULL, edu=NULL, maritl=NULL) {
    edu_func <- edu
    race_func <- NULL
    if(edu == "1. < High School")
        edu_func = "1. < HS Grad"
    if(edu == "2. High School") 
        edu_func = "2. HS Grad"
    if(edu == "3. College")
        edu_func = "4. College Grad"
    if(edu == "4. Advanced Degree")
        edu_func = "5. Advanced Degree"
    
    if(race == "1. Caucasian")
        race_func = "1. White"
    if(race == "2. East Asian")
        race_func = "3. Asian"
    if(race == "3. African Descent")
        race_func = "2. Black"
    if(race == "4. Others")
        race_func = "4. Other"
    
    ggplot(data = Wage, aes(x = age, y = wage, color = race, shape = maritl)) + 
        geom_point() + 
        scale_shape(solid = FALSE) +
        ggtitle("Plot of Wage vs Age")
}

shinyServer(
    function(input, output){
        output$Wage <- renderPrint({pred_lm(input$age, input$race, input$edu, input$maritl)[[1]]})
        output$age_out <- renderPrint({input$age})
        output$edu_out <- renderPrint({input$edu})
        output$maritl_out <- renderPrint({input$maritl})       
        output$race_out <- renderPrint({input$race})
        output$scatter <- renderPlot({ggplot(data = Wage, aes(x = age, y = wage, color = race, shape = maritl)) + 
                                          geom_point(size = 2) + 
                                          scale_shape(solid = FALSE) +
                                          ggtitle("What is your predicted wage?") + 
                                          geom_point(x = input$age, y = pred_lm(input$age, input$race, input$edu, input$maritl)[[2]], size = 5, color = "black", shape = 16) + 
                                          coord_cartesian(xlim = c(15, 85))})
    }
)