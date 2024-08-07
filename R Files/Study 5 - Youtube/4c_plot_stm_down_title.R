# Black Business Support
# Loading packages ----
library(stm)
library(tm)
library(dplyr)
library(tidyr)
library(readr)
library(tibble)
library(readxl)
library(ggplot2)
library(wordcloud)
library(tidytext)
library(lubridate)
library(skimr)
library(here)
library(doMC)
options(scipen = 9999)

# Load Data ---
load(here("Data/datagamma_combined.rda"))
load(here("Data/datastm2.rda"))

# Plots -----
# Basic plot
plot(datastm2, type = "summary", xlim = c(0, 0.3), ylim = c(0, 62))

# Plot with metadata
prep <- estimateEffect(1:63 ~ events_rec_policy_mention,  # Covariate: title
               stmobj = datastm2,  # STM object
               metadata = meta,  # Metadata
               uncertainty = "None")  # No uncertainty estimation

plot(prep, covariate = "events_rec_policy_mention", topics = c(33, 50, 22), model = datastm2,
     method = "difference", cov.value1 = "no", cov.value2 = "yes",
     xlab = "No Policy mentioned ... Policy Mentioned", 
     main = "Policy Mention vs. No Mention",
     xlim = c(-0.1, 0.1), labeltype = "custom", 
     custom.labels = c("Black", "Business Support", "White"))

# Correlation with each other
mod.out.corr <- topicCorr(datastm2)
plot(mod.out.corr)


summary(lm(topic_33 ~ events_rec_policy_mention, data = datagamma_combined))

summary(glm(as.factor(events_rec_policy_mention) ~ topic_33 + topic_50 + topic_22, 
    family = binomial(link = "log"), data = datagamma_combined))

skim <- meta %>% skimr::skim_without_charts()


