
# Install and Load Packages -----------------------------------------------

# Load Packages
library(rtweet)
library(tidyverse)

# Set Auth. and Parameter -------------------------------------------------

# Set Token (Dari Halaman Twiiter API)
token <- create_token(
  app = "___",
  consumer_key = "___",
  consumer_secret = "___",
  access_token = "___",
  access_secret = "___"
)

# Tentukan Nama Akun (Tidak perlu menggunakan @), Jumlah Tweet, dan Parameter Lainnya
akun <- "KPK_RI"
jumlahtweet <- 100
retweet <- FALSE

# Collecting Tweet --------------------------------------------------------

# Proses Pengumpulan Data Tweet
tweet_timeline <- get_timelines(akun,
  n = jumlahtweet,
  home = retweet
)

# Save Tweet --------------------------------------------------------------

# Simpan Data Tweet dalam format .csv
write_as_csv(tweet_timeline,
  file = "data/tweet-timeline.csv"
)

# Simpan Data Tweet dalam format .rds
write_rds(tweet_timeline,
  file = "data/tweet-timeline.rds"
)
