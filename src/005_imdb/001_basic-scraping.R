
# Install and Load Packages -----------------------------------------------

# Install Packages
install.packages("rvest")

# Load Packages
library(rvest)
library(tidyverse)

# Set Url -----------------------------------------------------------------

# Set URL
url <- read_html("https://www.imdb.com/search/title/?title_type=feature&primary_language=id&sort=year,asc&start=1")
url

# Find Item ---------------------------------------------------------------

# Mendapatkan Judul Film
judul_film <- url %>%
  html_elements(".lister-item-header a") %>%
  html_text()

# Mendapatkan Tahun Rilis
tahun_rilis <- url %>%
  html_elements(".text-muted.unbold") %>%
  html_text()

# Mendapatkan daftar sutradara
sutradara <- url %>%
  html_elements(".text-muted+ p a:nth-child(1)") %>%
  html_text()

# Make it as Dataframe ----------------------------------------------------

# Buat sebagai sebuah data frame (Eror karena ada informasi sutradara yang kosong)
film_indonesia <- tibble(
  judul_film = judul_film,
  tahun_rilis = tahun_rilis,
  sutradara = sutradara
)

# Silahkan lanjut ke 002_fix-missing-data-problem.R