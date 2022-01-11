library(tidyverse)
library(jsonlite)


log_path <- "C:/Users/User/Documents/4. Fourth Year/Project/Railway-Fares/Logs/"



lin_reg <- fromJSON(paste(log_path, "linear_regression.json", sep = ""))

lin_reg %>% arrange(subset, desc(val_score))

rfr <- fromJSON(paste(log_path, "random_forest_regression.json", sep = ""))

rfr %>% arrange(desc(val_score))


