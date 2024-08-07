#Black Business Support
#Loading packages ----
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
library(dplyr)
library(caret)
options(scipen = 9999)

# Loading Data ----
load(here("Data/Youtube/data.rda"))

# Pre-processing Text data ----
# Separate the dominant video's comments
dominant_video_comments <- data %>% filter(video_id == "bTOoY5MIkvM")
other_video_comments <- data %>% filter(video_id != "bTOoY5MIkvM")

# Calculate the target number of comments from the dominant video
target_size <- 5500

# Downsample the dominant video's comments
set.seed(123)
downsampled_dominant_comments <- dominant_video_comments %>%
  sample_n(size = target_size)

# Combine the downsampled dominant video comments with the other video comments
down_data <- bind_rows(other_video_comments, downsampled_dominant_comments)

# Check the new proportional representation
df <- as.data.frame(table(down_data$video_title))
prop.table(table(down_data$video_id))

save(down_data, file = here("Data/Youtube/down_data.rda"))
