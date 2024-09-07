# Load required packages
library(haven)
library(AER)
library(stargazer)

#Part 1
part_1 <- read_dta('api210_final_part01.dta')

IV_model <- ivreg(charges ~ ssi_lost + physical + age_receive + factor(state_fips) | 
                    reviewed + physical + age_receive + factor(state_fips), data = part_1)
states_clus <- vcovCL(IV_model, cluster = part_1$state_fips)
coeftest(IV_model,states_clus)

first_stage <- lm(ssi_lost ~ reviewed + physical + age_receive + factor(state_fips), data=part_1)
summary(first_stage, coef_omit = "factor(state_fips)" )

second_stage <- lm(charges ~ ssi_lost + physical + age_receive + factor(state_fips), data=part_1)
summary(second_stage)

stargazer(second_stage, type = "latex")

t.test(physical ~ reviewed, data=part_1)
t.test(age_receive ~ reviewed, data=part_1)

#Part 2

part_2 <- read_dta('api210_final_part02.dta')

bandwidth <- 50
part_2_band <- part_2[abs(part_2$bday18_rel) <= bandwidth,]
part_2_band$weights <- (1 - abs(part_2_band$bday18_rel / bandwidth))

rdd_model <- lm(charges ~ ssi_lost * bday18_rel + physical + age_receive, data = part_2_band, weights = part_2_band$weights)
summary(rdd_model)
stargazer(rdd_model, type = "latex")

#Part 3
part_3 <- read_dta("api210_final_part03.dta")
event_df <- part_3 %>%
  group_by(year, ssi_lost, post2005) %>%
  mutate(post2005 = as.factor(post2005)) %>%
  summarize(mean_crime = mean(crime)) 

df_ssi_lost_0 <- event_df[event_df$ssi_lost == 0, ]
df_ssi_lost_1 <- event_df[event_df$ssi_lost == 1, ]

ggplot() +
  geom_line(data = df_ssi_lost_0, aes(x = year, y = mean_crime), color = "red") +
  geom_line(data = df_ssi_lost_1, aes(x = year, y = mean_crime), color = "brown") +
  labs(x = "Year", y = "Criminal Charge") +
  geom_vline(xintercept = 2005, linetype = "dashed") +
  theme_gray()


did <- part_3 %>%
  mutate(ssi_2005 = ssi_lost*post2005)
model <- felm(crime ~ ssi_2005 + physical + hh_index | factor(st_id) + factor(year) | 0 | st_id, data = did)
model %>% 
  tidy()


summary_table <- stargazer(model, type = "latex", summary = FALSE)


treated_group <- did[did$ssi_lost == 1, ]
control_group <- did[did$ssi_lost == 0, ]

# Perform t-tests or chi-square tests for relevant covariates
did_pre2005 <- did %>%
  filter(year < 2005)

treated_group <- did_pre2005[did_pre2005$ssi_lost == 1, ]
control_group <- did_pre2005[did_pre2005$ssi_lost == 0, ]
t_physical <- t.test(treated_group$physical, control_group$physical) %>%
  tidy() %>%
  mutate(var = "physical")
t_hh <- t.test(treated_group$hh_index, control_group$hh_index) %>%
  tidy() %>%
  mutate(var = "socioeconomic index")

t_crime <- t.test(treated_group$crime, control_group$crime) %>%
  tidy() %>%
  mutate(var = "criminal activity")

ttest <- rbind(t_crime, t_physical, t_hh) %>%
  select(1, 4:8, 11) %>%
  mutate_at(vars(1:6), ~ round(., 2))
ttest_table <- stargazer(ttest, type = "latex", summary = FALSE)

