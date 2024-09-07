#Problem Set 4
#Shreya Chaturvedi
#April 24,2023

packages <- c('haven','dplyr', 'ggplot2', 'reshape2', 'tidyverse', 'pracma',
              'lubridate', 'scales', 'ggthemes', 'gt', 'tidymodels', 'flextable', 
              'rsample', 'knitr', 'hdm', 'pROC', 'glmnet', 'randomForest', 'lfe', 
              'plotrix', 'dotwhisker','lfe', 'stargazer', 'cobalt', 'rdrobust', 'ggpubr')  
to_install <- packages[!(packages %in% installed.packages()[,"Package"])]
if(length(to_install)>0) install.packages(to_install, 
                                          repos='http://cran.us.r-project.org')
lapply(packages, require, character.only=TRUE)

library(bacondecomp)
library(EventStudy)
library(did)
library(plm)
library(haven)
library(tidyverse)
library(lfe)
library(broom)
library(plyr)

rm(list = ls())
setwd("/Users/shreyachaturvedi/Downloads/")

# Reading in data
my_data <- read_dta("stevenson_wolfers_210.dta")

# Filtering data
my_data %>% 
  filter(sex == 2, !is.na(divyear)) %>% 
  mutate(st = as.factor(st), year = as.integer(year), ln_suicide_rate = log(suiciderate_jag)) -> my_data

# Creating DID variables
my_data %>% 
  mutate(treat = (divyear == 1973), post = (year >= 1973), treat_post = treat*post) %>% 
  filter(divyear %in% c(1973, 2000)) -> my_data_2x2

# Running DID regression
felm(ln_suicide_rate ~ treat_post + treat + post | 0 | 0 | st, my_data_2x2)

# Creating event study variables
my_data %>% 
  mutate(lag = (year-divyear)) -> my_data_event

my_data_event$lag[my_data_event$divyear %in% c(1950,2000)] <- -1
my_data_event$lag[my_data_event$lag <= -6] <- -6
my_data_event$lag[my_data_event$lag >= 12] <- 12

my_data_event %>% 
  mutate(lag = as.factor(lag)) -> my_data_event

my_data_event <- within(my_data_event, lag <- relevel(lag, ref = 6))

# Estimating event study
my_event_study <- felm(ln_suicide_rate ~ lag | st + year | 0 | st, my_data_event) %>% tidy()

my_event_study %>% 
  add_row(estimate = 0, std.error = 0) %>% 
  add_column(lag = c(seq(-6, -2, 1), seq(0, 12, 1), -1)) -> my_event_study

# Plotting event study
my_plot_es <- ggplot(my_event_study, aes(x = lag, y = estimate)) +
  geom_line(color = "dark gray", linewidth = 1) +
  geom_ribbon(aes(ymin = estimate - 1.96*std.error, ymax = estimate + 1.96*std.error), alpha = .2) +
  theme_classic() +
  geom_vline(xintercept = -1) +
  geom_hline(yintercept = 0) +
  labs(title="Log Suicides per 1m Women", x="Years Relative to Divorce Reform", y="")

my_plot_es

# Estimating 2-way fixed-effects DID specification
felm(ln_suicide_rate ~ unilateral | st + year | 0 | st, my_data) %>% tidy()
