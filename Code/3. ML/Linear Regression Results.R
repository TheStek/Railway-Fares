library(tidyverse)
library(jsonlite)


log_path <- "C:/Users/User/Documents/4. Fourth Year/Project/Railway-Fares/Logs/"



lin_reg <- fromJSON(paste(log_path, "linear_regression.json", sep = ""))

lin_reg %>%
  group_by(method, dataset, subset) %>%
  summarise(mean.val_score = mean(val_score),
            sd.val_score = sd(val_score),
            n.val_score = n()) %>%
  mutate(se.val_score = sd.val_score / sqrt(n.val_score),
         ci_width = qt(1 - (0.025 / 2), n.val_score - 1) * se.val_score,
         lower.ci.val_score = mean.val_score - ci_width,
         upper.ci.val_score = mean.val_score + ci_width) %>%
  mutate(width = formatC(ci_width, format = "e", digits = 2)) %>%
  select(method, subset, mean.val_score, width) %>%
  arrange(subset)


subset_mapping <- tibble(
  code_name = c('dist', 'dist_time', 'dist_remoteness', 'full', 'simd'),
  name = c('Distance', 'Distance + Time', 'Distance + Remoteness', 'Full', 'SIMD'))

ggplot(data = lin_reg %>%
         filter(val_score > 0.7) %>%
         inner_join(subset_mapping, by = c("subset" = "code_name")) %>%
         mutate(desc = ifelse(grepl("pca", method), paste("PCA", name, sep = " - "), name))
)+
  geom_boxplot(aes(x = reorder(desc, val_score), y = val_score), color = "black", fill = "blue")+
  coord_flip()+
  xlab("Data Subset")+
  ylab("Validation Score")
