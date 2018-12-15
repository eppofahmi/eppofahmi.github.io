
# library ----

library(tidyverse)
library(tidytext)
library(stringr)
library(ggplot2)
library(skimr)

# data ----
raw_jod <- read_csv("twit_jod.csv", col_names = TRUE)

raw_jod$user <- gsub("\\bJogjaOraDid0l\\b", "JogjaOraDidol", raw_jod$user)

glimpse(raw_jod)

# moratorium ----
moratorium <- raw_jod %>%
  filter(is_duplicate == FALSE) %>%
  filter(str_detect(tweets, "moratorium")) %>%
  select(tweets, date, user) %>%
  print()

head(moratorium$tweets, n=10)

# belakang hotel ----
belakang_hotel <- raw_jod %>%
  filter(is_duplicate == FALSE) %>%
  filter(str_detect(tweets, "belakang")) %>%
  select(tweets, date, user) %>%
  print()

head(belakang_hotel, n=16)

# baliho ---- 
baliho <- raw_jod %>%
  filter(is_duplicate == FALSE) %>%
  filter(str_detect(tweets, "baliho")) %>%
  select(tweets, date, user) %>%
  print()

print(baliho$tweets)

# akun pengirim ----
user_pengirim <- raw_jod %>%
  select(user) %>%
  count(user, sort = TRUE)

user_pengirim %>%
  head(n = 10) %>%
  ggplot(aes(x = reorder(user, n), y = n)) + 
  geom_col() + coord_flip() + 
  labs( x  = "Nama Akun", y = "Jumlah twit yang dikirim")

# user terlibat ----
user_per_periode <- raw_jod %>%
  select(periode, user_all, user_count)

user_per_periode$user_all <- gsub("\\b@JogjaOraDidol\\b", "JogjaOraDidol", 
                                  user_per_periode$user_all)
user_per_periode$user_all <- gsub("\\b@JogjaUpdate\\b", "JogjaUpdate", 
                                  user_per_periode$user_all)
user_per_periode$user_all <- gsub("\\bJogjaUpdateCom\\b", "JogjaUpdate", 
                                  user_per_periode$user_all)
user_per_periode$user_all <- gsub("\\bJogjaUpdet\\b", "JogjaUpdate", 
                                  user_per_periode$user_all)
user_per_periode$user_all <- gsub("\\bjogjaupdate\\b", "JogjaUpdate", 
                                  user_per_periode$user_all)
user_per_periode$user_all <- gsub("\\bJogjaOraDiDol\\b", "JogjaOraDidol", 
                                  user_per_periode$user_all)
user_per_periode$user_all <- gsub("\\bJogjaOraDiDol\\b", "JogjaOraDidol", 
                                  user_per_periode$user_all)
user_per_periode$user_all <- gsub("\\bJogjaOraDidOl\\b", "JogjaOraDidol", 
                                  user_per_periode$user_all)
user_per_periode$user_all <- gsub("\\bJogjaOraDidl\\b", "JogjaOraDidol", 
                                  user_per_periode$user_all)
user_per_periode$user_all <- gsub("\\bJogjaOraDidollantang\\b", "JogjaOraDidol", 
                                  user_per_periode$user_all)
user_per_periode$user_all <- gsub("\\bjogjaoradidol\\b", "JogjaOraDidol", 
                                  user_per_periode$user_all)
user_per_periode$user_all <- gsub("\\bdodoputrabangsaTHR\\b", "dodoputrabangsa", 
                                  user_per_periode$user_all)
