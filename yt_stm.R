# Black Business Support STM YouTube
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
load(here("Data/Youtube/meta.rda"))
load(here("Data/Youtube/vocab.rda"))
load(here("Data/Youtube/docs.rda"))

# Structural Topic Modeling ----
set.seed(123)  # Set a specific seed value for reproducibility

# Fit models with different K values
datastm2 <- stm(docs, vocab, K = 6,
               prevalence = ~ 1,
               data = meta,
               init.type = "Spectral")
save(datastm2, file = here("Data/Youtube/datastm2.rda"))


