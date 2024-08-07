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

# Parallel Proccessing ----
num_cores <- parallel::detectCores(logical = TRUE)
registerDoMC(cores = num_cores)

# Load the Data ----
load(here("Data/datastm2.rda"))

# Interpreting the STM Model ----
top_words <- tidy(datastm2, matrix = "beta") %>%
  group_by(topic) %>%
  top_n(10, beta) %>%
  ungroup() %>%
  select(topic, term, beta) %>%
  arrange(topic, -beta)

write.table(top_words, file = here("Data/datastm2_terms.txt"), sep = "\t", quote = FALSE, row.names = FALSE)


# Estimate the effect of title on each topic
datastm2_effects <- estimateEffect(1:6 ~ 1,  # Covariate: title
                                  stmobj = datastm2,  # STM object
                                  metadata = meta,  # Metadata
                                  uncertainty = "None")  # No uncertainty estimation

# Redirect the output to a text file
sink(here("Data/datastm2_effects.txt"))


# Summarize the effects
summary(datastm2_effects)

# Stop redirecting the output
sink()


# Create a matrix of topic scores or values
datagamma <- tidy(datastm2, matrix = "gamma")

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
  colnames(datagamma_combined)[(ncol(datagamma_combined)-5):ncol(datagamma_combined)] <- paste0("topic_", 1:6)
  
  # 'datagamma_combined' now contains the metadata, comments, and corresponding gamma values
} else {
  print("Number of rows in 'meta' and 'datagamma' do not match.")
}

save(datagamma_combined, file = here("Data/datagamma_combined.rda"))

datagamma_combined %>% ggplot(aes(x = topic_1)) + geom_density()
