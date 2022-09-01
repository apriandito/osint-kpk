# Load Packages
library(rvest)
library(tidyverse)
library(glue)
library(stringr)

# Generate url
daftar_url <- glue("https://www.imdb.com/search/title/?title_type=feature&primary_language=id&sort=year,asc&start={seq(from = 1, to = 2299, by = 50)}")

# Membuat fungsi untuk mengambil informasi film
scrape_informasi_film <- function(x) {
  
  # Read url
  url <- read_html(x)
  
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
    html_text() %>%
    str_remove_all("[:alpha:]") %>%
    str_remove_all("[:punct:]") %>%
    as.integer()
  
  # Mendapatkan Sutradara Film
  sutradara <- informasi_film %>%
    html_element(".text-muted+ p a:nth-child(1)") %>%
    html_text() %>%
    str_replace_all("Add a Plot", "")
  
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

# Simpan data Sebagai CSV
write_csv(film_indonesia, "data/film_indonesia_lengkap.csv")