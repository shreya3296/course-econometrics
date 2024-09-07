library(ggplot2)
library(gridExtra)
library(stargazer)
library(cobalt)
library(RCT)
library(xtable)
library(rddensity)
library(vcov)
library(sandwich)
library(rdrobust)
library(rdlocrand)
library(tidyverse)
library(stringr)

# Set working directory to where the CSV files are located
setwd("/Users/shreyachaturvedi/Downloads/")

# import the headstart dataset
hs_data <- read.csv("headstart.csv")
hs_data <- hs_data[!is.na(hs_data$povrate60),]
dim(hs_data)
var_names <- names(hs_data)
hs_data$census1960_pop <- hs_data$census1960_pop/1000
hs_data$census1990_pop <- hs_data$census1990_pop/1000
cut_off <- 59.1984

# Q1

table_1 <- stargazer(hs_data[, c("povrate60", "mort_age59_related_postHS")], 
                     type = "latex", title = "Summary Table", 
                     out="summ_table1.tex")

table_2 <- stargazer(hs_data[, c("census1960_pop", "census1960_pcturban")], 
                     type = "latex", title = "Summary Table", 
                     out="summ_table2.tex")

# Q2
data <- hs_data %>% 
  mutate(treatment = ifelse(povrate60 >= 59.198, 1, 0))

# 1960 Census covariates
X60 <- data[,var_names %in% c("census1960_pop", "census1960_pctsch1417", 
                              "census1960_pctsch534", "census1960_pctsch25plus",
                              "census1960_pop1417", "census1960_pop534", 
                              "census1960_pop25plus", "census1960_pcturban", 
                              "census1960_pctblack")]

# 1990 Census covariates
X90 <- data[,var_names %in% c("census1990_pop", "census1990_pop1824", 
                              "census1990_pop2534", "census1990_pop3554", 
                              "census1990_pop55plus", "census1990_pcturban")]

covs60 <- data.frame(X60, data$treatment)
covs90 <- data.frame(X90, data$treatment)

sum_tbl60 <- balance_table(covs60, "data.treatment")
names(sum_tbl60) <- c("Variable", "Mean - Below", "Mean - Above",
                      "P-value for difference in means")

xtab60 <- xtable(sum_tbl60, caption="Balancing table 1960", digits=3)
print(xtab60, include.rownames=FALSE, file="Point2_Table60.tex")

sum_tbl90 <- balance_table(covs90, "data.treatment")
names(sum_tbl90) <- c("Variable", "Mean - Below", "Mean - Above",
                      "P-value for difference in means")
xtab90 <- xtable(sum_tbl90, caption="Balancing table 1990", digits=3)
print(xtab90, include.rownames=FALSE, file="Point2_Table90.tex")

# Q3
       