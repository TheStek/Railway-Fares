library(tidyverse)

data_path <- "C:\\Users\\User\\Documents\\4. Fourth Year\\Project\\Railway-Fares\\Data\\Cleansed Data\\"
output_path <- "C:\\Users\\User\\Documents\\4. Fourth Year\\Project\\Railway-Fares\\Datasets\\"

fares <- read.csv(paste(data_path, "inscope_fares.csv", sep = "")) %>% select(-X)
distances <- read.csv(paste(data_path, "distances.csv", sep = ""))
station_datazone <- read.csv(paste(data_path, "station_datazone.csv", sep = "")) %>% select(-X)
simd_dz <- read.csv(paste(data_path, "datazone_SIMD.csv", sep = "")) %>% select(-X)
simd_in <- read.csv(paste(data_path, "intermediate_zone_SIMD.csv", sep = "")) %>% select(-X)
simd_ca <- read.csv(paste(data_path, "council_area_SIMD.csv", sep = "")) %>% select(-X)




data_with_location <- fares %>%
  inner_join(distances, by = c("ORIGIN_CODE" = "Origin", "DESTINATION_CODE" = "Destination")) %>%
  inner_join(station_datazone, by = c("ORIGIN_CODE" = "NLC")) %>%
  inner_join(station_datazone, by = c("DESTINATION_CODE" = "NLC"), 
             suffix = c(".origin", ".destination"))


data_dz <- data_with_location %>%
  inner_join(simd_dz, by = c("Data_Zone.origin" = "Data_Zone")) %>%
  inner_join(simd_dz, by = c("Data_Zone.destination" = "Data_Zone"),
             suffix = c(".origin", ".destination")) %>%
  select(-contains("count"), 
         -contains("Data_Zone"), 
         -contains("Intermediate"), 
         -contains("Council"),
         -contains("population")
         ) %>%
  mutate(
    crime_rate.origin = if_else(is.infinite(crime_rate.origin), 0, crime_rate.origin),
    crime_rate.destination = if_else(is.infinite(crime_rate.destination), 0, crime_rate.destination),
    ) %>%
  mutate(
    difference_drive_petrol = drive_petrol.destination - drive_petrol.origin,
    difference_drive_GP = drive_GP.destination - drive_GP.origin,
    difference_drive_primary = drive_primary.destination - drive_primary.origin,
    difference_drive_secondary = drive_secondary.destination - drive_secondary.origin,
    difference_drive_post = drive_post.destination - drive_post.origin,
    difference_drive_retail = drive_retail.destination - drive_retail.origin,
    difference_PT_GP = PT_GP.destination - PT_GP.origin,
    difference_PT_post = PT_post.destination - PT_post.origin,
    difference_PT_retail = PT_retail.destination - PT_retail.origin,
    difference_crime_rate = crime_rate.destination - crime_rate.origin,
    difference_income_rate = income_rate.destination - income_rate.origin,
    difference_employment_rate = employment_rate.destination - employment_rate.origin,
    difference_overcrowded_rate = overcrowded_rate.destination - overcrowded_rate.origin,
    difference_nocentralheating_rate = nocentralheating_rate.destination - nocentralheating_rate.origin
  )



data_in <- data_with_location %>%
  inner_join(simd_in, by = c("Intermediate_Zone.origin" = "Intermediate_Zone")) %>%
  inner_join(simd_in, by = c("Intermediate_Zone.destination" = "Intermediate_Zone"),
             suffix = c(".origin", ".destination")) %>%
  select(-contains("count"), 
         -contains("Data_Zone"), 
         -contains("Intermediate"), 
         -contains("Council"),
         -contains("population")
  ) %>%
  mutate(
    crime_rate.origin = if_else(is.infinite(crime_rate.origin), 0, crime_rate.origin),
    crime_rate.destination = if_else(is.infinite(crime_rate.destination), 0, crime_rate.destination),
  ) %>%
  mutate(
    difference_drive_petrol = drive_petrol.destination - drive_petrol.origin,
    difference_drive_GP = drive_GP.destination - drive_GP.origin,
    difference_drive_primary = drive_primary.destination - drive_primary.origin,
    difference_drive_secondary = drive_secondary.destination - drive_secondary.origin,
    difference_drive_post = drive_post.destination - drive_post.origin,
    difference_drive_retail = drive_retail.destination - drive_retail.origin,
    difference_PT_GP = PT_GP.destination - PT_GP.origin,
    difference_PT_post = PT_post.destination - PT_post.origin,
    difference_PT_retail = PT_retail.destination - PT_retail.origin,
    difference_crime_rate = crime_rate.destination - crime_rate.origin,
    difference_income_rate = income_rate.destination - income_rate.origin,
    difference_employment_rate = employment_rate.destination - employment_rate.origin,
    difference_overcrowded_rate = overcrowded_rate.destination - overcrowded_rate.origin,
    difference_nocentralheating_rate = nocentralheating_rate.destination - nocentralheating_rate.origin
    
  )

data_ca <- data_with_location %>%
  inner_join(simd_ca, by = c("Council_area.origin" = "Council_area")) %>%
  inner_join(simd_ca, by = c("Council_area.destination" = "Council_area"),
             suffix = c(".origin", ".destination")) %>%
  select(-contains("count"), 
         -contains("Data_Zone"), 
         -contains("Intermediate"),
         -contains("Council"),
         -contains("population")
  ) %>%
  mutate(
    crime_rate.origin = if_else(is.infinite(crime_rate.origin), 0, crime_rate.origin),
    crime_rate.destination = if_else(is.infinite(crime_rate.destination), 0, crime_rate.destination),
  ) %>%
  mutate(
    difference_drive_petrol = drive_petrol.destination - drive_petrol.origin,
    difference_drive_GP = drive_GP.destination - drive_GP.origin,
    difference_drive_primary = drive_primary.destination - drive_primary.origin,
    difference_drive_secondary = drive_secondary.destination - drive_secondary.origin,
    difference_drive_post = drive_post.destination - drive_post.origin,
    difference_drive_retail = drive_retail.destination - drive_retail.origin,
    difference_PT_GP = PT_GP.destination - PT_GP.origin,
    difference_PT_post = PT_post.destination - PT_post.origin,
    difference_PT_retail = PT_retail.destination - PT_retail.origin,
    difference_crime_rate = crime_rate.destination - crime_rate.origin,
    difference_income_rate = income_rate.destination - income_rate.origin,
    difference_employment_rate = employment_rate.destination - employment_rate.origin,
    difference_overcrowded_rate = overcrowded_rate.destination - overcrowded_rate.origin,
    difference_nocentralheating_rate = nocentralheating_rate.destination - nocentralheating_rate.origin
    
  )


write.csv(data_dz, paste(output_path, "data_dz.csv", sep = ""))
write.csv(data_in, paste(output_path, "data_in.csv", sep = ""))
write.csv(data_ca, paste(output_path, "data_ca.csv", sep = ""))
