# Buying Black 
# Loading Packages ----
library(readr)
library(dplyr)
library(here) # this specifies path /Users/lrdsgeraldo/Documents/Buying-Black/Buying Black and Moral Affirmation
library(DataExplorer)
library(tidyr) # This is useful for loading csv files into r
library(readxl)
library(stringr)

# Loading in Data ----
wf_dt_r <- readxl::read_excel(here("Data/yelp_academic_dataset_review.xlsm")) 
wf_dt_b <- readr::read_csv(here("Data/yelp_academic_dataset_business.csv")) 
wf_dt_u <- readr::read_csv(here("Data/yelp_academic_dataset_user.csv")) 
wf_dt_t <- readr::read_csv(here("Data/yelp_academic_dataset_tip.csv")) 

# Defined Search Phrases in Reviews ----
# Define a vector of phrases to search for
phrases <- c(
  "black[- ]owned",
  "african american[- ]owned",
  "black entrepreneur",
  "black business",
  "minority[- ]owned",
  "black proprietor",
  "black founder",
  "black[- ]led"
)
# Filtered Black_Owned in Reviews ----
# Create a single regex pattern that matches any of the phrases
pattern <- paste(phrases, collapse = "|")

# Filter reviews that mention any of the specified phrases
black_owned_reviews <- wf_dt_r %>%
  filter(str_detect(text, regex(pattern, ignore_case = TRUE)))

# Remove rows with NA in business_id column in black_owned_reviews
black_owned_reviews <- black_owned_reviews %>%
  drop_na(business_id)

# Group by business_id and count unique business IDs
unique_business_ids <- black_owned_reviews %>%
  group_by(business_id) %>%
  summarise(count = n())

# Filter the original dataset wf_dt_r based on these unique business IDs and remove rows with NA in business_id column
filtered_wf_dt_r <- wf_dt_r %>%
  filter(business_id %in% unique_business_ids$business_id)

write.csv(unique_business_ids, file = here("Data/unique_business_ids.csv"))

# Join Reviews Dataset with Coded Label Data ----
# Load the coded data from Excel
coded_data <- read_excel(here("Data/unique_business_ids_labels.xlsx"))

# Perform the join on the common column 'business_id'
combined_data <- filtered_wf_dt_r %>%
  left_join(coded_data, by = "business_id")  %>% 
  left_join(wf_dt_b, by = "business_id")  %>%
  left_join(wf_dt_u, by = "business_id") 



save(file = here("Data/"))

