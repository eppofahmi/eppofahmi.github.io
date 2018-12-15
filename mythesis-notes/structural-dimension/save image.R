tiff("Figure3.tiff", res=300, compression = "lzw", height=4, width=7, units="in")
user_terlibat %>%
  arrange(desc(n)) %>%
  top_n(10) %>%
  ggplot(aes(x = reorder(user_all, n), y = n, fill = factor(fase))) +
  geom_col(show.legend = FALSE) +
  coord_flip() +
  facet_wrap(~fase) +
  labs(x = "Username", 
       y = "occurrences")
dev.off()


# anomali ----
tiff("Figure2.tiff", res=300, compression = "lzw", height=4, width=7, units="in")
anomali_all$plot
dev.off()