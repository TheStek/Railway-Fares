library(tidyverse)
library(broom)

data <- read.csv("C:/Users/User/Documents/4. Fourth Year/Project/Railway-Fares/Code/3. ML/Train Data.csv")


model <- lm(FARE~., data)
summary(model)

singularities <- alias(model)


data_without_difference <- data %>%
  select(-contains("difference"))

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

  
lm(FARE~., scale(data))

tibble(cor(data))

model_stats %>% filter(is.na(estimate))

ggplot(data = model_stats %>%
         mutate(FeatureSet = ifelse(term %in% c("Stops", "Distance", "(Intercept)", "Time.min") 
                                    | grepl("Dist_from", term), "Non-SIMD", "SIMD")))+
  geom_histogram(aes(x = reorder(term, abs(estimate)), y = abs(estimate), fill = FeatureSet), stat = "identity")+
  coord_flip()+
  xlab("Feature")+
  ylab("Absolute Value of Coefficient")
  
  
  summary(lm(FARE~Distance, data))

  
data %>% summarise(max = max(FARE), min = min(FARE), avg = mean(FARE))
