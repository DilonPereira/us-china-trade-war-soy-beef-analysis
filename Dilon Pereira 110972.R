############################################################
# Thesis Analysis Script
# TRADE SHOCK AND ENVIRONMENTAL SPILLOVER: THE CAUSAL LINK BETWEEN U.S.-CHINA TRADE WAR AND INCREASED SOY-BEEF DRIVEN DEFORESTATION IN THE BRAZILIAN AMAZON.
# Author: [DILON GEORGE PEREIRA 110972]
# Purpose: Replication of empirical results
############################################################

# Set working directory (CHANGE to your project folder)
# Example:
# setwd("C:/Users/YourName/ThesisProject")

setwd("YOUR/PROJECT/FOLDER/HERE")


############################################################
# 1. Load Required Libraries
############################################################

library(dplyr)
library(tidyr)
library(ggplot2)
library(readr)
library(scales)
library(lubridate)
library(AER)
library(sandwich)
library(tidyverse)

# Reading the first file
soy_long <- read.csv("soy_long.csv")

# Reading the second file
backup_df <- read.csv("backup_df.csv")

############################################################
# 2. Econometric Models
############################################################

# -----------------------------
# Ordinary Least Squares (OLS)
# -----------------------------

ols_model <- lm(
  Deforestation_Brazil ~ Brazil_Soy_Exports_China +
    USA_Soy_Exports_China +
    Argentina_Soy_Exports_China +
    Brazil_Soy_Exports_EU +
    Brazil_Beef_Exports_China +
    USA_Beef_Exports_China,
  data = backup_df
)

summary(ols_model)


# -----------------------------
# Instrumental Variable (IV)
# -----------------------------

iv_model <- ivreg(
  Deforestation_Brazil ~ Brazil_Soy_Exports_China +
    USA_Soy_Exports_China +
    Argentina_Soy_Exports_China +
    Brazil_Soy_Exports_EU +
    Brazil_Beef_Exports_China +
    USA_Beef_Exports_China |
    UCT_Index +
    USA_Soy_Exports_China +
    Argentina_Soy_Exports_China +
    Brazil_Soy_Exports_EU +
    Brazil_Beef_Exports_China +
    USA_Beef_Exports_China,
  data = backup_df
)

summary(iv_model)

# Robust Anderson–Rubin confidence interval
confint(iv_model, level = 0.95, vcov = sandwich, type = "AR")


############################################################
# 3. First-Stage IV Diagnostics
############################################################

# Reports weak instrument test, Wu–Hausman test, and Sargan test
summary(iv_model, diagnostics = TRUE)


############################################################
# 4. Parallel Trends Test (Pre-Treatment)
############################################################

soy_long <- soy_long %>%
  mutate(Group = ifelse(Country == "Brazil", 1, 0))

parallel_trends_test <- lm(
  Soy_Exports_China ~ Group * Time_Trend,
  data = pre_treatment_data
)

summary(parallel_trends_test)


############################################################
# 5. Difference-in-Differences Estimation
############################################################

did_model <- lm(
  Soy_Exports_China ~ Group * Post_Treatment,
  data = soy_long
)

summary(did_model)
