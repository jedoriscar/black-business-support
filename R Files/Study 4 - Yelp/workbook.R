# Loading Packages + Parallel Cores ----
library(doMC)
library(readr)
library(dplyr)
library(here) # this specifies path /Users/lrdsgeraldo/Documents/Buying-Black/Buying Black and Moral Affirmation
library(DataExplorer)
library(tidyr) # This is useful for loading csv files into r
library(readxl)
library(stringr)

num_cores <- parallel::detectCores(logical = TRUE)
registerDoMC(cores = num_cores)

# Loading in Data ----
wf_dt_t <- readr::read_csv(here("Data/yelp_academic_dataset_tip.csv")) 



# Loading packages ----
Workbook: top_words <- tidy(datastm, matrix = "beta") %>%
  group_by(topic) %>%
  top_n(10, beta) %>%
  ungroup() %>%
  select(topic, term, beta) %>%
  arrange(topic, -beta)

write.table(top_words, file = "datastm_terms.txt", sep = "\t", quote = FALSE, row.names = FALSE)


# Estimate the effect of title on each topic
datastm_effects <- estimateEffect(1:5 ~ 1,  # Covariate: title
                                  stmobj = datastm,  # STM object
                                  metadata = meta,  # Metadata
                                  uncertainty = "None")  # No uncertainty estimation

# Redirect the output to a text file
sink("datastm_effects.txt")

# Summarize the effects
summary(datastm_effects)

# Stop redirecting the output
sink()



# Create a matrix of topic scores or values
datagamma <- tidy(datastm, matrix = "gamma")

# Spread the topic scores across columns
datagamma <- datagamma %>%
  spread(key = topic, value = gamma)

# Assuming 'meta' contains the metadata of the videos and has 6958 rows
num_rows <- nrow(meta)  # Get the number of rows in the 'meta' dataframe

# Make sure the number of rows matches between 'meta' and 'datagamma'
if (num_rows == nrow(datagamma)) {
  # Combine gamma values with metadata and comments
  datagamma_combined <- cbind(meta, datagamma)
  
  # Rename columns if needed
  colnames(datagamma_combined) <- c("video_title", "comment_text", paste0("topic_", 1:10))
  
  # 'datagamma_combined' now contains the metadata, comments, and corresponding gamma values
} else {
  print("Number of rows in 'meta' and 'datagamma' do not match.")
}