user_per_periode$user_all <- gsub("\\bjoeyakartahttpstwittercomtemponewsroomstatus\\b", "joeyakarta", user_per_periode$user_all)
user_per_periode$user_all <- gsub("\\bjoeyakartahotel\\b", "joeyakarta", user_per_periode$user_all)
user_per_periode$user_all <- gsub("\\bJRX_SID@w\\b", "JRX_SID", user_per_periode$user_all)
user_per_periode$user_all <- gsub("\\bJRX_SIDMalam\\b", "JRX_SID", user_per_periode$user_all)
user_per_periode$user_all <- gsub("Jrx_SID", "JRX_SID", user_per_periode$user_all)
user_per_periode$user_all <- gsub("\\bJRX_SIDhttpyoutubeOLdcLreA\\b", "JRX_SID", user_per_periode$user_all)
user_per_periode$user_all <- gsub("\\bJrx_sid\\b", "JRX_SID", user_per_periode$user_all)
user_per_periode$user_all <- gsub("\\bjrx_sid\\b", "JRX_SID", user_per_periode$user_all)
user_per_periode$user_all <- gsub("\\bjrx\\b", "JRX_SID", user_per_periode$user_all)
user_per_periode$user_all <- gsub("\\bjrxsid\\b", "JRX_SID", user_per_periode$user_all)
user_per_periode$user_all <- gsub("\\bJogjaUpdateCom\\b", "JogjaUpdate", user_per_periode$user_all)


# normalisasi killthedj ---- 
user_per_periode$user_all <- gsub("\\bkillthedjs\\b", "killthedj", user_per_periode$user_all)
user_per_periode$user_all <- gsub("\\bkillthedjs\\b", "killthedj", user_per_periode$user_all)
user_per_periode$user_all <- gsub("\\bkilltheDJ\\b", "killthedj", user_per_periode$user_all)

user_per_periode$user_all <- gsub("\\bKillTheDJ\\b", "killthedj", user_per_periode$user_all)
user_per_periode$user_all <- gsub("\\bKillTheDj\\b", "killthedj", user_per_periode$user_all)
user_per_periode$user_all <- gsub("\\bkillthedjanteknya\\b", "killthedj", user_per_periode$user_all)
user_per_periode$user_all <- gsub("\\bkillthedjmengkritisi\\b", "killthedj", user_per_periode$user_all)
user_per_periode$user_all <- gsub("\\bkillthedj's\\b", "killthedj", user_per_periode$user_all)

# normalisasi jhfcrew ---- 
user_per_periode$user_all <- gsub("\\bJHFCrew\\b", "JHFcrew", user_per_periode$user_all)
user_per_periode$user_all <- gsub("\\bjhf_crew\\b", "JHFcrew", user_per_periode$user_all)
user_per_periode$user_all <- gsub("\\bjhfcrew\\b", "JHFcrew", user_per_periode$user_all)
user_per_periode$user_all <- gsub("\\bJhfcrew\\b", "JHFcrew", user_per_periode$user_all)
user_per_periode$user_all <- gsub("\\bRembugJogja\\b", "rembugjogja", user_per_periode$user_all)
user_per_periode$user_all <- gsub("\\bJRX_SIDsid\\b", "JRX_SID", user_per_periode$user_all)
user_per_periode$user_all <- gsub("\\bIkhwanxJRX_SID\\b", "Ikhwanx, JRX_SID", user_per_periode$user_all)
user_per_periode$user_all <- gsub("\\bsid_official\\b", "SID_Official", user_per_periode$user_all)
user_per_periode$user_all <- gsub("\\bSID_official\\b", "SID_Official", user_per_periode$user_all)
user_per_periode$user_all <- gsub("\\bSid_official\\b", "SID_Official", user_per_periode$user_all)

user_per_periode$user_all <- gsub("\\bJhfcrew\\b", "JHFcrew", user_per_periode$user_all)
user_per_periode$user_all <- gsub("\\bjhfcrew\\b", "JHFcrew", user_per_periode$user_all)
user_per_periode$user_all <- gsub("\\bJhfcrew\\b", "JHFcrew", user_per_periode$user_all)

user_per_periode$user_all <- gsub("\\bjogja24jam\\b", "Jogja24Jam", user_per_periode$user_all)
user_per_periode$user_all <- gsub("\\binfojogjakarta\\b", "infojogja", user_per_periode$user_all)

