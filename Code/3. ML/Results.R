library(tidyverse)
library(jsonlite)


log_path <- "C:/Users/User/Documents/4. Fourth Year/Project/Railway-Fares/Logs/"



lin_reg <- fromJSON(paste(log_path, "linear_regression.json", sep = ""))

lin_reg %>% arrange(subset, desc(val_score))

rfr <- fromJSON(paste(log_path, "random_forest_regression.json", sep = ""))

rfr %>% arrange(desc(val_score))

gpr <- fromJSON(paste(log_path, "gpr_ensemble.json", sep = ""))

gpr %>% arrange(desc(val_score))


gpr %>% arrange(subset, kernel, desc(val_score))

gpr %>% filter(kernel == "RationalQuadratic(alpha=0.1, length_scale=1)") %>% arrange(desc(val_score))
