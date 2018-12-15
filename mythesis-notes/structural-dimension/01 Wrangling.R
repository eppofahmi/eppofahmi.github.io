# Twit Wrangling

# Library ----
library(textclean)
library(lubridate)
library(tidyverse)
library(tidytext)
library(stringr)
library(tm)

# Data mentah =====================================
change_raw <- read.csv("hasil-new1.csv", header = FALSE, 
                    stringsAsFactors = FALSE, sep = ",") 

colnames(change_raw) <- c("date", "time", "user", "tweets", "replying", 
                       "rep_count", "ret_count", "fav_count","link")

# converting date format
change_raw$date <- as.Date(change_raw$date,format='%Y/%m/%d')
#change_raw$ret_count <- as.integer(change_raw$ret_count)

glimpse(change_raw)

# 1. is_duplicate =================================
change_raw <- change_raw %>%
  dplyr::mutate(is_duplicate = duplicated(tweets))

# 2. user_all ===================================== 
# add @ if nedeed
#change_raw$user <- paste("@", change_raw$user, sep="")

change_raw$tweets <- gsub("pic[^[:space:]]*", "", change_raw$tweets)
change_raw$tweets <- gsub("http[^[:space:]]*", "", change_raw$tweets)
change_raw$tweets <- gsub("https[^[:space:]]*", "", change_raw$tweets)

change_raw$user_all <- sapply(str_extract_all(change_raw$tweets, "(?<=@)[^\\s:]+", simplify = FALSE), paste, collapse=", ")

# merge column user and user_all
change_raw$user_all <- paste(change_raw$user, change_raw$user_all, sep=", ")

# removing punct
#change_raw$user_all <- gsub("[^[:alpha:][:space:]@_]*", "", change_raw$user_all)

# 3. user_count ==================================
change_raw$user_count <- sapply(change_raw$user_all, function(x) length(unlist(strsplit(as.character(x), "\\S+"))))

# 4. tagar =======================================
change_raw$hashtag <- sapply(str_extract_all(change_raw$tweets, "(?<=#)[^\\s]+", simplify = FALSE), paste, collapse=", ")

#change_raw$hashtag <- sapply(str_extract_all(change_raw$tweets, "#\\S+", simplify = FALSE), paste, collapse=", ")


#change_raw$hashtag <- gsub("[^[:alpha:][:space:]#]*", "", change_raw$hashtag)

# 5. tag_count ===================================
change_raw$tag_count <- sapply(change_raw$hashtag, 
                            function(x) length(unlist(strsplit(as.character(x), "\\S+"))))

# 6. clean_text ==================================
tweet_cleaner2 <- function(input_text) # nama kolom yang akan dibersihkan
{    
  # create a corpus (type of object expected by tm) and document term matrix
  corpusku <- Corpus(VectorSource(input_text)) # make a corpus object
  # remove urls1
  removeURL1 <- function(x) gsub("http[^[:space:]]*", "", x) 
  corpusku <- tm_map(corpusku, content_transformer(removeURL1))
  #remove urls3
  removeURL2 <- function(x) gsub("pic[^[:space:]]*", "", x) 
  corpusku <- tm_map(corpusku, content_transformer(removeURL2))
  #remove username 
  TrimUsers <- function(x) {
    str_replace_all(x, '(@[[:alnum:]_]*)', '')
  }
  corpusku <- tm_map(corpusku, TrimUsers)
  #remove all "#Hashtag1"
  removehashtag <- function(x) gsub("#\\S+", "", x)
  corpusku <- tm_map(corpusku, content_transformer(removehashtag))
  #merenggangkan tanda baca
  #tandabaca1 <- function(x) gsub("((?:\b| )?([.,:;!?()]+)(?: |\b)?)", " \\1 ", x, perl=T)
  #corpusku <- tm_map(corpusku, content_transformer(tandabaca1))
  #remove puntuation
  removeNumPunct <- function(x) gsub("[^[:alpha:][:space:]]*", "", x)
  corpusku <- tm_map(corpusku, content_transformer(removeNumPunct))
  corpusku <- tm_map(corpusku, stripWhitespace)
  corpusku <- tm_map(corpusku, content_transformer(tolower)) 
  #stopwords bahasa indonesia
  stopwords <- read.csv("stopwords_indo.csv", header = FALSE)
  stopwords <- as.character(stopwords$V1)
  stopwords <- c(stopwords, stopwords())
  corpusku <- tm_map(corpusku, removeWords, stopwords)
  #kata khusus yang dihapus
  corpusku <- tm_map(corpusku, removeWords, c("rt", "cc", "via", "jrx", "balitolakreklamasi", "acehjakartajambisurabayabalintbpaluambon", "bali", "selamat", "pagi", "bli", "paraf", "petisi", "yks", "thn", "ri", "sign", "can", "go", "mr", "dlm", "recruiterutmsourcesharepetitionutmmediumtwitterutmcampaignsharetwittermobile"))
  corpusku <- tm_map(corpusku, stripWhitespace)
  #removing white space in the begining
  rem_spc_front <- function(x) gsub("^[[:space:]]+", "", x)
  corpusku <- tm_map(corpusku, content_transformer(rem_spc_front))
  
  #removing white space at the end
  rem_spc_back <- function(x) gsub("[[:space:]]+$", "", x)
  corpusku <- tm_map(corpusku, content_transformer(rem_spc_back))
  data <- data.frame(clean_text=sapply(corpusku, identity),stringsAsFactors=F)
}

clean_text <- tweet_cleaner2(change_raw$tweets)

a <- clean_text %>%
  unnest_tokens(bigram, clean_text, token = "ngrams", n=2, drop = FALSE) %>%
  count(bigram, sort = TRUE)

#View(a)
rm(a)

# 7. word_count ==================================
clean_text$word_count <- sapply(clean_text$clean_text, 
                                function(x) length(unlist(strsplit(as.character(x), "\\W+"))))

change_raw <- bind_cols(change_raw, clean_text)
rm(clean_text)

# 8. Periode =====================================
# Periode dibagi berdasarkan tahun
change_raw <- change_raw %>%
  mutate(periode = case_when(
    date >= "2013-10-07" & date <= "2013-12-31" ~ "1_Emergence",
    date >= "2014-01-01" & date <= "2014-10-31" ~ "2_Coalescence",
    date >= "2014-11-01" & date <= "2015-10-31" ~ "3_Bureaucratization",
    TRUE ~ "4_Decline")) %>%
  mutate(periode = factor(periode, levels = c("1_Emergence", "2_Coalescence", "3_Bureaucratization", "4_Decline")))

#9. Parameter pencarian======================
change_raw <- change_raw %>%
  mutate(sumber_data = "twitter")

change_raw <- change_raw %>%
  mutate(parameter = "#jogjaoradidol")

#10. save ----
names(change_raw)

change_raw <- change_raw %>%
  select(sumber_data, parameter, date, time, periode, user, user_all, user_count, tweets,clean_text, word_count, hashtag, tag_count, is_duplicate, replying, fav_count, rep_count, ret_count, link)

write_csv(change_raw, path = "twit_jod.csv")
