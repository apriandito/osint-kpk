# Install Packages
install.packages("rvest")

# Load Packages
library(rvest)
library(tidyverse)

# Set URL
url <- read_html("https://www.bukalapak.com/products?page=1&search%5Bkeywords%5D=oxymeter")
url

# Mendapatkan nama produk
nama_produk <- url %>%
  html_elements(".bl-text--ellipsis__2 .bl-link") %>%
  html_text()

# Mendapatkan link produk
link_produk <- url %>%
  html_elements(".bl-text--ellipsis__2 .bl-link") %>%
  html_attr("href")

# Mendapatkan harga produk
harga <- url %>%
  html_elements(".bl-text--semi-bold.bl-text--ellipsis__1") %>%
  html_text()

# Mendapatkan jumlah terjual
jumlah_terjual <- url %>%
  html_elements(".bl-product-card__separator+ .bl-text--subdued") %>%
  html_text()

# Mendapatkan Nama Toko
toko <- url %>%
  html_elements(".bl-text--ellipsis__1 .bl-link") %>%
  html_text()

# Mendapat jumlah rating
rating <- url %>%
  html_elements(".bl-product-card__description-rating .bl-text--subdued , .bl-text--ellipsis__1 .bl-link") %>%
  html_text()

# Buat sebagai sebuah data frame (Eror karena ada informasi sutradara yang kosong)
df_produk <- tibble(
  nama_produk = nama_produk,
  link_produk = link_produk,
  harga = harga,
  jumlah_terjual = jumlah_terjual,
  toko = toko,
  rating = rating
)

# Silahkan lanjut ke 002_fix-missing-data-problem.R
