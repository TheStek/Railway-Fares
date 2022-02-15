library(tidyverse)
library(maps)

data_in <- read.csv("C:\\Users\\User\\Documents\\4. Fourth Year\\Project\\Railway-Fares\\Datasets\\data_in.csv")
stations <- read.csv("C:\\Users\\User\\Documents\\4. Fourth Year\\Project\\Railway-Fares\\Data\\Cleansed Data\\station.csv")

data_with_speed <- data_in %>%
  mutate(Speed = Distance/(Time.min/60)) %>%
  inner_join(stations %>% select(NLC, CRS, lat, lon), by = c("ORIGIN_CODE" = "NLC")) %>%
  inner_join(stations %>% select(NLC, CRS, lat, lon), by = c("DESTINATION_CODE" = "NLC"), suffix = c(".origin", ".dest")) %>%
  mutate(Route = paste(CRS.origin, CRS.dest, sep = " to "))


set.seed(42)

slowest_and_fastest <- 
  union(
    top_n(data_with_speed, 50, Speed),
    top_n(data_with_speed, -0, Speed)
  ) %>%
  mutate(fnum = row_number())

line_pairs <- slowest_and_fastest %>%
  select(FARE, lat.origin, lon.origin, fnum, Speed) %>%
  rename(lat = lat.origin, lon = lon.origin) %>%
  union(
    slowest_and_fastest %>%
      select(FARE, lat.dest, lon.dest, fnum, Speed) %>%
      rename(lat = lat.dest, lon = lon.dest)
  )


uk <- map_data("world", region = "UK")


ggplot()+
  geom_polygon(uk, mapping = aes(x =long, y = lat, group = group), fill = "lightgray")+
  geom_point(line_pairs, mapping = aes(x=lon, y= lat, group = fnum), colour = "darkgrey")+
  geom_line(line_pairs, mapping = aes(x=lon, y= lat, group = fnum, colour = Speed))+
  scale_colour_viridis_c()+
  coord_map(xlim = c(-6.5, -1),ylim = c(55, 58.5)) +
  labs(x ="", y= "", colour = "Speed/ km/h")+
  theme(panel.grid.major = element_blank(), 
        panel.grid.minor = element_blank(),
        axis.text.x = element_blank(),
        axis.ticks.x = element_blank(),
        axis.text.y = element_blank(),
        axis.ticks.y = element_blank()
  )

ggplot(data = data_with_speed %>% filter(CRS.origin == 'DUN' | ))+
  geom_histogram(aes(x=Speed), bins = 50)
