library(tidyverse)
library(ggpubr)
library(car)
library(lme4)
library(lmerTest)
library(emmeans)

setwd("")

##### SUMMARY STATS ####

df <- data.frame(read.csv(file = "traits_Tanshi.csv"))
dim(df)
str(df)

View(df)
plot(df$FA, df$BM)

hist(df$FA)
hist(df$BM)

# which would you report the median for? which would you report the mean?

# some summary statistics:
df_sum <- df %>%
  group_by(Family) %>%
  summarize(mean_fa = mean(FA),
            sd_fa = sd(FA),
            median_fa = median(FA),
            lower = quantile(FA, probs = 0.25),
            upper = quantile(FA, probs = 0.75),
            min_fa = min(FA),
            max_fa = max(FA))

df_sum

# make a figure showing mean & standard deviation: 
ggplot(aes(x = Family, y = mean_fa), data = df_sum) + 
  geom_pointrange(aes(ymin = mean_fa - sd_fa, ymax = mean_fa + sd_fa)) +
  coord_flip()

# two ways to do t.test:
?t.test

df2 <- df %>%
  mutate(Pteropodidae = ifelse(Family == "Pteropodidae", "yes", "no"))

t.test(df2$FA~df2$Pteropodidae)

pteropodidae <- subset(df2, df2$Pteropodidae == "yes")
other_family <- subset(df2, df2$Pteropodidae == "no")

t.test(pteropodidae$FA, other_family$FA)

#### other analyses #####

# simple stats for contingency tables: example from our mosquito paper.
# these are values representing little brown (mylu) and big brown (epfu) bat 
# diet samples (23 and 7) with at least one mosquito species detected in a 
# guano sample vs guano samples with no mosquito detection (9 and 14):

a <- c(23, 7)
b <- c(9, 14)
c <- cbind(a, b)
chisq.test(c)

# interpretation: the observed data is different than what would be
# expected at random

# next: a data frame of some passive acoustic monitoring for bat calls.
# "high calls" is high frequency calls ≥35 kHz 
# "low calls" is low frequency calls <35 kHz 

df <- data.frame(read.csv(file = "calls.csv"))
# check out the structure of your data, there are several helpful functions:
str(df)
summary(df)
names(df)

hist(df$low_calls)
hist(df$high_calls)

# (use an offset of +1 because log(0) is -Inf)
# note: in R, "log" is natural log, while "log10" is log base 10.

# transformation: why choose natural log vs. log base 10?

hist(log(df$low_calls + 1))

# rename your data frame:
calls <- df

# summarize calls for each site:
calls %>%
  group_by(site) %>%
  summarize(total=sum(all_calls),
            median=median(all_calls),
            mean=mean(all_calls),
            sd=sd(all_calls))

# create a new column for "percent forest", which is the same at each site:
# we will use this later.
pforst <- data.frame(cbind(unique(calls$site), 
                           rnorm(17, mean = 0.33, sd = 0.1)))
colnames(pforst) <- c("site", "percent_forest")

# make a boxplot with ggplot2.
# first, convert to long format:

calls_long <- calls %>%
  select(-all_calls) %>%
  left_join(pforst) %>%
  mutate(percent_forest = as.numeric(percent_forest)) %>%
  pivot_longer(cols = c(high_calls, low_calls), names_to = "call_type", 
               values_to = "avg_pulses") 

View(calls_long)

# peek at potential correlated variables (numeric only)
pairs(calls_long[,c(3, 9, 11)])

p <- ggplot(aes(x = as.factor(year), y = log10(avg_pulses + 1),
                fill = call_type), data=calls_long) + 
  geom_boxplot(position = "dodge") + 
  geom_point(position = position_jitterdodge(0.2))
p

# compare wilcox vs t test:
?wilcox.test
?t.test

wilcox.test(calls_long$avg_pulses ~ calls_long$year)
wilcox.test(calls_long$avg_pulses ~ calls_long$call_type)

# what if you want to test both of these variables???

##### linear models ####
mod1 <- lm(log(avg_pulses + 1) ~ as.factor(year) + call_type, 
           data = calls_long)

# residuals are the differences between the values your model predicts and the 
# actual values from your data set

