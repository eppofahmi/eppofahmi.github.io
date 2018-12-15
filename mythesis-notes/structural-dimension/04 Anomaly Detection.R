library(AnomalyDetection)
library(tidyverse)
library(lubridate)

set.seed(2018)

raw_jod <- read_csv("twit_jod.csv", col_names = TRUE)

data_anom <- raw_jod %>%
  select(date, time) %>%
  unite(time, sep = " ")

data_anom$time <- paste(data_anom$time, "00", sep = ":")

data_anom <- data_anom %>%
  group_by(time) %>%
  count(time)
colnames(data_anom) <- c("timestamp", "count")

glimpse(data_anom)

# 2013-10-07 09:59:00
#data_anom$timestamp <- as.POSIXct(data_anom$timestamp)

data_anom$timestamp <- as.POSIXct(strptime(data_anom$timestamp, tz="UTC", "%Y-%m-%d %H:%M:%S"))

glimpse(data_anom)

res1 = AnomalyDetectionTs(data_anom, max_anoms=0.02, direction='pos', plot=TRUE, alpha = 0.05, e_value = TRUE, y_log = FALSE, na.rm = TRUE, title = NULL)

res1$plot

anomali_all = AnomalyDetectionTs(data_anom, max_anoms=0.02, direction='both', plot=TRUE, na.rm = TRUE)

anomali_all$plot


tanggal_anomali <- res1[[1]]

tanggal_anomali <- tanggal_anomali %>%
  separate(timestamp, into = c("date", "time"), sep = " ")

tanggal_anomali <- tanggal_anomali %>%
  select(date, anoms, expected_value)

write_csv(tanggal_anomali, path = "tanggal anomali.csv")
