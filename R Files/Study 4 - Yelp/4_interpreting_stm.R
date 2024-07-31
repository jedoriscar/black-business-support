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

# Parallel Processing ----
num_cores <- parallel::detectCores(logical = TRUE)
registerDoMC(cores = num_cores)

# Loading the data ----
load(here("Data/datastm.rda"))

top_words <- tidy(datastm, matrix = "beta") %>%
  group_by(topic) %>%
  top_n(10, beta) %>%
  ungroup() %>%
  select(topic, term, beta) %>%
  arrange(topic, -beta)

write.table(top_words, file = here("Data/datastm_terms.txt"), sep = "\t", quote = FALSE, row.names = FALSE)


# Estimate the effect of title on each topic
datastm_effects <- estimateEffect(1:4 ~ 1,  # Covariate: 
                                  stmobj = datastm,  # STM object
                                  metadata = meta,  # Metadata
                                  uncertainty = "None")  # No uncertainty estimation

# Redirect the output to a text file
sink(here("Data/datastm_effects.txt"))

# Summarize the effects
summary(datastm_effects)

# Stop redirecting the output
sink()



# Create a matrix of topic scores or values
datagamma <- tidy(datastm, matrix = "gamma")

# Spread the topic scores across columns
datagamma <- datagamma %>%
  spread(key = topic, value = gamma)

# Assuming 'meta' contains the metadata of the videos and has 6958 rows
num_rows <- nrow(meta)  # Get the number of rows in the 'meta' dataframe

# Make sure the number of rows matches between 'meta' and 'datagamma'
if (num_rows == nrow(datagamma)) {
  # Combine gamma values with metadata and comments
  datagamma_combined <- cbind(meta, datagamma)
  
  # Rename the last four columns to 'topic_1', 'topic_2', 'topic_3', 'topic_4'
  colnames(datagamma_combined)[(ncol(datagamma_combined)-3):ncol(datagamma_combined)] <- paste0("topic_", 1:4)
  
  # 'datagamma_combined' now contains the metadata, comments, and corresponding gamma values
} else {
  print("Number of rows in 'meta' and 'datagamma' do not match.")
}


summary(lm(topic_1 ~ woman_owned_label, data = datagamma_combined))
