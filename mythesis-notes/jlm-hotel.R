# visualisasi perkembangan hotel di DIY
# data diambil dari directory hotel 2008 - 2016 bps

# jumlah hotel ---------------
jml_hotel <- read.csv("jumlah hotel yk.csv", stringsAsFactors = FALSE, header = TRUE, sep = ";")

library(ggplot2)
library(dplyr)

jml_hotel %>%
  ggplot(aes(x=tahun, y=jumlah, colour=daerah)) +
  geom_line(show.legend = TRUE) +
  facet_grid(kategori~., scales="free") +
  theme(legend.position="top") +
  labs(title = NULL, x = NULL, y = "Jumlah")

jml_hotel %>%
  group_by(daerah) %>%
  select(jumlah) %>%
  summarize(total = sum(jumlah)) %>%
  arrange(desc(total))

sum(jml_hotel$jumlah)

jml_hotel %>%
  filter(daerah == "Kota") %>%
  group_by(kategori) %>%
  select(jumlah) %>%
  summarize(total = sum(jumlah)) %>%
  arrange(desc(total))

  
# rerata twit berdasarkan bulan --------------

twit_month <- read.csv("partisipasi_jod.csv", 
                       stringsAsFactors = FALSE, header = TRUE)