
# Install and Load Packages -----------------------------------------------

# Install Packages
install.packages(c("tidymodels", "textrecipes", "tidytext"))

# Load Packages
library(tidyverse)
library(tidymodels)
library(textrecipes)
library(tidytext)
library(glue)

# Load Data and Model -----------------------------------------------------

# Load Data
df <- read_csv("data/berita-sambo.csv") %>%
  select(title) %>%
  rename(text = title)
  
# Load Model
general_sentiment <- read_rds("model/general-sentiment-ann.rds")

# Predict Sentiment -------------------------------------------------------

# Probability
prob <- general_sentiment %>%
  predict(df, type = "prob")

# Predict Sentiment Class
class <- general_sentiment %>%
  predict(df, type = "class")

# Hasil Sentiment
hasil_sentiment <- df %>%
  bind_cols(prob) %>%
  bind_cols(class) %>%
  rename(sentiment = .pred_class)

# Visualize ---------------------------------------------------------------

# Visualize
plot_sentiment <- hasil_sentiment %>%
  group_by(sentiment) %>%
  count() %>%
  mutate(x = 3) %>%
  mutate(percentage = glue("{round(n/nrow(hasil_sentiment) * 100)}%")) %>%
  ggplot(aes(x = x, y = n, fill = sentiment)) +
  geom_col(alpha = 1) +
  geom_text(aes(label = percentage),
            position = position_stack(vjust = 0.5),
            family = "Segoe UI", 
            color = "white") +
  scale_fill_manual(values = c("#4285F4", "#34A853",  "#EA4335")) +
  theme_void() +
  labs(
    x = "",
    y = "",
    fill = "Sentiment"
  ) +
  theme(
    legend.position = "bottom",
    text = element_text(family = "Segoe UI")
  ) +
  coord_polar(theta = "y") +
  xlim(c(0.9, 3 + 0.6))
plot_sentiment
