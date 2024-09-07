library(haven)
library(broom)
library(lfe)
library(dplyr)
library(ggplot2)
library(gt)
library(plotrix)
library(tidyverse)
library(forcats)
library(glue)
library(stargazer)

setwd("/Users/shreyachaturvedi/Downloads/")
part1_data <- read_dta("api210_midterm_part1.dta")
part2_data <- read_dta("api210_midterm_part2.dta")

## Part 1
#Question 5

reg1 <- lm(math_4 ~ voucher + female + hh_asset + math_0,
             part1_data) %>%
  stargazer(type = "text")

# Question 6b
reg2_data <- part1_data %>%
  filter(!(voucher == 1 & attended == 0))

reg2 <- lm(math_4 ~ voucher + female + hh_asset + math_0,
             reg2_data) %>%
  stargazer(type = "text")
  
#Question 6c
reg3_first_stage <- lm(attended ~ voucher + female + hh_asset + math_0, data = part1_data)
first_stage_coeff <- coefficients(reg3_first_stage)["voucher"]

reg3_reduced_form <- lm(math_4 ~ voucher + female + hh_asset + math_0, data = part1_data)
reduced_form_coeff <- coefficients(reg3_reduced_form)["voucher"]

sls_estimate <-   reduced_form_coeff/first_stage_coeff
sls_estimate


##Part 2
#Creating dummy variables
part2_data$voucher_eng <- ifelse(part2_data$voucher == 1 & part2_data$near_eng==1, 1, 0)
part2_data$voucher_tel <- ifelse(part2_data$voucher == 1 & part2_data$near_tel==1, 1, 0)
attend_eng_dummies <- model.matrix(~ attend_eng - 1, data = part2_data)

#Question 3
reg4 <- lm(attend_eng ~ voucher + voucher_eng + near_eng + female + hh_asset + math_0,
             part2_data) %>%
  stargazer(type="text")

#Question 4
reg5<- lm(math_4 ~ female + hh_asset + math_0 + 
                attend_eng_dummies + voucher_eng + near_eng + voucher,
              data = part2_data) %>%
  stargazer(type="text")
  
