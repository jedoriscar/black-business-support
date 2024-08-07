#Racial Population Growth
# Load Data ---
load(here("Data/datagamma_combined.rda"))

skim <- datagamma_combined %>% skim_without_charts()
# Visualizing the sentiment -----
datagamma_combined %>% ggplot(aes(x = topic_4)) + geom_density()
datagamma_combined %>% ggplot(aes(x = neg)) + geom_density()

#Filter politics
datagamma_combined <- datagamma_combined[datagamma_combined$political_affiliation_commentator %in% c(0, 1), ]

# Calculate correlation between variables
cor_matrix <- combined_data %>%
  select("like_count", "view_count", 
         "subscribers", "likes",
         "replies",
         "comment_count",  "comment_type",
         "duration",
         "commentary", "narration_presence", "political_affiliation_commentator", "emotional_sadness_commentator",
         "emotional_anger_commentator", "written_comments_presence", "media_news",
         "media_business", "media_influencers", "events_recent_mention", "events_historical_mention",
         "events_rec_policy_mention", "racial_stereotypes_use","racial_groups_mention",
         "expert_opinion_use", "statistics_presence", "call_action_discrimination", "social_issues_mention",
         "racial_equality", "racial_equality_colorblindness", "awareness_discrimination_present", 
         "topic_1", "topic_2", "topic_3", "topic_4",
         "topic_5", "topic_6", "neg", "pos", "neu", "but_count"
  ) %>%
  cor(use = "pairwise.complete.obs")

# heat map
# Create a function to calculate p-values
get_p_value <- function(x, y) {
  cor_test <- cor.test(x, y, method = "pearson")
  return(cor_test$p.value)
}

# Calculate p-values for the correlations
p_values <- outer(colnames(cor_matrix), colnames(cor_matrix), 
                  Vectorize(function(x, y) get_p_value(cor_matrix[, x], cor_matrix[, y])))

# Create a dataframe for the correlation values and p-values
corr_data <- data.frame(variables = rep(colnames(cor_matrix), each = ncol(cor_matrix)),
                        others = rep(colnames(cor_matrix), ncol(cor_matrix)),
                        corr_values = as.vector(cor_matrix),
                        p_value = as.vector(p_values))

# Create a function to add asterisks based on p-values
add_asterisk <- function(p_value) {
  if (p_value < 0.05) {
    return("*")
  } else {
    return("")
  }
}

# Apply the function to generate the asterisk labels
corr_data$asterisks <- sapply(corr_data$p_value, add_asterisk)

# Create a heatmap for the correlation matrix with labels and significance asterisks
heatmap_plot <- ggplot(data = corr_data, aes(x = variables, y = others, fill = corr_values)) +
  geom_tile() +
  geom_text(aes(label = sprintf("%.2f", corr_values)), color = "black", size = 3) +  # Display correlation values as labels
  geom_text(aes(label = asterisks), color = "red", size = 5) +  # Display significance asterisks
  scale_fill_gradient2(low = "blue", mid = "white", high = "red", 
                       midpoint = 0, limits = c(-1, 1)) +
  labs(title = "Correlation Heatmap",
       x = "Variables",
       y = "Other Variables") +
  theme_minimal() +
  theme(axis.text.x = element_text(angle = 45, hjust = 1))

# Display the heatmap
print(heatmap_plot)
