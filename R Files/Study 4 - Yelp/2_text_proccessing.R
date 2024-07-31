# Loading packages ----
library(stm)
library(tm)
library(dplyr)
library(tidyr)
library(readr)
library(tibble)
library(readxl)
library(here)
library(doMC)
options(scipen = 9999)

# Parallel Proccesing ----
num_cores <- parallel::detectCores(logical = TRUE)
registerDoMC(cores = num_cores)

# Loading Data ----
load(here("Data/combined_data.rda"))

# Pre-processing Text data ----
# Create a new dataframe to store the cleaned and preprocessed data
wf_processed <- data.frame(combined_data)

# Stemming the words in texts
for (i in 1:nrow(wf_processed)) {
  text_words <- strsplit(wf_processed$text[i], " ")[[1]]  # Split the text into individual words
  stemmed_words <- stemDocument(text_words)  # Find the stems of the words
  wf_processed$text_clean[i] <- paste(stemmed_words, collapse = " ")  # Replace the text with the stemmed words
}

# Preprocess the text column in wf_dt
wf_proc <- textProcessor(
  documents = wf_processed$text_clean,    # Specify the column containing the texts
  metadata = wf_processed              # Include metadata if available (optional)
)

# Extract the components from wf_proc object
meta <- wf_proc$meta      # Extract the metadata from wf_proc
vocab <- wf_proc$vocab    # Extract the vocabulary from wf_proc
docs <- wf_proc$documents  # Extract the preprocessed documents from wf_proc

# Saving the data ----
save(meta, file = here("Data/meta.rda"))
save(vocab, file = here("Data/vocab.rda"))
save(docs, file = here("Data/docs.rda"))


