# Loading Packages----
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
options(scipen = 100)


## Data Source:

# Loading data----
load(here("Data/combined_data.rda"))

## Descriptive Analyses for Video text-data (Univariate & Bi-variate)


### Visualizing words in the dataset:

# visualizing the most frequent words in the texts----
combined_data %>%
  with(wordcloud(text, max.words = 100, scale = c(3, 0.5)))

# visualizing the most frequent words in the video titles----
combined_data %>%
  with(wordcloud(video_title, max.words = 100, scale = c(3, 0.5))) 



TFIDF instead of raw count for texts, total frequency of the document instead, words with the highest TFDIF represent what are the most important words, becuase it essentially says that w ord is being used more than its average relative frequency. 

https://github.com/billybrady
https://github.com/billybrady/twitter_tfidf

# Top 25 words in this dataset----
# But how many times does each word appear?
combined_data %>%
  unnest_tokens(word, text) %>%
  count(word, sort = TRUE) %>%
  slice(1:100) # this is letting us the top 25 words 

# examining the most frequent words by each video----
# Most frequent words by video:
combined_data %>%
  unnest_tokens(word, text) %>%
  anti_join(stop_words) %>%
  count(video_title, word, sort = TRUE) %>% 
  group_by(video_title)
# filter(n > 1000) %>%

# pre-processing data to see top words in each texts for each video title----
# Create a tidy text corpus
corpus <- combined_data %>%
  select(video_title, text_clean) %>%
  unnest_tokens(word, text_clean)

# Calculate the frequency of each word
word_freq <- corpus %>%
  count(video_title, word, sort = TRUE)

# Get the top n most frequent words for each title
n <- 1
top_words <- word_freq %>%
  group_by(video_title) %>%
  slice_max(n = n, order_by = n)

# Print the top words for each title
print(top_words)


This table enables us to explore the most common words associated with each video title in the sample. Through this analysis, we gain valuable insights into the variations in texts across different videos. Examining the distinctive words for each video provides a nuanced understanding of the specific language patterns associated with individual videos, contributing to a more comprehensive view of the dataset.

# bigrams----
# Create a tidy text corpus with bigrams
corpus <- combined_data %>%
  select(video_title, text_clean) %>%
  unnest_tokens(bigram, text_clean, token = "ngrams", n = 2)

# Calculate the frequency of each bigram
bigram_freq <- corpus %>%
  count(video_title, bigram, sort = TRUE)

# Get the top n most frequent bigrams for each title
n <- 1
top_bigrams <- bigram_freq %>%
  group_by(video_title) %>%
  slice_max(n = n, order_by = n)




