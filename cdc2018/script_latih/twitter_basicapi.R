library(twitteR)

api_key <- "20KUwihqyw3PCm4tSfGZHDXum" # ganti dengan api key anda 
api_secret <- "6ykMH9XdM0Qnduj4cAI6lyGRRKG1abZU4TdQFdE5HZ4rKq1M4g" # ganti dengan api secret anda 
token <- "73705532-WlCKXW7Cjd2U2fcSUflTOnoLE0Nrk26gy6xddFzeM" # ganti dengan access token anda 
token_secret <- "JrUQjxTSx3QSTAGQnL1lnsO2ua8g4LKDV6xzZ4iJW3Rwh" # ganti dengan api key anda 

setup_twitter_oauth(api_key, api_secret, token, token_secret) # setting permission

# collect tweets
banser <- searchTwitter("#bubarkanbanser", n = 15000) # pengumpulan data

# mengubah format data menjadi data frame
banser <- twListToDF(banser)

# Save data
write.csv(banser, "banser.csv")