user_per_periode$user_all <- gsub("\\bMetro_Tv\\b", "Metro_TV", user_per_periode$user_all)
user_per_periode$user_all <- gsub("\\bmetro_tv\\b", "Metro_TV", user_per_periode$user_all)

user_per_periode$user_all <- gsub("\\bkompasTV\\b", "KompasTV", user_per_periode$user_all)
user_per_periode$user_all <- gsub("\\bKompasTv\\b", "KompasTV", user_per_periode$user_all)
user_per_periode$user_all <- gsub("\\bkompastv\\b", "KompasTV", user_per_periode$user_all)
user_per_periode$user_all <- gsub("\\bmatanajwa\\b", "MataNajwa", user_per_periode$user_all)
user_per_periode$user_all <- gsub("\\bJogjaOraDid0l\\b", "JogjaOraDidol", user_per_periode$user_all)


write_csv(user_per_periode, path = "wrangled jod/user_jod.csv")

# user all count ----
unnest_reg <- "([^A-Za-z_\\d#@']|'(?![A-Za-z_\\d#@]))"
jumlah_pengguna <- user_per_periode %>%
  group_by(periode) %>%
  unnest_tokens(user, user_all, token = "regex", pattern = unnest_reg,
                to_lower = FALSE) %>%
  count(user, sort = TRUE)

jumlah_pengguna$user <- paste("@", jumlah_pengguna$user, sep="")

write_csv(jumlah_pengguna, "daftar_username.csv")

# visualisasi jumlah pengguna ----
jumlah_pengguna %>%
  select(periode, user) %>%
  count(user) %>%
  group_by(periode) %>%
  summarize(total = sum(n)) %>%
  ggplot(aes(periode, total)) + geom_col() + 
  labs(x = NULL, y = "Jumlah akun twitter")

jumlah_pengguna %>%
  select(periode, user) %>%
  count(user) %>%
  group_by(periode) %>%
  summarize(total = sum(n)) %>%
  print()

# jumlah pengguna periode 1 = 3310
# jumlah pengguna periode 2 = 2304
# jumlah pengguna periode 3 = 2175
# jumlah pengguna periode 4 = 718

raw_jod %>%
  filter(periode == "4_Decline") %>%
  select(date) %>%
  skim(date)

# visualisasi top 10 pengguna ----
jumlah_pengguna %>%
  group_by(periode) %>%
  top_n(10, n) %>%
  ggplot(aes(reorder(user, n), n, fill = periode)) +
  geom_col(show.legend = FALSE) +
  facet_wrap(~ periode, scales = "free", ncol = 2) +
  coord_flip() +
  labs(x = NULL, 
       y = "Frekuensi dalam twit")

# akun jogjaoradidol ----
akun_jod <- raw_jod %>%
  filter(periode == "1_Emergence") %>%
  select(date, user, tweets) %>%
  filter(user == "JogjaOraDidol")

# akun rembugjogja ----
akun_rembugjogja <- raw_jod %>%
  filter(periode == "2_Coalescence") %>%
  select(date, user, tweets) %>%
  filter(user == "rembugjogja")

# akun dodo ----
akun_dodo <- raw_jod %>%
  filter(periode == "3_Bureaucratization") %>%
  select(date, user, tweets) %>%
  filter(user == "dodoputrabangsa")

# akun dodo ----
akun_joey <- raw_jod %>%
  filter(periode == "4_Decline") %>%
  select(date, user, tweets) %>%
  filter(user == "joeyakarta")

# user per periode ----
user_periode1 <- jumlah_pengguna %>%
  filter(periode == "1_Emergence")
user_periode2 <- jumlah_pengguna %>%
  filter(periode == "2_Coalescence")
user_periode3 <- jumlah_pengguna %>%
  filter(periode == "3_Bureaucratization")
user_periode4 <- jumlah_pengguna %>%
  filter(periode == "4_Decline")