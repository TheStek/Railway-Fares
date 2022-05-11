library(tidyverse)
library(jsonlite)


log_path <- "C:/Users/User/Documents/4. Fourth Year/Project/Railway-Fares/Logs/"



rfr <- fromJSON(paste(log_path, "random_forest_regression.json", sep = ""))




subset_mapping <- tibble(
  code_name = c('dist', 'dist_time', 'dist_remoteness', 'full', 'simd'),
  name = c('Distance', 'Distance + Time', 'Distance + Remoteness', 'Full', 'SIMD'))


rfr_stats <- rfr %>%
  group_by(method, dataset, subset) %>%
  summarise(mean.val_score = mean(val_score, 4),
            sd.val_score = sd(val_score),
            n.val_score = n()) %>%
  mutate(se.val_score = sd.val_score / sqrt(n.val_score),
         ci_width = qt(1 - (0.025 / 2), n.val_score - 1) * se.val_score,
         lower.ci.val_score = mean.val_score - ci_width,
         upper.ci.val_score = mean.val_score + ci_width) %>%
  mutate(mean = round(mean.val_score, 4), width = round(ci_width, 4)) %>%
  inner_join(subset_mapping, by = c("subset" = "code_name")) %>%
  select(name, mean, width)



rfr_boxplot <- ggplot(data = rfr %>%
         filter(val_score > 0.8) %>%
         inner_join(subset_mapping, by = c("subset" = "code_name")) %>%
         mutate(desc = ifelse(grepl("pca", method), paste("PCA", name, sep = " - "), name))
)+
  geom_boxplot(aes(x = reorder(desc, val_score), y = val_score), color = "black", fill = "#00BFC4",
               lwd = 0.3,
               fatten = 0.3)+
  coord_flip()+
  xlab("Data Subset")+
  ylab("Validation Score")

ggsave("C:/Users/User/Documents/4. Fourth Year/Project/Write Up Artifacts/ML/RFR Boxplot.pdf",
       width = 6,
       height = 5,
       units = "in",
       dpi = 300,
       plot = rfr_boxplot)
