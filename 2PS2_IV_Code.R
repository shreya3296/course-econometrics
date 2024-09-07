library(tidyverse)
library(AER)
library(stargazer)

setwd("/Users/shreyachaturvedi/Downloads")
data <- haven::read_dta("AK91_1930_39.dta")

data <- data %>%
  filter(YOB<=39)

data$quarter1 <- ifelse(data$QOB==1,1,0)
data$quarter2 <- ifelse(data$QOB==2,1,0)
data$quarter3 <- ifelse(data$QOB==3,1,0)
data$quarter4 <- ifelse(data$QOB==4,1,0)

data$YOB_QOB <- data$YOB + (data$QOB/4-0.25)

mean_data <- data %>% group_by(YOB_QOB, QOB) %>%
  summarise(MEAN_EDUC = mean(EDUC, na.rm = TRUE))
mean_data$Q1 <- case_when(mean_data$QOB == 1 ~ 1)

ggplot(data=mean_data, aes(x=YOB_QOB, y=MEAN_EDUC)) + 
 scale_x_continuous(labels = number_format(accuracy = 1)) +  
  geom_line() +
  geom_point() +
  labs(title='Years of Education and Season of Birth 1980 Census',
       caption ='Source: Angrist and Krueger, 1991') +
  ylab('Years of Completed Education') +
  xlab('Year of Birth') +
  theme_minimal()

data2 <- data %>%
  group_by(YOB_QOB) %>%
  summarise(MEAN_EDUC = mean(EDUC, na.rm = TRUE)) %>%
  mutate(qtr_minus1 = dplyr::lag(MEAN_EDUC, 1, order_by=YOB_QOB),
         qtr_minus2 = dplyr::lag(MEAN_EDUC, 2, order_by=YOB_QOB),
         qtr_plus1 = dplyr::lead(MEAN_EDUC, 1, order_by=YOB_QOB),
         qtr_plus2 = dplyr::lead(MEAN_EDUC, 2, order_by=YOB_QOB),
         MOVAVG=((qtr_plus2+qtr_plus1+qtr_minus1+qtr_minus2)/4))
data2 <- subset(data2, select = c(YOB_QOB, MOVAVG))

temp <- data %>% left_join(data2, by=c('YOB_QOB')) %>%
  mutate(ADJ_EDUC = EDUC - MOVAVG) %>% 
  filter(!is.na(MOVAVG) & YOB<=39) 
temp$QOB <- relevel(as.factor(temp$QOB), ref=4)
data$QOB <- relevel(as.factor(data$QOB), ref=4)


dummies <- lm(ADJ_EDUC ~ QOB, temp)

rows <- tribble(~term, ~value,
                'Birth cohort',
                '1930-1939',
                'Mean Years of Education',
                as.character(round(mean(temp$EDUC), digits=2)))
attr(rows, 'position') <- c(1,2)

modelsummary(dummies, add_rows = rows,
             gof_map = c("nobs", "r.squared", "F"),
             title='The Effect of Quarter of Birth on Total Years of Education')

models <- list(
  "OLS"     = felm(LWKLYWGE ~ EDUC, data),
  "WALD ESTIMATE" = felm(LWKLYWGE ~ 1 | 0 | (EDUC ~ quarter1), data=data))
modelsummary(models,gof_map = NA,coef_omit=c(1))


data <- data %>% mutate(EDUC_COEF = fitted(felm(EDUC ~  1 | YOB + YOB_QOB, data = data)),
                        EDUC_COEF2 = fitted(felm(EDUC ~  RACE + SMSA + MARRIED + NEWENG  + MIDATL + ENOCENT + WNOCENT + SOATL + ESOCENT +
                                                   WSOCENT + MT | YOB + YOB_QOB, data = orig)))

iv_fe_models <- list(
  "(2) TSLS"     = felm(LWKLYWGE ~ EDUC_COEF  | YOB, data = data),
  "(6) TSLS" = felm(LWKLYWGE ~ EDUC_COEF2 + RACE + SMSA + MARRIED + NEWENG  + MIDATL + ENOCENT +
                      WNOCENT + SOATL + ESOCENT + WSOCENT + MT| YOB, data = data))

modelsummary(iv_fe_models, 
             coef_omit = c(-1,-2,-3,-4),
             coef_rename = c("EDUC_COEF2" = "EDUC_COEF", "vs" = "EDUC_COEF"),
             gof_map = c("nobs", "r.squared", "F"),
             title='TSLS ESTIMATES WITH FIXED EFFECTS')