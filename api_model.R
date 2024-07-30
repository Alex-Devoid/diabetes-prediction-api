# Load required packages
library(plumber)
library(caret)
library(tidyverse)


load("docs/logistic_model.RData")

# Define the `pred` endpoint
# This function takes in parameters and returns the prediction from the model
# Use default values for predictors if not provided
#* @apiTitle Diabetes Prediction API

#* Predict Diabetes Status
#* @param HighBP:int=1
#* @param HighChol:int=1
#* @param CholCheck:int=1
#* @param BMI:double=25
#* @param Smoker:int=0
#* @param PhysActivity:int=1
#* @param Fruits:int=1
#* @param Veggies:int=1
#* @param GeneralHealth:int=3
#* @param Age:int=6
#* @param Sex:int=1
#* @get /pred
function(HighBP = 1, HighChol = 1, CholCheck = 1, BMI = 25,
         Smoker = 0, PhysActivity = 1, Fruits = 1, Veggies = 1,
         GeneralHealth = 3, Age = 6, Sex = 1) {
  
  # Create a data frame with the input parameters
  new_data <- data.frame(
    HighBP = factor(HighBP, levels = c(0, 1)),
    HighChol = factor(HighChol, levels = c(0, 1)),
    CholCheck = factor(CholCheck, levels = c(0, 1)),
    BMI = as.numeric(BMI),
    Smoker = factor(Smoker, levels = c(0, 1)),
    PhysActivity = factor(PhysActivity, levels = c(0, 1)),
    Fruits = factor(Fruits, levels = c(0, 1)),
    Veggies = factor(Veggies, levels = c(0, 1)),
    GeneralHealth = factor(GeneralHealth, levels = c(1:5)),
    Age = factor(Age, levels = 1:13),
    Sex = factor(Sex, levels = c(0, 1))
  )
  
  # Predict the probability of having diabetes
  prediction <- predict(best_model, new_data, type = "prob")
  return(prediction)
}

# Define the `info` endpoint
#* API Information
#* @get /info
function() {
  list(
    name = "Alex Devoid",
    info = "Diabetes Prediction API",
    website = "https://alex-devoid.github.io/diabetes-prediction-api/"
  )
}

# Plumber router
r <- plumb("api_model.R")
r$run(port=8000)
