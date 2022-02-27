library(tidyverse)
library(jsonlite)


log_path <- "C:/Users/User/Documents/4. Fourth Year/Project/Railway-Fares/Logs/"



rfr <- fromJSON(paste(log_path, "random_forest_regression.json", sep = ""))

rfr %>%
  group_by(method, dataset, subset) %>%
  summarise(mean.val_score = mean(val_score),
            sd.val_score = sd(val_score),
            n.val_score = n()) %>%
  mutate(se.val_score = sd.val_score / sqrt(n.val_score),
         ci_width = qt(1 - (0.025 / 2), n.val_score - 1) * se.val_score,
         lower.ci.val_score = mean.val_score - ci_width,
         upper.ci.val_score = mean.val_score + ci_width)
