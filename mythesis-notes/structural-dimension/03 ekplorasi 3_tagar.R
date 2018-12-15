# tagar

library(tidyverse)
library(ggplot2)
library(tidytext)

raw_jod <- read_csv("twit_jod.csv", col_names = TRUE)

tagar <- raw_jod %>% 
  select(date, hashtag, periode)

# normalisasi tagar ----
tagar_count <- tagar %>%
  select(hashtag) %>%
  unnest_tokens(tagar, hashtag, to_lower = FALSE, drop = TRUE) %>%
  mutate(tag_chr = nchar(tagar, keepNA= TRUE))

tagar_deleted <- tagar_count %>%
  filter(tag_chr <= 2) %>%
  mutate(replaced = "")

library(tm)

tag_cleaner <- function(input_text) # nama kolom yang akan dibersihkan
{    
  # create a corpus (type of object expected by tm) and document term matrix
  corpusku <- Corpus(VectorSource(input_text)) # make a corpus object
  stopwords <- as.character(tagar_deleted$tagar)
  stopwords <- c(stopwords, stopwords())
  corpusku <- tm_map(corpusku, removeWords, stopwords)
  
  corpusku <- tm_map(corpusku, content_transformer(tolower))
  #removing white space in the begining
  rem_spc_front <- function(x) gsub("^[[:space:]]+", "", x)
  corpusku <- tm_map(corpusku, content_transformer(rem_spc_front))
  #removing white space at the end
  rem_spc_back <- function(x) gsub("[[:space:]]+$", "", x)
  corpusku <- tm_map(corpusku, content_transformer(rem_spc_back))
  data <- data.frame(tagar=sapply(corpusku, identity),stringsAsFactors=F)
}

tagar_data <- tag_cleaner(tagar$hashtag)

tagar <- tagar %>%
  select(-hashtag)

tagar <- bind_cols(tagar, tagar_data)

# checking top tagar ----
tagar_count <- tagar %>%
  select(tagar) %>%
  unnest_tokens(tagar, tagar, to_lower = FALSE, drop = TRUE) %>%
  count(tagar, sort = TRUE)

# normalisasi ----
tagar$tagar <- gsub("\\bpiyehar\\b", "har", tagar$tagar)
tagar$tagar <- gsub("\\bpakhar\\b", "har", tagar$tagar)


tagar_10102013 <- tagar %>%
  filter(date == "2013-10-110")
