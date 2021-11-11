library(tidyverse)

data <- read.csv("C:\\Users\\User\\Documents\\4. Fourth Year\\Project\\Railway-Fares\\Data\\simd2020_withinds.csv")

data <- data %>% rename(Data_Zone  = ï..Data_Zone)


inscope_simd <- data %>%
  select(Data_Zone:Working_Age_population, income_count, employment_count, crime_count, overcrowded_count, nocentralheating_count, drive_petrol:PT_retail) %>%
  mutate(crime_count = as.numeric(na_if(crime_count, '*'))) %>%
  mutate(crime_rate = crime_count / Total_population)

datazone_simd <- inscope_simd %>%
  mutate(income_rate = income_count/Working_Age_population,
         employment_rate = employment_count / Working_Age_population,
         overcrowded_rate = overcrowded_count/Total_population,
         nocentralheating_rate = nocentralheating_count / Total_population,
         crime_rate = crime_count / Total_population
         )

inter_zone_simd <- inscope_simd %>%
  group_by(Intermediate_Zone, Council_area) %>%
  summarise(Total_population = sum(Total_population),
            Working_Age_population = sum(Working_Age_population),
            income_count = sum(income_count),
            employment_count = sum(employment_count),
            overcrowded_count = sum(overcrowded_count),
            nocentralheating_count = sum(nocentralheating_count),
            drive_petrol = mean(drive_petrol),
            drive_GP = mean(drive_GP),
            drive_primary = mean(drive_primary),
            drive_secondary = mean(drive_secondary),
            drive_post = mean(drive_post),
            drive_retail = mean(drive_retail),
            PT_GP = mean(PT_GP),
            PT_post = mean(PT_post),
            PT_retail = mean(PT_retail),
            crime_rate = mean(crime_rate, na.rm = TRUE)
            ) %>%
  mutate(income_rate = income_count/Working_Age_population,
         employment_rate = employment_count / Working_Age_population,
         overcrowded_rate = overcrowded_count/Total_population,
         nocentralheating_rate = nocentralheating_count / Total_population
  )


council_area_SIMD <- inscope_simd %>%
  group_by(Council_area) %>%
  summarise(Total_population = sum(Total_population),
            Working_Age_population = sum(Working_Age_population),
            income_count = sum(income_count),
            employment_count = sum(employment_count),
            overcrowded_count = sum(overcrowded_count),
            nocentralheating_count = sum(nocentralheating_count),
            drive_petrol = mean(drive_petrol),
            drive_GP = mean(drive_GP),
            drive_primary = mean(drive_primary),
            drive_secondary = mean(drive_secondary),
            drive_post = mean(drive_post),
            drive_retail = mean(drive_retail),
            PT_GP = mean(PT_GP),
            PT_post = mean(PT_post),
            PT_retail = mean(PT_retail),
            crime_rate = mean(crime_rate, na.rm = TRUE)
  ) %>%
  mutate(income_rate = income_count/Working_Age_population,
         employment_rate = employment_count / Working_Age_population,
         overcrowded_rate = overcrowded_count/Total_population,
         nocentralheating_rate = nocentralheating_count / Total_population
  )


output_path <- "C:\\Users\\User\\Documents\\4. Fourth Year\\Project\\Railway-Fares\\Data\\Cleansed Data\\"


write.csv(datazone_simd, paste(output_path, "datazone_SIMD.csv", sep = ""))
write.csv(inter_zone_simd, paste(output_path, "intermediate_zone_SIMD.csv", sep = ""))
write.csv(council_area_SIMD, paste(output_path, "council_area_SIMD.csv", sep = ""))
