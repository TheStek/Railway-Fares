library(tidyverse)
library(maps)

data_path <- paste(dirname(dirname(getwd())), "\\Data\\Cleansed Data\\", sep = "")
output_directory <- "C:/Users/User/Documents/4. Fourth Year/Project/Write Up Artifacts/Visualisation/"


fares <- read.csv(paste(data_path, "inscope_fares.csv", sep = "")) %>% select(-X)
coordinates <- read.csv(paste(data_path, "station.csv", sep = "")) %>% select(NLC, lat, lon)
data_in <- read.csv(paste(dirname(dirname(getwd())), "\\Datasets\\data_in.csv", sep = ""))



fare_station <- fares %>%
  inner_join(coordinates, by = c("ORIGIN_CODE" = "NLC")) %>%
  inner_join(coordinates, by = c("DESTINATION_CODE" = "NLC"), suffix = c(".origin", ".dest"))

plot_routes <- function(fare_station_data, n_routes){
  fare_station_sample <- fare_station_data %>%
    sample_n(n_routes) %>%
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
    geom_point(line_pairs, mapping = aes(x=lon, y= lat, group = fnum), colour = "darkgrey", size = 0.3)+
    geom_line(line_pairs, mapping = aes(x=lon, y= lat, group = fnum, colour = FARE/100), size = 0.2)+
    scale_colour_viridis_c()+
    coord_map(xlim = c(-6.5, -1),ylim = c(55, 58.5)) +
    labs(x ="", y= "", colour = "Fare/�", title = cat(n_routes, " sample routes"))+
    theme(panel.grid.major = element_blank(), 
          panel.grid.minor = element_blank(),
          axis.text.x = element_blank(),
          axis.ticks.x = element_blank(),
          axis.text.y = element_blank(),
          axis.ticks.y = element_blank()
          )
}


route_sample <- plot_routes(fare_station, 5000)

ggsave(paste(output_directory, "Routes-5000.pdf", sep = ''),
       width = 6,
       height = 5,
       units = "in",
       dpi = 500,
       plot = route_sample)


ggplot(data_in)+
  geom_point(aes(x=Distance, y=FARE/100))+
  xlab("Journey Distance /km")+
  ylab("Fare/�")

ggplot(data_in)+
  geom_point(aes(x=Distance, y=FARE/100))+
  xlab("Journey Distance /km")+
  ylab("Fare/�")+
  xlim(0, 100)+
  ylim(0, 20)


ggplot(data_in)+
  geom_point(aes(x=Distance, y=FARE/100))+
  xlab("Journey Distance /km")+
  ylab("Fare/�")+
  ylim(35, 40)


