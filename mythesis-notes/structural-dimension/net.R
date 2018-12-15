library(tidyverse)
library(ggplot2)

net_data <- read_csv("jodall net.csv")

net_viz <- net_1 %>%
  select(Label, eigencentrality, modularity_class)

net_1 <- net_viz %>%
  filter(modularity_class == 0) %>%
  arrange(desc(eigencentrality)) %>%
  head(n = 5)

net_2 <- net_viz %>%
  filter(modularity_class == 1) %>%
  arrange(desc(eigencentrality)) %>%
  head(n = 5)

net_3 <- net_viz %>%
  filter(modularity_class == 2) %>%
  arrange(desc(eigencentrality)) %>%
  head(n = 5)

net_4 <- net_viz %>%
  filter(modularity_class == 3) %>%
  arrange(desc(eigencentrality)) %>%
  head(n = 5)

net_5 <- net_viz %>%
  filter(modularity_class == 4) %>%
  arrange(desc(eigencentrality)) %>%
  head(n = 5)

net_6 <- net_viz %>%
  filter(modularity_class == 5) %>%
  arrange(desc(eigencentrality)) %>%
  head(n = 5)

net_7 <- net_viz %>%
  filter(modularity_class == 6) %>%
  arrange(desc(eigencentrality)) %>%
  head(n = 5)

net_8 <- net_viz %>%
  filter(modularity_class == 7) %>%
  arrange(desc(eigencentrality)) %>%
  head(n = 5)

net_viz <- bind_rows(net_1, net_3, net_4, net_5, net_8)

net_viz$modularity_class <- paste("modularity class", "", net_viz$modularity_class)

tiff("Figure5.tiff", res=300, compression = "lzw", height=4, width=7, units="in")
net_viz %>%
  ggplot(aes(reorder(Label, eigencentrality), eigencentrality, fill = modularity_class)) +
  geom_col(show.legend = FALSE) + coord_flip() +
  facet_wrap(~modularity_class, scales = "free") + 
  labs(x = "Username", y = "eigencentrality") + 
  scale_fill_manual(values=c("#8B850B", "#C70106", "#019925", "#67FE50", "#019CDE"))
dev.off()