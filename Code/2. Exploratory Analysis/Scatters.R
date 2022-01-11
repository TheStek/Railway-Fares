library(tidyverse)
require(gridExtra)

data_in <- read.csv("C:\\Users\\User\\Documents\\4. Fourth Year\\Project\\Railway-Fares\\Datasets\\data_in.csv")


dist_fare <-ggplot(data_in %>% 
         sample_n(5000)) +
  geom_point(aes(x = Distance, y = FARE/100))+
  xlab("Journey Distance /km")+
  ylab("Fare/£")


ggplot(data_in %>% 
         sample_n(5000)) +
  geom_point(aes(x = Distance, y = Time.min))+
  xlab("Journey Distance /km")+
  ylab("Journey Time /mins")


time_fare <- ggplot(data_in %>% 
         sample_n(5000)) +
  geom_point(aes(x = Time.min, y = FARE/100))+
  xlab("Journey Time /mins")+
  ylab("Fare/£")



grid.arrange(dist_fare, time_fare, ncol=2)

ggplot(data_in %>% 
         sample_n(5000)) +
  geom_point(aes(x = Stops, y = FARE/100))+
  ylab("Fare/£")

ggplot(data_in %>% 
         sample_n(5000)) +
  geom_point(aes(x = Dist_from_Ed.origin, y = FARE))

grid.arrange(
  ggplot(data_in %>%
           sample_n(5000)) +
    geom_point(aes(x = Stops, y = Time.min))+
    xlab("Number of Intermediate Stops")+
    ylab("Journey Time/mins"),
  
  ggplot(data_in %>%
           sample_n(5000)) +
    geom_point(aes(x = Stops, y = Distance))+
    xlab("Number of Intermediate Stops")+
    ylab("Journey Distance /km"),
  
  ncol = 2)

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


grid.arrange(
  ggplot(data_in %>%
           sample_n(5000)) +
    geom_point(aes(x = PT_GP.destination, y = FARE/100))+
    ylab("Fare /£"),
  
  ggplot(data_in %>%
           sample_n(5000)) +
    geom_point(aes(x = drive_secondary.origin, y = FARE/100))+
    ylab("Fare /£"),
  
  ncol = 2)

ggplot(data_in %>%
         sample_n(5000)) +
  geom_point(aes(x = PT_GP.origin, y = PT_GP.destination, color = FARE/100))+
  scale_colour_viridis_c()+
  labs(color = "Fare /£")
  