# Load Packages
library(rvest)
library(tidyverse)
library(glue)
library(stringr)

# Generate url
daftar_url <- glue("https://www.bukalapak.com/products?page={seq(from = 1, to = 5, by = 1)}&search%5Bkeywords%5D=oxymeter")
daftar_url

# Membuat Fungsi untuk mengambil informasi produk di bukalapak
scrape_informasi_produk <- function(x) {

  # Read url
  url <- read_html(x)

  # Mendapatkan elemen html yang mengandung semua informasi produk
  informasi_produk <- url %>%
    html_elements(".bl-product-card__description")

  # Mendapatkan nama produk
  nama_produk <- informasi_produk %>%
    html_element(".bl-text--ellipsis__2 .bl-link") %>%
    html_text() %>%
    str_replace_all("\n            ", "")

  # Mendapatkan link produk
  link_produk <- informasi_produk %>%
    html_element(".bl-text--ellipsis__2 .bl-link") %>%
    html_attr("href")

  # Mendapatkan harga produk
  harga <- informasi_produk %>%
    html_element(".bl-text--semi-bold.bl-text--ellipsis__1") %>%
    html_text() %>%
    str_remove_all("[:alpha:]") %>%
    str_remove_all("[:punct:]") %>%
    as.numeric()

  # Mendapatkan jumlah terjual
  jumlah_terjual <- informasi_produk %>%
    html_element(".bl-product-card__separator+ .bl-text--subdued") %>%
    html_text() %>%
    str_remove_all("[:alpha:]") %>%
    str_remove_all("[:punct:]") %>%
    as.numeric()

  # Mendapatkan Nama Toko
  toko <- informasi_produk %>%
    html_element(".bl-text--ellipsis__1 .bl-link") %>%
    html_text()

  # Mendapat jumlah rating
  rating <- informasi_produk %>%
    html_element(".bl-product-card__description-rating .bl-text--subdued , .bl-text--ellipsis__1 .bl-link") %>%
    html_text() %>%
    as.numeric()

  # Buat sebagai sebuah data frame
  df_produk <- tibble(
    nama_produk = nama_produk,
    link_produk = link_produk,
    harga = harga,
    jumlah_terjual = jumlah_terjual,
    toko = toko,
    rating = rating
  )

  # Return
  return(df_produk)
}

# Scrape data produk
df_produk <- map_dfr(daftar_url, scrape_informasi_produk) %>%
  mutate(jumlah_terjual = replace_na(jumlah_terjual, 0)) %>%
  mutate(rating = replace_na(rating, 0))

# Simpan data Sebagai CSV
write_csv(df_produk, "data/produk-oxymeter-bukalapak.csv")
