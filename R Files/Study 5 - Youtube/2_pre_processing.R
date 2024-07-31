#Racial Population Growth
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
options(scipen = 9999)

# Loading Data ----
coding_manual <- read.csv("Data/coding_manual.csv") 
load(here("Data/result_dyplr.rda"))
data <- result_dyplr

# Pre-processing Text data ----
# Create a new dataframe to store the cleaned and preprocessed data
yt_processed <- data.frame(data)

# Stemming the words in comments
for (i in 1:nrow(yt_processed)) {
  comment_words <- strsplit(yt_processed$comment[i], " ")[[1]]  # Split the comment into individual words
  stemmed_words <- stemDocument(comment_words)  # Find the stems of the words
  yt_processed$comment_clean[i] <- paste(stemmed_words, collapse = " ")  # Replace the comment with the stemmed words
}

# Preprocess the comment column in yt_dt
yt_proc <- textProcessor(
  documents = yt_processed$comment_clean,    # Specify the column containing the comments
  metadata = yt_processed              # Include metadata if available (optional)
)

# Extract the components from yt_proc object
meta <- yt_proc$meta      # Extract the metadata from yt_proc
vocab <- yt_proc$vocab    # Extract the vocabulary from yt_proc
docs <- yt_proc$documents  # Extract the preprocessed documents from yt_proc

# Saving the data ----
save(meta, file = here("Data/meta.rda"))
save(vocab, file = here("Data/vocab.rda"))
save(docs, file = here("Data/docs.rda"))


