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
library(Rtsne)
library(geometry)
library(rsvd)
options(scipen = 9999)

# Parallel Processing ----
num_cores <- parallel::detectCores(logical = TRUE)
registerDoMC(cores = num_cores)

# Loading the data ----
load(here("Data/Youtube/down_meta.rda"))
load(here("Data/Youtube/down_vocab.rda"))
load(here("Data/Youtube/down_docs.rda"))


# Structural Topic Modeling ----
down_datastm <- stm(docs, vocab, K = 0,
                prevalence = ~ 1,
                data = meta,
                seed = 123,
                init.type = "Spectral")


save(down_datastm, file = here("Data/Youtube/down_datastm.rda"))