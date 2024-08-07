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
library (vader)

# Parallel Proccessing ----
num_cores <- parallel::detectCores(logical = TRUE)
registerDoMC(cores = num_cores)

# Load the Data ----
load(here("Data/datagamma_combined.rda"))

# Dataframe of vader results ----
vader_results <- vader_df(datagamma_combined$comment) 
save(vader_results, file = here("Data/vader_results.rda"))

#joining with datagamma_combined----
load(here("Data/datagamma_combined.rda"))
load(here("Data/vader_results.rda"))
vader_results <-vader_results %>% rename(comment = text) #renaming column in vader to comment

combined_data <- datagamma_combined %>% left_join(vader_results, by = "comment")

# Remove duplicate rows based on the 'comment' column
combined_data <- combined_data %>% distinct(comment, .keep_all = TRUE)

save(combined_data, file = here("Data/combined_data.rda"))
