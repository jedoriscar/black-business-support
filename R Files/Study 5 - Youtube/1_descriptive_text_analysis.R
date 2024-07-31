# Racial Population Growth
# Loading Packages----
library(stm)
library(tm)
library(tibble)
library(wordcloud)
library(tidytext)
library(lubridate)
library(readxl)
library(ggplot2)
library(skimr)
library(here)
library(dplyr)
library(tidyr)
library(readr)
options(scipen = 99999)


## Data Source:

# Loading data----
coding_manual <- read.csv(here("Data/coding_manual.csv")) 
load(here("Data/data.rda")) 

# Renaming data
data <- data



## Descriptive Analyses for Video text-data (Univariate & Bi-variate)


### Visualizing words in the dataset:

# visualizing the most frequent words in the comments----
data %>%
  with(wordcloud(comment, max.words = 100, scale = c(3, 0.5)))


# visualizing the most frequent words in the video titles----
data %>%
  with(wordcloud(video_title, max.words = 100, scale = c(3, 0.5))) 


# TFIDF instead of raw count for comments, total frequency of the document instead, words with the highest TFDIF represent what are the most important words, becuase it essentially says that w ord is being used more than its average relative frequency. 

# Top 25 words in this dataset----
# But how many times does each word appear?
top_25 <- data %>%
  unnest_tokens(word, comment) %>%
  count(word, sort = TRUE) %>%
  slice(1:100) # this is letting us the top 25 words 



# examining the most frequent words by each video----
# Most frequent words by video:
data %>%
  unnest_tokens(word, comment) %>%
  anti_join(stop_words) %>%
  count(video_title, word, sort = TRUE) %>% 
  group_by(video_title)
# filter(n > 1000) %>%

# pre-processing data to see top words in each comments for each video title----
# Create a tidy text corpus
corpus <- data %>%
  select(video_title, comment) %>%
  unnest_tokens(word, comment)

# Calculate the frequency of each word
word_freq <- corpus %>%
  count(video_title, word, sort = TRUE)

# Get the top n most frequent words for each title
n <- 100
top_words <- word_freq %>%
  group_by(video_title) %>%
  slice_max(n = n, order_by = n)

# Print the top words for each title
print(top_words)



# bigrams----
# Create a tidy text corpus with bigrams
corpus <- data %>%
  select(comment) %>%
  unnest_tokens(bigram, comment, token = "ngrams", n = 2) %>%
  slice_max(n = n, order_by = n)

# Calculate the frequency of each bigram
bigram_freq <- corpus %>%
  count(video_title, bigram, sort = TRUE)

# Get the top n most frequent bigrams for each title
n <- 1
top_bigrams <- bigram_freq %>%
  group_by(video_title) %>%
  slice_max(n = n, order_by = n)


