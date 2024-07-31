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
wf_dt_r <- readxl::read_excel(here("Data/yelp_academic_dataset_review.xlsm")) 
wf_dt_b <- readxl::read_excel(here("Data/yelp_academic_dataset_business.xlsx")) 
wf_dt_u <- readr::read_csv(here("Data/yelp_academic_dataset_user.csv")) 
wf_dt_t <- readr::read_csv(here("Data/yelp_academic_dataset_tip.csv")) 

