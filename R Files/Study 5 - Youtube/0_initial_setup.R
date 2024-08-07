# Black Business Support 
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
coding_manual <- readr::read_csv(here("Data/coding_manual.csv")) %>% janitor::clean_names() 
codes <- readr::read_csv(here("Data/coding.csv")) %>% janitor::clean_names() 
DataExplorer::create_report(data)

#left merge data and codes
# Perform the join on the common column 'business_id' + 'user_id'
data <- data %>%
  left_join(codes, by = "video_id") 

save(data, file = here("Data/Youtube/data.rda"))
