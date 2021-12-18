library(tidyverse)

sdz <- read.csv("C:\\Users\\User\\Documents\\4. Fourth Year\\Project\\Railway-Fares\\Data\\Cleansed Data\\station_datazone.csv")
simd <- read.csv("C:\\Users\\User\\Documents\\4. Fourth Year\\Project\\Railway-Fares\\Data\\simd2020_withinds.csv")


sdz <- sdz %>%
  select(NLC, Data_Zone)


simd <-  simd %>%
  rename(Data_Zone  = ï..Data_Zone) %>%
  select(Data_Zone:Council_area)



joined <- sdz %>%
  left_join(simd, by = "Data_Zone")


write.csv(joined, "C:\\Users\\User\\Documents\\4. Fourth Year\\Project\\Railway-Fares\\Data\\Cleansed Data\\station_datazone.csv")