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
datastm <- stm(docs, vocab, K = 4,
               prevalence = ~ 1,
               data = meta,
               init.type = "Spectral")


save(datastm, file = here("Data/datastm.rda"))