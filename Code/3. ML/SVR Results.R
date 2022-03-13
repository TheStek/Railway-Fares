library(tidyverse)
library(jsonlite)


log_path <- "C:/Users/User/Documents/4. Fourth Year/Project/Railway-Fares/Logs/"



svr <- fromJSON(paste(log_path, "svr.json", sep = ""))


subset_mapping <- tibble(
  code_name = c('dist', 'dist_time', 'dist_remoteness', 'full', 'simd'),
  name = c('Distance', 'Distance + Time', 'Distance + Remoteness', 'Full', 'SIMD'))

svr_stats <- svr %>%
  group_by(method, dataset, subset) %>%
  summarise(mean.val_score = mean(val_score),
            sd.val_score = sd(val_score),
            n.val_score = n()) %>%
  mutate(se.val_score = sd.val_score / sqrt(n.val_score),
         ci_width = qt(1 - (0.025 / 2), n.val_score - 1) * se.val_score,
         lower.ci.val_score = mean.val_score - ci_width,
         upper.ci.val_score = mean.val_score + ci_width)%>%
  mutate(mean = round(mean.val_score, 4), width = round(ci_width, 4)) %>%
  inner_join(subset_mapping, by = c("subset" = "code_name")) %>%
  select(name, mean, width)



ggplot(data = svr %>%
         inner_join(subset_mapping, by = c("subset" = "code_name")) %>%
         filter(val_score > 0.8) %>%
         mutate(desc = ifelse(grepl("lin", method), paste("Linear", name, sep = " - "), paste("RBF", name, sep = " - ")))
)+
  geom_boxplot(aes(x = reorder(desc, val_score), y = val_score), color = "black", fill = "blue")+
  coord_flip()+
  xlab("Kernel + Data Subset")+
  ylab("Validation Score")

