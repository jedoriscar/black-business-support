# Racial Population Growth 
# Loading Packages ----
library(tidyr) 
library(tidyverse)
library(dplyr)
library(readr) # This is helpful for loading csv files
library(here)
library(janitor)
library(DataExplorer)
# Loading Data ----
data <- readr::read_csv(here("Data/youtube_data.csv")) # loading in the add comments
codes <- readr::read_csv(here("Data/coding.csv")) %>% janitor::clean_names() 
DataExplorer::create_report(data)

#left merge data and codes

library (dplyr)
data <-data.frame()
View(result_deplyr)
codes <-data.frame()
View(codes)
codes <- readr::read_csv(here("Data/coding.csv")) %>% janitor::clean_names() 

save(result_dyplr, file = here("Data/result_dyplr.rda"))