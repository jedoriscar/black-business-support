# Buying Black and Moral Affirmation Experiment S1 -----
# Initial Setup
# Loading Packages ----
library(ggpubr)
library(psych)
library(tidyverse)
library(dplyr)
library(readr)
library(corrplot)
library(readxl)
library(ggplot2)
library(effectsize)
library(lsr)
library(interactions)
library("emmeans")
library(here)
options(scipen = 100)

# Loading Data ----
wf_dt <- read_csv(file = here("Data/wf_maS1.csv"))

# Attention Check Data Cleaning ----
# No Bias Condition Attention Check (4 = correct option)
wf_dt$attentioncheck_nb <- as.numeric(wf_dt$attentioncheck_nb)
is.numeric(wf_dt$attentioncheck_nb)
which(wf_dt$attentioncheck_nb == "1", arr.ind = TRUE) 
which(wf_dt$attentioncheck_nb == "2", arr.ind = TRUE)
which(wf_dt$attentioncheck_nb == "3", arr.ind = TRUE)
which(wf_dt$attentioncheck_nb == "5", arr.ind = TRUE)
which(wf_dt$attentioncheck_nb == "6", arr.ind = TRUE)
which(wf_dt$attentioncheck_nb == "7", arr.ind = TRUE)

# Bias Condition Attention Check (1 = correct option) 
wf_dt$attentioncheck_b <- as.numeric(wf_dt$attentioncheck_b)
is.numeric(wf_dt$attentioncheck_b)
which(wf_dt$attentioncheck_b == "4", arr.ind = TRUE) 
which(wf_dt$attentioncheck_b == "2", arr.ind = TRUE)
which(wf_dt$attentioncheck_b == "3", arr.ind = TRUE)
which(wf_dt$attentioncheck_b == "5", arr.ind = TRUE)
which(wf_dt$attentioncheck_b == "6", arr.ind = TRUE)
which(wf_dt$attentioncheck_b == "7", arr.ind = TRUE)

# Filtering out those who failed the attention check in both conditions (49 participants)
wf_dt2 <- wf_dt[-c(21, 167, 192, 325,
                   77, 115, 208, 240, 247, 249,
                   36, 116, 179, 212, 277, 283, 310, 318, 319,
                   61, 81, 88, 301, 315, 323,
                   82,
                   254, 33, 59, 71, 121, 156, 207, 227, 243,
                   2, 26, 69, 134, 200, 201, 251, 261, 272,
                   78, 89, 118, 220,
                   15
),]

# Creating Condition Variables -----
# Combining Participants Embedded Data from their Assigned Conditions
wf_dt2 <- wf_dt2 %>%
  mutate(
    condition = rowSums(select(., nobias_white, nobias_black, 
                               bias_white, bias_black), na.rm = TRUE)
  )
as.factor(wf_dt2$condition)


