library(tidyverse)
library(maps)

data_in <- read.csv("C:\\Users\\User\\Documents\\4. Fourth Year\\Project\\Railway-Fares\\Datasets\\data_in.csv")
stations <- read.csv("C:\\Users\\User\\Documents\\4. Fourth Year\\Project\\Railway-Fares\\Data\\Cleansed Data\\station.csv")
output_directory <- "C:/Users/User/Documents/4. Fourth Year/Project/Write Up Artifacts/Visualisation/"


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
  )

map_route_speed <- function(route_data){
  
  
  
  line_pairs <- route_data %>%
    mutate(fnum = row_number()) %>%
    select(FARE, lat.origin, lon.origin, fnum, Speed) %>%
    rename(lat = lat.origin, lon = lon.origin) %>%
    union(
      route_data %>%
        mutate(fnum = row_number()) %>%
        select(FARE, lat.dest, lon.dest, fnum, Speed) %>%
        rename(lat = lat.dest, lon = lon.dest)
    )
  
  
  uk <- map_data("world", region = "UK")
  
  
  ggplot()+
    geom_polygon(uk, mapping = aes(x =long, y = lat, group = group), fill = "lightgray")+
    geom_point(line_pairs, mapping = aes(x=lon, y= lat, group = fnum), colour = "darkgrey")+
    geom_line(line_pairs, mapping = aes(x=lon, y= lat, group = fnum, colour = Speed))+
    scale_colour_viridis_c()+
    coord_map(xlim = c(-6.5, -1),ylim = c(55, 56.5)) +
    labs(x ="", y= "", colour = "Speed/ km/h")+
    theme(panel.grid.major = element_blank(), 
          panel.grid.minor = element_blank(),
          axis.text.x = element_blank(),
          axis.ticks.x = element_blank(),
          axis.text.y = element_blank(),
          axis.ticks.y = element_blank()
    )
  
  
  
}

slow_fast_routes <- map_route_speed(data_with_speed %>% filter(Speed > 160 | Speed < 5))


ggsave(paste(output_directory, "Slowest and Fastest Routes (5, 160).pdf", sep = ''),
       width = 6,
       height = 4,
       units = "in",
       dpi = 500,
       plot = slow_fast_routes)


map_route_speed(data_with_speed %>% filter(Speed < 10))


ggplot(data = data_with_speed)+
  geom_histogram(aes(x=Speed), bins = 50)

speed_hist <- ggplot(data = data_with_speed)+
  geom_histogram(aes(x = Speed), bins = 150)+
  xlab("Speed/ km/h")+
  ylab("Number of Routes")

ggsave(paste(output_directory, "Speed Histogram.pdf", sep = ''),
       width = 6,
       height = 4,
       units = "in",
       dpi = 300,
       plot = speed_hist)

data_with_speed %>% top_n(-10, Speed) %>% select(Speed)

data_with_speed %>%
  filter(Speed > 160) %>%
  select(Route, Speed, Distance, Time.min)

data_with_speed %>%
  filter(Speed < 5) %>%
  select(Route, Speed, Distance, Time.min)

map_route_speed(data_with_speed %>% filter(CRS.origin == "DUN"))

data_with_speed %>% filter(CRS.origin == "DUN" & CRS.dest == "LCG")  %>%
  select(Route, Speed, Distance, Time.min, FARE)
