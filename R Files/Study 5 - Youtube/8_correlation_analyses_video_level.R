#Racial Population Growth
skim <- combined_data %>% skim_without_charts()
# Visualizing the sentiment -----
combined_data %>% ggplot(aes(x = pos)) + geom_density()
combined_data %>% ggplot(aes(x = neg)) + geom_density()

# Calculate correlation between variables
cor_matrix <- codes %>%
  select("source_political_alignment",
         "number_commentators", "voiceover", "commentator_gender", "commentator_political_affiliation",
         "commentator_race", "commentator_age", "positive_framing", "negative_framing", "statistics_reference", 
         "fallacies", "speaker_fear", "speaker_toxicity", "future_predictions", "future_prediction_positive", 
         "future_prediction_negative", "poc_pop_increase", 
         "latin_mention", "asian_mention", "black_mention", "multiracial_mention",
         "multiracial_prediction", "majority_minority", "diversity_positive", "diversity_negative", 
         "immigration", "commentary_racism", "commentary_exclusion", "commentary_inclusion", 
         "political_implication", "criticism", "changing_definition_race"
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