par(mfrow = c(1, 1))
res <- resid(mod1)
qqnorm(res)
hist(res)

# do these residuals "look ok?"
# look for no clear pattern in residual plots
# in QQ plot: points fall mostly along the 45 degree line

# model outputs:
summary(mod1)

# the estimate (slope) for year is -0.30970
# in a linear model, the estimate B can be interpreted as "a 1 unit increase
# in x is associated with a B change in y".

# BUT it is very important to consider how transformation affects your
# interpretations later! 

# for many continuous predictors: you can also center/standardize so that
# "a 1 standard deviation increase in x is associated with a B change in y"
# which can be useful for comparing variables with very different scales.

# we have to transform this estimate because we transformed the response:
m <- -0.7131 
exp(m)

# the effect of year: 2016 had 0.49 times as many average pulses compared to
# 2015

# is our model very good though? 
# just becauses one model is better than another, doesn't mean either are 
# good models!

# try another model:
mod2 <- lm(log(avg_pulses + 1) ~ as.factor(year) + call_type + 
             week + percent_forest, 
           data = calls_long)
summary(mod2)
qqnorm(resid(mod2))

# multicolinearity: when predictor variables are correlated
car::vif(mod2, type = "predictor")
# vif > 5 indicates strong correlations

mod3 <- lm(log(avg_pulses + 1) ~ as.factor(year) * call_type + 
             type + week + percent_forest, 
           data = calls_long)
summary(mod3)
qqnorm(resid(mod3))

# comparing models:
anova(mod1, mod2)
anova(mod2, mod3)

AIC(mod1)
AIC(mod2)
AIC(mod3)

BIC(mod1)
BIC(mod2)
BIC(mod3)

# what's the difference between AIC & BIC? BIC has a heavier penalty for more
# model terms 

# what if you want to compare multiple groups? ANOVA:

moda <- aov(log(avg_pulses + 1) ~ as.factor(pair), data = calls_long)
moda

modb <- lm(log(avg_pulses + 1) ~ as.factor(pair), data = calls_long)
summary(modb)
summary.aov(modb)

# post-hoc testing:

TukeyHSD(moda, conf.level = 0.95)
TukeyHSD(modb, conf.level = 0.95)

emmeans(modb, adjust="tukey", pairwise ~ pair, type="response")

modc <- lm(log(avg_pulses + 1) ~ as.factor(call_type) * as.factor(year), 
           data = calls_long)
emmeans(modc, adjust="tukey", pairwise ~ year | call_type, type="response")

confint(modc)

# mixed effect models:
# fixed effects: variables of interest
# random effects: variables not of interest

require(lmerTest)
mod0 <- lmer(log(avg_pulses + 1) ~ factor(call_type) * factor(year) + 
               (1 | pair), 
           REML = FALSE, # see ?lmer for more info
                         # don't use REML if comparing models
           data = calls_long)

summary(mod0)
confint(mod0)

mod5 <- lmer(log(avg_pulses + 1) ~ factor(call_type) + factor(year) + 
               percent_forest + (1 | pair), 
             REML = FALSE, 
             data = calls_long)

summary(mod5)
exp(-3.2241)

confint(mod5)

# why is there such a big effect of forest when forest was randomly assigned?
site_forest <- calls_long %>%
  group_by(site, pair) %>%
  summarize(forest = mean(percent_forest),
            calls = mean(avg_pulses))

plot(site_forest$forest, site_forest$calls)

# data issue!

# compare LMMs the same way as LMs:
anova(mod0, mod5)

# note plots are different:
plot(mod0)
plot(mod5)

# what is the difference between these two contrasts?

emmeans(mod0, pairwise ~ year | call_type, adjust="tukey", type="response")
emmeans(mod0, pairwise ~ call_type | year, adjust="tukey", type="response")

# revisiting the assumptions of linear models: you need a different 
# modeling approach if your predictors do not have a linear relationship
# with your responses!

# alternative approaches: logistic regresion (1/0 outcomes), generalized
# additive models, polynomial regression, among many others

# if your data has a lot of zeroes (e.g., count data) or if you cannot
# remedy the normality of residuals with transformation, you may need to 
# use another approach like a zero-inflated or negative binomial model.
