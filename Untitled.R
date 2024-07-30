---
title: "ST558-Final Project EDA"
format: html
author: "Alex Devoid" 
date: "July 30, 2024"
purpose: "ST558-Final Project"
---


# Introduction

## Dataset Overview

The dataset "Diabetes Health Indicators" comprises data collected through the Behavioral Risk Factor Surveillance System (BRFSS) in 2015. This dataset includes a variety of health-related metrics and demographic information for individuals, with a particular emphasis on diabetes prevalence.

### Key Variables for Analysis
- **Diabetes_binary**: A binary response variable indicating diabetes diagnosis (1 for diagnosed, 0 for not diagnosed).
- **HighBP**: Indicates whether the respondent has high blood pressure (1 for yes, 0 for no).
- **HighChol**: Indicates if the respondent has high cholesterol.
- **CholCheck**: Indicates if the respondent had a cholesterol check in the past five years.
- **BMI**: Body Mass Index, calculated from the respondent's height and weight.
- **Smoker**: Indicates current smoking status.
- **PhysActivity**: Indicates if the respondent participates in any physical activity.
- **Fruits and Veggies**: Consumption indicators.
- **GeneralHealth**: Self-reported health status on a scale from excellent to poor.
- **Age**: Categorical age ranges.
- **Sex**: Gender of the respondent.

## Purpose of EDA
The primary goals of this exploratory data analysis (EDA) are to:
  1. **Understand Data Structure**: Examine data storage formats and validate data integrity.
2. **Data Validation**: Perform checks for missing values and data consistency.
3. **Data Cleaning**: Handle missing values and convert variables into appropriate formats, like factors with meaningful level names.
4. **Distributions Analysis**: Analyze distributions of individual variables and investigate their relationships with the response variable, `Diabetes_binary`.
5. **Data Transformation**: Apply necessary transformations, re-examine distributions, and relationships.

# Data Import and Cleaning

## Importing Data


```{r}
library(tidyverse)

# Load the dataset
data_path <- "../diabetes_binary_health_indicators_BRFSS2015.csv"
diabetes_data <- read_csv(data_path)

# Display the first few rows of the data
head(diabetes_data)
```

## Understanding Data Structure

We start by examining the structure and summary statistics of the dataset to understand variable types and distributions.

```{r}
# Check data structure
str(diabetes_data)

# Summary of data
summary(diabetes_data)
```

## Data Validation

We check for missing values to ensure data completeness and validate the consistency of data types.

```{r}
# Check for missing values
missing_values <- colSums(is.na(diabetes_data))
missing_values
```

## Data Cleaning

We convert categorical variables to factors with descriptive labels and address any missing data.

```{r}
# Convert variables to factors
diabetes_data <- diabetes_data %>%
  mutate(
    Diabetes_binary = factor(Diabetes_binary, levels = c(0, 1), labels = c("No", "Yes")),
    HighBP = factor(HighBP, levels = c(0, 1), labels = c("No", "Yes")),
    HighChol = factor(HighChol, levels = c(0, 1), labels = c("No", "Yes")),
    CholCheck = factor(CholCheck, levels = c(0, 1), labels = c("No", "Yes")),
    Smoker = factor(Smoker, levels = c(0, 1), labels = c("Non-smoker", "Smoker")),
    PhysActivity = factor(PhysActivity, levels = c(0, 1), labels = c("No", "Yes")),
    Fruits = factor(Fruits, levels = c(0, 1), labels = c("No", "Yes")),
    Veggies = factor(Veggies, levels = c(0, 1), labels = c("No", "Yes")),
    GeneralHealth = factor(GenHlth, levels = c(1:5), labels = c("Excellent", "Very Good", "Good", "Fair", "Poor")),
    Sex = factor(Sex, levels = c(0, 1), labels = c("Female", "Male")),
    Age = factor(Age, levels = 1:13, labels = c("18-24", "25-29", "30-34", "35-39", "40-44", "45-49", "50-54", "55-59", "60-64", "65-69", "70-74", "75-79", "80+"))
  )

# Handle missing values if necessary
# Example: Replace NA in BMI with median
diabetes_data$BMI[is.na(diabetes_data$BMI)] <- median(diabetes_data$BMI, na.rm = TRUE)
```

# Exploratory Data Analysis

## Univariate Analysis

We explore the distribution of each key variable, focusing particularly on those most relevant to diabetes prevalence.

```{r}
# Plot distribution of Age
ggplot(diabetes_data, aes(x = Age)) +
  geom_bar(fill = "skyblue", alpha = 0.7) +
  theme_minimal() +
  labs(title = "Age Distribution", x = "Age Range", y = "Count")

# Plot distribution of BMI
ggplot(diabetes_data, aes(x = BMI)) +
  geom_histogram(binwidth = 1, fill = "green", alpha = 0.7) +
  theme_minimal() +
  labs(title = "BMI Distribution", x = "BMI", y = "Count")

# Distribution of Diabetes_binary
ggplot(diabetes_data, aes(x = Diabetes_binary)) +
  geom_bar(fill = "orange", alpha = 0.7) +
  theme_minimal() +
  labs(title = "Distribution of Diabetes Status", x = "Diabetes Status", y = "Count")
```

## Multivariate Analysis

We explore relationships between variables, with an emphasis on how they relate to the response variable `Diabetes_binary`.

```{r}
# Relationship between Age and Diabetes
ggplot(diabetes_data, aes(x = Age, fill = Diabetes_binary)) +
  geom_bar(position = "fill", alpha = 0.7) +
  theme_minimal() +
  labs(title = "Age and Diabetes", x = "Age Range", y = "Proportion", fill = "Diabetes")

# BMI vs. Diabetes
ggplot(diabetes_data, aes(x = BMI, fill = Diabetes_binary)) +
  geom_histogram(binwidth = 1, position = "fill", alpha = 0.7) +
  theme_minimal() +
  labs(title = "BMI and Diabetes", x = "BMI", y = "Proportion", fill = "Diabetes")

# General Health vs. Diabetes
ggplot(diabetes_data, aes(x = GeneralHealth, fill = Diabetes_binary)) +
  geom_bar(position = "fill", alpha = 0.7) +
  theme_minimal() +
  labs(title = "General Health and Diabetes", x = "General Health", y = "Proportion", fill = "Diabetes")
```

## Data Transformations

If necessary, we apply transformations such as logarithmic scaling to improve the analysis and visualization.

```{r}
# Example: Log transformation of BMI if needed
diabetes_data <- diabetes_data %>%
  mutate(BMI_log = log(BMI + 1)) # Adding 1 to avoid log(0)

# Re-check distribution of transformed BMI
ggplot(diabetes_data, aes(x = BMI_log)) +
  geom_histogram(binwidth = 0.1, fill = "purple", alpha = 0.7) +
  theme_minimal() +
  labs(title = "Log-Transformed BMI Distribution", x = "Log(BMI)", y = "Count")
```

# Conclusion

The exploratory data analysis provided valuable insights into the distribution and relationships among key health indicators related to diabetes. We observed significant associations between variables such as age, BMI, and general health status with diabetes prevalence. These findings will guide the feature selection and model building processes in the subsequent stages. Further steps will include more detailed statistical analysis, feature engineering, and predictive modeling to better understand and predict diabetes status.



