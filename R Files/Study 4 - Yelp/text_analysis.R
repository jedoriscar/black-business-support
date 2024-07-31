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
yt_dt_code_manual <- read.csv("~/Documents/Police-Brutality/Data/yt_dt_coding_manual.csv") 
load(here("~/Documents/Police-Brutality/Data/yt_dt_joined_filtered.rda"))


## Descriptive Analyses for Video text-data (Univariate & Bi-variate)


### Visualizing words in the dataset:

# visualizing the most frequent words in the comments----
combined_data %>%
  with(wordcloud(comment, max.words = 100, scale = c(3, 0.5)))

go back and collect subscriber counts for each video. And compare high vs low subscriber count channels, are they changing the types of titles they re using, you can also do it by channel type as well or maybe even likes/views on a video. We should look into political leaning. 

# visualizing the most frequent words in the video titles----
combined_data %>%
  with(wordcloud(video_title, max.words = 100, scale = c(3, 0.5))) 



TFIDF instead of raw count for comments, total frequency of the document instead, words with the highest TFDIF represent what are the most important words, becuase it essentially says that w ord is being used more than its average relative frequency. 

https://github.com/billybrady
https://github.com/billybrady/twitter_tfidf

# Top 25 words in this dataset----
# But how many times does each word appear?
yt_dt_joined_filtered %>%
  unnest_tokens(word, comment) %>%
  count(word, sort = TRUE) %>%
  slice(1:100) # this is letting us the top 25 words 


This table provides specific statistics on the frequency of each word, corroborating our observations from the word cloud above. The detailed information presented in this table serves to validate and reinforce the insights gleaned from our earlier examination of comments. It offers a more granular understanding of the distribution and prevalence of individual words, further supporting our interpretation of the textual patterns within the dataset.

# examining the most frequent words by each video----
# Most frequent words by video:
yt_dt_joined_filtered %>%
  unnest_tokens(word, comment) %>%
  anti_join(stop_words) %>%
  count(video_title, word, sort = TRUE) %>% 
  group_by(video_title)
# filter(n > 1000) %>%


This table enables us to explore the most common words for each comment within the sample, providing valuable insights into the variability of comments across different videos. By examining the distinctive words associated with each comment, we gain a nuanced understanding of the diverse language patterns and content nuances present in the comments section of each video. This granularity enhances our ability to discern specific characteristics and trends associated with individual videos within the sampled dataset.

# pre-processing data to see top words in each comments for each video title----
# Create a tidy text corpus
corpus <- yt_dt_joined_filtered %>%
  select(video_title, comment_clean) %>%
  unnest_tokens(word, comment_clean)

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


This table enables us to explore the most common words associated with each video title in the sample. Through this analysis, we gain valuable insights into the variations in comments across different videos. Examining the distinctive words for each video provides a nuanced understanding of the specific language patterns associated with individual videos, contributing to a more comprehensive view of the dataset.

# bigrams----
# Create a tidy text corpus with bigrams
corpus <- yt_dt_joined_filtered %>%
  select(video_title, comment_clean) %>%
  unnest_tokens(bigram, comment_clean, token = "ngrams", n = 2)

# Calculate the frequency of each bigram
bigram_freq <- corpus %>%
  count(video_title, bigram, sort = TRUE)

# Get the top n most frequent bigrams for each title
n <- 1
top_bigrams <- bigram_freq %>%
  group_by(video_title) %>%
  slice_max(n = n, order_by = n)


library(stm)
set.seed(123)  # Set a specific seed value for reproducibility
yt_stm <- stm(docs, vocab, K = 5,
              prevalence = ~ 1,
              data = meta,
              init.type = "Spectral")


top_words <- tidy(yt_stm, matrix = "beta") %>%
  group_by(topic) %>%
  top_n(10, beta) %>%
  ungroup() %>%
  select(topic, term, beta) %>%
  arrange(topic, -beta)

write.table(top_words, file = "yt_stm_terms.txt", sep = "\t", quote = FALSE, row.names = FALSE)


# Estimate the effect of title on each topic
yt_stm_effects <- estimateEffect(1:5 ~ 1,  # Covariate: title
                                 stmobj = yt_stm,  # STM object
                                 metadata = meta,  # Metadata
                                 uncertainty = "None")  # No uncertainty estimation

# Redirect the output to a text file
sink("yt_stm_effects.txt")

# Summarize the effects
summary(yt_stm_effects)

# Stop redirecting the output
sink()



# Create a matrix of topic scores or values
yt_gamma <- tidy(yt_stm, matrix = "gamma")

# Spread the topic scores across columns
yt_gamma <- yt_gamma %>%
  spread(key = topic, value = gamma)

# Assuming 'meta' contains the metadata of the videos and has 6958 rows
num_rows <- nrow(meta)  # Get the number of rows in the 'meta' dataframe

# Make sure the number of rows matches between 'meta' and 'yt_gamma'
if (num_rows == nrow(yt_gamma)) {
  # Combine gamma values with metadata and comments
  yt_gamma_combined <- cbind(meta, yt_gamma)
  
  # Rename columns if needed
  colnames(yt_gamma_combined) <- c("video_title", "comment_text", paste0("topic_", 1:10))
  
  # 'yt_gamma_combined' now contains the metadata, comments, and corresponding gamma values
---- else {
  print("Number of rows in 'meta' and 'yt_gamma' do not match.")
----



