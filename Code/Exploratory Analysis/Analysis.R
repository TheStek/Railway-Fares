library(tidyverse)

data_dz <- read.csv("C:\\Users\\User\\Documents\\4. Fourth Year\\Project\\Railway-Fares\\Datasets\\data_dz.csv")
data_in <- read.csv("C:\\Users\\User\\Documents\\4. Fourth Year\\Project\\Railway-Fares\\Datasets\\data_in.csv")



ggplot(data = data_in %>% sample_n(5000))+
  geom_point(aes(x= Distance, FARE))
  
ggplot(data = data_in %>% sample_n(5000))+
  geom_point(aes(x = difference_PT_retail, y= FARE))


corr_mat <- round(cor(select(data_in, -ORIGIN_CODE, -DESTINATION_CODE)), 3)

library(reshape2)
melted_cormat <- melt(corr_mat)

ggplot(data = melted_cormat %>% filter(value >=0.5), aes(x=Var1, y=Var2, fill=value)) + 
  geom_tile()
