

# Install and Load Packages -----------------------------------------------

# Install Packages
install.packages(c("topicmodels", "reshape2"))

# Load Packages
library(tidyverse)
library(glue)
library(textclean)
library(tidytext)
library(textrecipes)
library(tidymodels)
library(topicmodels)


# Load Data ---------------------------------------------------------------

# Load Data
df <- read_csv("data/berita-sambo.csv") %>%
  select(title) %>%
  rename(text = title)

# Load Stopword
stopword_id <- read_csv("data/stopword-id.txt", col_names = "word")


# Cleaning ----------------------------------------------------------------

# Cleaning
df_clean <- df %>%
  select(text) %>%
  mutate(text = replace_non_ascii(text)) %>%
  mutate(text = replace_hash(text, pattern = "#([A-Za-z0-9_]+)", replacement = "")) %>%
  mutate(text = replace_tag(text, pattern = "@([A-Za-z0-9_]+)", replacement = "")) %>%
  mutate(text = replace_html(text, symbol = FALSE)) %>%
  mutate(text = replace_url(text, pattern = qdapRegex::grab("rm_url"), replacement = "")) %>%
  mutate(text = replace_emoji(text)) %>%
  mutate(text = replace_emoticon(text)) %>%
  mutate(text = replace_tag(text, pattern = "\\[([A-Za-z0-9_]+)\\]", replacement = "")) %>%
  mutate(text = str_replace_all(text, pattern = regex("\\W|[:digit:]"), replacement = " ")) %>%
  mutate(text = strip(text)) 

# Topic Modeling ----------------------------------------------------------

# Unnest Token
df_text <- df_clean %>%
  rowid_to_column("id") %>%
  unnest_tokens(word, text) %>%
  anti_join(stopword_id) %>%
  group_by(id, word) %>%
  count()

# Create Document Matrix
dtm <- df_text %>%
  cast_dtm(document = id, term = word, value = n)

# Generate Topic using LDA
lda <- LDA(dtm, k = 3, method= "Gibbs", control = list(seed = 123)) 


# Function to convert LDAVIS
convert_ldavis <- function(fitted, doc_term) {
  
  require(LDAvis)
  require(slam)
  
  # Find required quantities
  phi <- as.matrix(posterior(fitted)$terms)
  theta <- as.matrix(posterior(fitted)$topics)
  vocab <- colnames(phi)
  term_freq <- slam::col_sums(doc_term)
  
  # Convert to json
  json_lda <- LDAvis::createJSON(
    phi = phi, theta = theta,
    vocab = vocab,
    doc.length = as.vector(table(doc_term$i)),
    term.frequency = term_freq
  )
  
  return(json_lda)
}

# Convert
plot_ldavis <- convert_ldavis(
  fitted = lda,
  doc_term = dtm
)

# Visualize
serVis(plot_ldavis)
