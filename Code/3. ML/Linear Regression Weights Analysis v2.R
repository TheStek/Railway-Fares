library(tidyverse)
library(broom)

data <- read.csv("C:/Users/User/Documents/4. Fourth Year/Project/Railway-Fares/Code/3. ML/Train Data.csv")


model <- lm(FARE~., data)
summary(model)

singularities <- alias(model)


data_without_difference <- data %>%
  select(-contains("difference"), -contains("employment"), -contains("drive_GP"), -contains("drive_retail"))

model <- lm(FARE~., data_without_difference)
summary(model)

model_stats <- tidy(model, conf.int = TRUE )



ggplot(data = model_stats %>%
         filter(!is.na(estimate)) %>%
         top_n(10, abs(estimate)) %>%
         mutate(FeatureSet = ifelse(term %in% c("Stops", "Distance", "(Intercept)", "Time.min") 
                                    | grepl("Dist_from", term), "Non-SIMD", "SIMD"))
       )+
  geom_boxplot(aes(x = reorder(term, abs(estimate)), middle = estimate, lower = conf.low, upper = conf.high, ymin = conf.low, ymax = conf.high, fill = FeatureSet), stat = 'identity')+
  coord_flip()+
  xlab("Feature")+
  ylab("Linear Regression Weight")

ggplot(data = model_stats %>%
         mutate(FeatureSet = ifelse(term %in% c("Stops", "Distance", "(Intercept)", "Time.min") 
                                    | grepl("Dist_from", term), "Non-SIMD", "SIMD")))+
  geom_histogram(aes(x = reorder(term, abs(estimate)), y = abs(estimate), fill = FeatureSet), stat = "identity")+
  coord_flip()+
  xlab("Feature")+
  ylab("Absolute Value of Coefficient")
  
  
summary(lm(FARE~Distance, data))
  
  
scaled_data <- read.csv("C:/Users/User/Documents/4. Fourth Year/Project/Railway-Fares/Code/3. ML/Scaled Train Data.csv")
scaled_data_without_difference <- scaled_data %>%
  select(-contains("difference"))

scaled_model <- lm(FARE~., scaled_data_without_difference)
summary(scaled_model)

scaled_model_stats <- tidy(scaled_model, conf.int = TRUE )



ggplot(data = scaled_model_stats %>%
         filter(!is.na(estimate) & term != '(Intercept)') %>%
         top_n(10, abs(estimate)) %>%
         mutate(FeatureSet = ifelse(term %in% c("Stops", "Distance", "(Intercept)", "Time.min") 
                                    | grepl("Dist_from", term), "Non-SIMD", "SIMD"))
)+
  geom_boxplot(aes(x = reorder(term, abs(estimate)), middle = estimate, lower = conf.low, upper = conf.high, ymin = conf.low, ymax = conf.high, fill = FeatureSet), stat = 'identity')+
  coord_flip()+
  xlab("Feature")+
  ylab("Linear Regression Weight")

ggplot(data = scaled_model_stats %>%
         filter(term != '(Intercept)') %>%
         mutate(FeatureSet = ifelse(term %in% c("Stops", "Distance", "(Intercept)", "Time.min") 
                                    | grepl("Dist_from", term), "Non-SIMD", "SIMD")))+
  geom_histogram(aes(x = reorder(term, abs(estimate)), y = abs(estimate), fill = FeatureSet), stat = "identity")+
  coord_flip()+
  xlab("Feature")+
  ylab("Absolute Value of Coefficient")


library(reshape2)



stds <- data_without_difference %>%
  select(-FARE) %>%
  summarise_if(is.numeric, sd) %>%
  pivot_longer(everything())

stats_mult <- model_stats %>%
  inner_join(stds, by = c("term" = "name")) %>%
  mutate(estimate = estimate * value, conf.low = conf.low * value, conf.high = conf.high * value)



ggplot(data = stats_mult %>%
         filter(!is.na(estimate)) %>%
         top_n(15, abs(estimate)) %>%
         mutate(FeatureSet = ifelse(term %in% c("Stops", "Distance", "(Intercept)", "Time.min") 
                                    | grepl("Dist_from", term), "Non-SIMD", "SIMD"))
)+
  geom_boxplot(aes(x = reorder(term, abs(estimate)), middle = estimate, lower = conf.low, upper = conf.high, ymin = conf.low, ymax = conf.high, fill = FeatureSet), 
               stat = 'identity',
               lwd = 0.3,
               fatten = 0.3)+
  coord_flip()+
  xlab("Feature")+
  ylab("Feature Importance")

ggsave("C:/Users/User/Documents/4. Fourth Year/Project/Write Up Artifacts/ML/Linear Regression Weights.pdf",
       width = 6.5,
       units = "in",
       dpi = 300)

ggplot(data = stats_mult %>%
         mutate(FeatureSet = ifelse(term %in% c("Stops", "Distance", "(Intercept)", "Time.min") 
                                    | grepl("Dist_from", term), "Non-SIMD", "SIMD")))+
  geom_histogram(aes(x = reorder(term, abs(estimate)), y = abs(estimate), fill = FeatureSet), stat = "identity")+
  coord_flip()+
  xlab("Feature")+
  ylab("Absolute Value of Coefficient")
