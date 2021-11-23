library(tidyverse)
import(maps)



data_dz <- read.csv("C:\\Users\\User\\Documents\\4. Fourth Year\\Project\\Railway-Fares\\Datasets\\data_dz.csv")
coordinates <- read.csv(paste(data_path, "station.csv", sep = "")) %>% select(NLC, lat, lon)


fare_station <- data_dz %>%
  inner_join(coordinates, by = c("ORIGIN_CODE" = "NLC")) %>%
  inner_join(coordinates, by = c("DESTINATION_CODE" = "NLC"), suffix = c(".origin", ".dest"))


fare_station_sample <- fare_station %>%
  mutate(price_per_km = FARE / Distance) %>%
  arrange(desc(price_per_km)) %>%
  top_n(-2) %>%
  mutate(fnum = row_number())

line_pairs <- fare_station_sample %>%
  select(FARE, lat.origin, lon.origin, fnum) %>%
  rename(lat = lat.origin, lon = lon.origin) %>%
  union(
    fare_station_sample %>%
      select(FARE, lat.dest, lon.dest, fnum) %>%
      rename(lat = lat.dest, lon = lon.dest)
  )


uk <- map_data("world", region = "UK")


ggplot()+
  geom_polygon(uk, mapping = aes(x =long, y = lat, group = group), fill = "lightgray")+
  geom_point(line_pairs, mapping = aes(x=lon, y= lat, group = fnum), colour = "darkgrey")+
  geom_line(line_pairs, mapping = aes(x=lon, y= lat, group = fnum, colour = FARE/100))+
  scale_colour_viridis_c()+
  coord_map(xlim = c(-6.5, -1),ylim = c(55, 58.5)) +
  labs(x ="", y= "", colour = "Fare/£")+
  theme(panel.grid.major = element_blank(), 
        panel.grid.minor = element_blank(),
        axis.text.x = element_blank(),
        axis.ticks.x = element_blank(),
        axis.text.y = element_blank(),
        axis.ticks.y = element_blank()
  )
