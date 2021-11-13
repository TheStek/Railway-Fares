library(tidyverse)
import(maps)

data_path <- "C:\\Users\\User\\Documents\\4. Fourth Year\\Project\\Railway-Fares\\Data\\Cleansed Data\\"

fares <- read.csv(paste(data_path, "inscope_fares.csv", sep = "")) %>% select(-X)
coordinates <- read.csv(paste(data_path, "station.csv", sep = "")) %>% select(NLC, lat, lon)
data_in <- read.csv("C:\\Users\\User\\Documents\\4. Fourth Year\\Project\\Railway-Fares\\Datasets\\data_in.csv")



fare_station <- fares %>%
  inner_join(coordinates, by = c("ORIGIN_CODE" = "NLC")) %>%
  inner_join(coordinates, by = c("DESTINATION_CODE" = "NLC"), suffix = c(".origin", ".dest")) %>%
  mutate(Fare = FARE / 100)

plot_routes <- function(n_routes){
  fare_station_sample <- fare_station %>%
    sample_n(n_routes) %>%
    mutate(fnum = row_number())
  
  line_pairs <- fare_station_sample %>%
    select(Fare, lat.origin, lon.origin, fnum) %>%
    rename(lat = lat.origin, lon = lon.origin) %>%
    union(
      fare_station_sample %>%
        select(Fare, lat.dest, lon.dest, fnum) %>%
        rename(lat = lat.dest, lon = lon.dest)
    )
  
  
  uk <- map_data("world", region = "UK")
  
  
  ggplot()+
    geom_polygon(uk, mapping = aes(x =long, y = lat, group = group), fill = "lightgray")+
    geom_point(line_pairs, mapping = aes(x=lon, y= lat, group = fnum), colour = "darkgrey")+
    geom_line(line_pairs, mapping = aes(x=lon, y= lat, group = fnum, colour = Fare))+
    scale_colour_gradient(
      low = "green",
      high = "red",
      space = "Lab",
      guide = "colourbar",
      aesthetics = "colour"
    )+
    coord_map(xlim = c(-6.5, -1),ylim = c(55, 58.5))
}



