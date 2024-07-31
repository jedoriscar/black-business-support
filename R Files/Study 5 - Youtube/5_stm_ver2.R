# Racial Population Growth
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

# Loading the data ----
load(here("Data/meta.rda"))
load(here("Data/vocab.rda"))
load(here("Data/docs.rda"))



# Structural Topic Modeling ----
set.seed(123)  # Set a specific seed value for reproducibility
datastm_2 <- stm(docs, vocab, K = 2,
               prevalence = ~ 1,
               data = meta,
               init.type = "Spectral")


save(datastm_2, file = here("Data/datastm_2.rda"))

# Interpreting the STM Model ----
top_words <- tidy(datastm_2, matrix = "beta") %>%
  group_by(topic) %>%
  top_n(10, beta) %>%
  ungroup() %>%
  select(topic, term, beta) %>%
  arrange(topic, -beta)

write.table(top_words, file = here("Data/datastm_2_terms.txt"), sep = "\t", quote = FALSE, row.names = FALSE)

# Estimate the effect of title on each topic
datastm_2_effects <- estimateEffect(1:2 ~ 1,  # Covariate: title
                                  stmobj = datastm_2,  # STM object
                                  metadata = meta,  # Metadata
                                  uncertainty = "None")  # No uncertainty estimation

# Redirect the output to a text file
sink(here("Data/datastm_2_effects.txt"))
