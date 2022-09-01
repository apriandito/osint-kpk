# Load Packages
library(rvest)
library(tidyverse)
library(glue)

# Generate url
daftar_url <- glue("https://www.imdb.com/search/title/?title_type=feature&primary_language=id&sort=year,asc&start={seq(from = 1, to = 200, by = 50)}")

# Membuat Fungsi untuk mengambil informasi film
scrape_informasi_film <- function(x) {
  
  # Read url
  url <- read_html(x)
  
  # Mendapatkan elemen html yang mengandung semua informasi film
  informasi_film <- url %>%
    html_elements(".mode-advanced")
  
  # Mendapatkan judul film
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
  df_film <- tibble(
    judul_film = judul_film,
    tahun_rilis = tahun_rilis,
    sutradara = sutradara
  )
  
  # Return
  return(df_film)
}

# Scrape data film indonesia
film_indonesia <- map_dfr(daftar_url, scrape_informasi_film)

# Finalisasi di 004_finalize.R