#Problem Set 1 Code: Shreya Chaturvedi

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



# Question 1
ghana <- read_dta("./ReplicationDataGhanaJDE.dta")

ghana_clean <- ghana %>%
  select(sheno, SHENO1, groupnum, cashtreat, equiptreat, assigntreat, realfinalprofit, wave) %>%
  group_by(sheno) %>%
  arrange(sheno, wave) %>%
  filter(wave == 1) %>%
  distinct() %>%
  mutate(treat = case_when(cashtreat == 1 ~ 1,
                           equiptreat == 1 ~ 2,
                           assigntreat == 0 ~ 0)) %>%
  ungroup()

ghana_clean %>%
  group_by(treat) %>%
  summarise(n = n(), rand = length(unique(ghana_clean$groupnum)), prof = mean(realfinalprofit, na.rm = TRUE), se = std.error(realfinalprofit, na.rm = TRUE))

q1a <-
  tibble(
    `Country` = "Ghana",
    `Households` = "793",
    `Randomization Units` = "195",
    `Control Mean (SE)` = "124 (17.1)",
    `Treatment Mean (SE)` = "118 (7.7)")


ghana_clean <- ghana_clean %>%
  mutate(treatment = ifelse(treat == 0, 0, 1))

t.test(ghana_clean$realfinalprofit[ghana_clean$treatment == 0], ghana_clean$realfinalprofit[ghana_clean$treatment == 1])

# Question 2
q2a <- tidy(felm(realfinalprofit ~ atreatcash + atreatequip | groupnum + wave | 0 | sheno,
                  ghana))
q2a
q2a <- gt(q2a) 
q2a


data <- ghana %>% filter(is.na(trimgroup))
q2b <- tidy(felm(realfinalprofit ~ atreatcash + atreatequip | groupnum + wave | 0 | sheno,
                  data))
q2b
q2b <- gt(q2b) 
q2b

# Question 3
q3 <- tidy(felm(realfinalprofit ~ atreatcashfemale + atreatequipfemale +
                    atreatcashmale + atreatequipmale | groupnum + wave +
                    wave2_female + wave3_female + wave4_female + wave5_female +
                    wave6_female | 0 | sheno, data))
q3
q3 <- gt(q3) 
q3

q3_df <- as.data.frame(q3)
q3_df <- q3_df %>%
  mutate(std.error = as.numeric(std.error),
         estimate = as.numeric(estimate),
         ci_90_up = estimate + std.error*1.65, 
         ci_90_down = estimate - std.error*1.65, 
         ci_95_up = estimate + std.error*1.96, 
         ci_95_down = estimate - std.error*1.96)

q3_df$xlabs <- c("Cash Treatment* Female","In-Kind Treatment* Female","Cash Treatment* Male","In-Kind Treatment* Male")




plot <- ggplot(q3_df, aes(x = term, y = estimate)) + 
  geom_hline(yintercept = 0, 
             colour = gray(1/2), lty = 2) +
  geom_point(aes(x = term, 
                 y = estimate)) + 
  geom_linerange(aes(x = term, 
                     ymin = ci_90_down,
                     ymax = ci_90_up),
                 lwd = 1) +
  geom_linerange(aes(x = term, 
                     ymin = ci_95_down,
                     ymax = ci_95_up),
                 lwd = 1/2) + 
  coord_flip()  +
  scale_x_discrete(labels = q3_df$xlabs)

print(plot  + labs(title = "Fafchamps et al. (2014)", subtitle =  "Dep. Var.: Real Profits per month (Cedi)"))

