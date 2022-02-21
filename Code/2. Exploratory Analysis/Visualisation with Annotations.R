library(tidyverse)
require(gridExtra)

data_in <- read.csv("C:\\Users\\User\\Documents\\4. Fourth Year\\Project\\Railway-Fares\\Datasets\\data_in.csv")
stations <- read.csv("C:\\Users\\User\\Documents\\4. Fourth Year\\Project\\Railway-Fares\\Data\\Cleansed Data\\station.csv")


data_with_speed <- data_in %>%
  mutate(Speed = Distance/(Time.min/60)) %>%
  inner_join(stations %>% select(NLC, CRS), by = c("ORIGIN_CODE" = "NLC")) %>%
  inner_join(stations %>% select(NLC, CRS), by = c("DESTINATION_CODE" = "NLC"), suffix = c(".ORIGIN", ".DEST")) %>%
  mutate(Route = paste(CRS.ORIGIN, CRS.DEST, sep = " to "))


ggplot(data = data_with_speed)+
  geom_histogram(aes(x=Speed), bins = 50)

data_with_speed %>%
  filter(Speed > 80) %>%
  select(Route)

small <- data_with_speed %>% sample_n(1000)

require("ggrepel")

ggplot()+
  geom_point(data = small, mapping = aes(x=Distance, y=Speed))+
  geom_text_repel(data = small, mapping = aes(x=Distance, y=Speed, label = Route))



set.seed(42)

plot_data <- data_with_speed %>% sample_n(5000)


summary(lm(Time.min~Distance, plot_data))

ggplot(data = plot_data, mapping = aes(x=Distance, y = Time.min, label = ifelse(Time.min/Distance > 1.5 | Time.min/Distance < 0.7, Route, ""), color=FARE/100)) +
  geom_point()+
  xlab("Journey Distance /km")+
  ylab("Journey Time /mins")+
  labs(color = "Fare/£")+
  scale_colour_viridis_c()+
  geom_text_repel(box.padding = 0.7, color = "black")

ggplot(plot_data, aes(x = Stops, y = FARE/100, label = ifelse(Stops > 10, Route, ""))) +
  geom_point()+
  ylab("Fare/£")+
  geom_text_repel(box.padding = 0.5, color = "black")





summary(lm(FARE~Distance, plot_data))

dist_fare <- ggplot(plot_data, aes(x = Distance, y = FARE/100, label = ifelse(FARE/Distance > 30 | FARE/Distance < 20, Route, ""))) +
  geom_point()+
  xlab("Journey Distance /km")+
  ylab("Fare/£")+
  geom_text_repel(box.padding = 0.7)


summary(lm(FARE~Time.min, plot_data))

time_fare <- ggplot(plot_data, aes(x = Time.min, y = FARE/100, label = ifelse(FARE/Distance > 30 | FARE/Time.min < 20, Route, ""))) +
  geom_point()+
  xlab("Journey Time /mins")+
  ylab("Fare/£")+
  geom_text_repel(box.padding = 0.7)




grid.arrange(dist_fare, time_fare, ncol=2, widths = c(2, 2))  



ggplot(plot_data) +
  geom_point(aes(x = Distance, y = Time.min))+
  xlab("Journey Distance /km")+
  ylab("Journey Time /mins")+
  geom_text_repel(box.padding = 0.7)



ggplot(plot_data, aes(x = Stops, y = FARE/100, label = ifelse(Stops > 10 | FARE/100 <30, Route, ""))) +
  geom_point()+
  ylab("Fare/£")+
  geom_text_repel(box.padding = 0.7)


