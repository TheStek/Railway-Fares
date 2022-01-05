library(tidyverse)

data_in <- read.csv("C:\\Users\\User\\Documents\\4. Fourth Year\\Project\\Railway-Fares\\Datasets\\data_in.csv")



lin_dist <- lm(FARE~Distance, data = data_in)
summary(lin_dist)


lin_time <- lm(FARE~Time.min, data = data_in)
summary(lin_time)



cors <- cor(data_in %>% select(-FARE, -ORIGIN_CODE, -DESTINATION_CODE), data_in %>% select(FARE))
correlations <- tibble(cors) %>% mutate(Feature = rownames(cors), abs_cor = abs(cors)) %>% rename(Correlation = cors)

ggplot(correlations)+
  geom_bar(aes(x = reorder(Feature, abs_cor), y = Correlation, fill = abs_cor), stat = "identity")+
  coord_flip()+
  labs(x = "Feature", title = "Correlation with Fare by Feature", fill = "Correlation Strength")+
  scale_fill_viridis_c()


cor(data_in %>% select(Distance), data_in %>% select(Time.min))
