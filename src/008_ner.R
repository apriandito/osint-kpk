
# Install and Load Packages -----------------------------------------------

# Install Packages
install.packages(c("NLP", "openNLP", "ggmap", "rworldmap"))
install.packages("openNLPmodels.en", dependencies=TRUE, repos = "http://datacube.wu.ac.at/")

# Load Packages
library(tidyverse)
library(rvest)
library(NLP)
library(openNLP)
library(ggmap)
library(rworldmap)

# Scrape Data from Wikipedia ----------------------------------------------

# Read URL
url = read_html('https://en.wikipedia.org/wiki/Panama_Papers') 

# Get Content
text <- url %>%
  html_elements("p") %>%
  html_text() %>%
  str_remove_all(regex("\\[[0-9]]|\\[[0-9][0-9]]|\\[[0-9][0-9][0-9]]|\\n")) %>%
  str_c(collapse = " ") %>%
  as.String()

# NER ---------------------------------------------------------------------

# Set Anotator
sent_annot = Maxent_Sent_Token_Annotator()
word_annot = Maxent_Word_Token_Annotator()
loc_annot = Maxent_Entity_Annotator(kind = "location")
people_annot = Maxent_Entity_Annotator(kind = "person")

# List Annotation
list_annotation = NLP::annotate(text, list(sent_annot,word_annot,loc_annot, people_annot))
k <- sapply(list_annotation$features, `[[`, "kind")

# Get list of location
locations_list = text[list_annotation[k == "location"]] %>%
  unique()
locations_list

# Get list of people
people_list = text[list_annotation[k == "person"]] %>%
  unique()
people_list
