#Black Business Support Regression Lines 
# All Topics (descending order)
summary(lm(topic_6 ~ view_count + subscribers + likes + like_count + as.factor(events_historical_mention), data = datagamma_combined))
summary (lm(topic_5 ~ view_count + subscribers + likes + like_count + as.factor(political_affiliation_commentator), data = datagamma_combined))
summary (lm(topic_4 ~ view_count + subscribers + likes + like_count + as.factor(racial_equality_colorblindness), data = datagamma_combined))
summary (lm(topic_3 ~ view_count + subscribers + likes + like_count + as.factor(events_recent_mention), data = datagamma_combined))
summary (lm(topic_2 ~ view_count + subscribers + likes + like_count + as.factor(), data = datagamma_combined))
summary (lm(topic_1 ~ view_count + subscribers + likes + like_count + as.factor(), data = datagamma_combined))


# Topic 3: black, people, man, get, see, good, need, much, take, want 
summary (lm(topic_3 ~ view_count + subscribers + likes + like_count + as.factor(events_historical_mention), data = datagamma_combined))
summary (lm(topic_3 ~ view_count + subscribers + likes + like_count + as.factor(racial_groups_mention), data = datagamma_combined))
summary (lm(topic_3 ~ view_count + subscribers + likes + like_count + as.factor(emotional_sadness_commentator), data = datagamma_combined))
summary (lm(topic_3 ~ view_count + subscribers + likes + like_count + as.factor(emotional_anger_commentator), data = datagamma_combined))
summary (lm(topic_3 ~ view_count + subscribers + likes + like_count + as.factor(racial_stereotypes_use), data = datagamma_combined))
summary (lm(topic_3 ~ view_count + subscribers + likes + like_count + as.factor(social_issues_mention), data = datagamma_combined))
summary (lm(topic_3 ~ view_count + subscribers + likes + like_count + as.factor(racial_equality), data = datagamma_combined))
summary (lm(topic_3 ~ view_count + subscribers + likes + like_count + as.factor(racial_equality_colorblindness), data = datagamma_combined))
summary (lm(topic_3 ~ view_count + subscribers + likes + like_count + as.factor(awareness_discrimination_present), data = datagamma_combined))

# Topic 6: white, can, because, make, one, think, race, racist, american, never
summary(lm(topic_6 ~ view_count + subscribers + likes + like_count + as.factor(events_recent_mention), data = datagamma_combined))
summary(lm(topic_6 ~ view_count + subscribers + likes + like_count + as.factor(awareness_discrimination_present), data = datagamma_combined))
summary(lm(topic_6 ~ view_count + subscribers + likes + like_count + as.factor(events_historical_mention), data = datagamma_combined))
summary(lm(topic_6 ~ view_count + subscribers + likes + like_count + as.factor(racial_stereotypes_use), data = datagamma_combined))

# Topic 5: video, love, trump, song, great, president, real, now, watch, vote 
summary(lm(topic_5 ~ view_count + subscribers + likes + like_count + as.factor(racial_stereotypes_use), data = datagamma_combined))
summary(lm(topic_6 ~ view_count + subscribers + likes + like_count + as.factor(emotional_anger_commentator), data = datagamma_combined))

datagamma_combined %>% ggplot(aes(x = topic_6)) + geom_density()

# Skim code 
skim <- datagamma_combined %>% skim_without_charts()

