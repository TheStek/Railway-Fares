library(tidyverse)

data_dz <- read.csv("C:\\Users\\User\\Documents\\4. Fourth Year\\Project\\Railway-Fares\\Datasets\\data_dz.csv")
data_in <- read.csv("C:\\Users\\User\\Documents\\4. Fourth Year\\Project\\Railway-Fares\\Datasets\\data_in.csv")



ggplot(data = data_in %>% sample_n(5000))+
  geom_point(aes(x= Distance, FARE))
  
ggplot(data = data_in %>% sample_n(5000))+
  geom_point(aes(x = difference_PT_retail, y= FARE))


cor(data_in)[,"FARE"]
