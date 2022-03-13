library(tidyverse)
library(broom)

data <- read.csv("C:/Users/User/Documents/4. Fourth Year/Project/Railway-Fares/Code/3. ML/Train Data.csv")


model <- lm(FARE~., data)
summary(model)

tibble(alias(model))

model_stats <- tidy(model, conf.int = TRUE )

ggplot(data = model_stats %>%
         filter(!is.na(estimate)) %>%
         top_n(10, abs(estimate))
       )+
  geom_boxplot(aes(x = reorder(term, abs(estimate)), middle = estimate, lower = conf.low, upper = conf.high, ymin = conf.low, ymax = conf.high), stat = 'identity', fill = 'blue')+
  coord_flip()+
  xlab("Feature")+
  ylab("Linear Regression Weight")

  
