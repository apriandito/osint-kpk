# Load Packages
library(rvest)
library(tidyverse)

# Set URL
url <- read_html("https://www.imdb.com/search/title/?title_type=feature&primary_language=id&sort=year,asc&start=1")

# Mendapatkan elemen html yang mengandung semua informasi film
informasi_film <- url %>%
  html_elements(".mode-advanced")

# Mendapatkan Judul Film
judul_film <- informasi_film %>%
  html_element(".lister-item-header a") %>%
  html_text()

# Mendapatkan Tahun Rilis
tahun_rilis <- informasi_film %>%
  html_element(".text-muted.unbold") %>%
  html_text()

# Mendapatkan Sutradara Film
sutradara <- informasi_film %>%
  html_element(".text-muted+ p a:nth-child(1)") %>%
  html_text()

# Buat sebagai sebuah data frame
film_indonesia <- tibble(
  judul_film = judul_film,
  tahun_rilis = tahun_rilis,
  sutradara = sutradara
)
