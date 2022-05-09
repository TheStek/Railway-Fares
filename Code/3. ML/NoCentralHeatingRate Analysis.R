library(tidyverse)
library(maps)

output_directory <- "C:/Users/User/Documents/4. Fourth Year/Project/Write Up Artifacts/Visualisation/"



coordinates <- read.csv("C:\\Users\\User\\Documents\\4. Fourth Year\\Project\\Railway-Fares\\Data\\Cleansed Data\\station.csv") %>% select(NLC, lat, lon)
data <- data_in <- read.csv("C:\\Users\\User\\Documents\\4. Fourth Year\\Project\\Railway-Fares\\Datasets\\data_in.csv")


central_heating <- data %>%
  select(ORIGIN_CODE, nocentralheating_rate.origin) %>%
  inner_join(coordinates, by = c("ORIGIN_CODE" = "NLC")) %>%
  distinct()


uk <- map_data("world", region = "UK")

ggplot()+
  geom_polygon(uk, mapping = aes(x =long, y = lat, group = group), fill = "lightgray")+
  geom_point(central_heating, mapping = aes(x=lon, y= lat, color = nocentralheating_rate.origin), size = 5)+
  scale_colour_viridis_c()+
  coord_map(xlim = c(-6.5, -1),ylim = c(55, 58.5)) +
  labs(x ="", y= "", colour = "No Central Heating Rate")+
  theme(panel.grid.major = element_blank(), 
        panel.grid.minor = element_blank(),
        axis.text.x = element_blank(),
        axis.ticks.x = element_blank(),
        axis.text.y = element_blank(),
        axis.ticks.y = element_blank()
  )


ggplot()+
  geom_point(central_heating, mapping = aes(x=lon, y= lat, color = nocentralheating_rate.origin), size = 5)

ggplot(central_heating)+
  geom_histogram(aes(x = nocentralheating_rate.origin))


central_heating %>%
  summarise(mean = mean(nocentralheating_rate.origin), med = median(nocentralheating_rate.origin))
