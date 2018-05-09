library(tidyverse)
library(tidytext)
library(stringr)
library(ggplot2)
library(igraph)
library(rgexf)

# data ----
dirwd <- paste(getwd(),"/wrangled jod/",sep='')
net_data <- read_csv(paste(dirwd, "user_jod.csv", sep = ''), col_names = TRUE)

# remove punct but _
net_data$user_all <- gsub("[^[:alpha:][:space:]_]*", "", net_data$user_all) 

net_data <- net_data %>%
  select(periode, user_all)

net_data$user_count <- sapply(net_data$user_all, function(x) length(unlist(strsplit(as.character(x), "\\S+"))))

# filtering rows
net_data <- net_data %>%
  filter(user_count >= 2)

net_input <- net_data %>%
  select(Data = user_all)

write_csv(net_input, path = "net_input.csv")

# graph all ----
dataSet2 <- net_input %>%
  select(Data) %>%
  unnest_tokens(bigram, Data, token = "ngrams", n = 2, to_lower = FALSE) %>%
  separate(bigram, into = c("word1", "word2"), sep = " ")

graph_file <- simplify(graph.data.frame(dataSet2, directed=FALSE))

# Create a dataframe nodes: 1st column - node ID, 2nd column -node name
nodes_df <- data.frame(ID = c(1:vcount(graph_file)), NAME = V(graph_file)$name)

# Create a dataframe edges: 1st column - source node ID, 2nd column -target node ID
edges_df <- as.data.frame(get.edges(graph_file, c(1:ecount(graph_file))))

# save and bring to gephi
write.gexf(nodes = nodes_df, edges = edges_df, defaultedgetype = "undirected", output = "net_jodalllll.gexf")
