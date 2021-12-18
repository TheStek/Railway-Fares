library(tidyverse)

data_in <- read.csv("C:\\Users\\User\\Documents\\4. Fourth Year\\Project\\Railway-Fares\\Datasets\\data_in.csv")


ggplot(data_in %>% 
         sample_n(5000)) +
  geom_point(aes(x = Distance, y = FARE))


ggplot(data_in %>% 
         sample_n(5000)) +
  geom_point(aes(x = Distance, y = Time.min))


ggplot(data_in %>% 
         sample_n(5000)) +
  geom_point(aes(x = Time.min, y = FARE))


ggplot(data_in %>% 
         sample_n(5000)) +
  geom_point(aes(x = Stops, y = FARE))

ggplot(data_in %>% 
         sample_n(5000)) +
  geom_point(aes(x = Dist_from_Ed.origin, y = FARE))


ggplot(data_in %>% 
         sample_n(5000) %>% 
         mutate(Cumulative_Dist_from_Edinburgh = Dist_from_Ed.origin + Dist_from_Ed.destination)) +
  geom_point(aes(x = Cumulative_Dist_from_Edinburgh, y = FARE))


ggplot(data_in %>% 
         sample_n(5000) %>% 
         mutate(Cumulative_Dist_from_Glasgow = Dist_from_Gls.origin + Dist_from_Gls.destination)) +
  geom_point(aes(x = Cumulative_Dist_from_Glasgow, y = FARE))


ggplot(data_in %>% 
         sample_n(5000) %>%
         mutate(Remoteness = pmin(Dist_from_Ed.origin, Dist_from_Gls.origin) + pmin(Dist_from_Ed.destination, Dist_from_Gls.destination))) +
  geom_point(aes(x = Remoteness, y = FARE))


  