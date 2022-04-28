library(tidyverse)
library(reshape2)

data <- read.csv("C:/Users/User/Documents/4. Fourth Year/Project/Railway-Fares/Code/3. ML/Train Data.csv") %>%
  select(-contains("difference"))

cor(data)

melted_cormat <- melt(cor(data))

ggplot(data = melted_cormat, aes(x = Var1, y=Var2, fill = value))+
  geom_raster()+
  scale_fill_viridis_c()+
  theme(axis.text.x=element_blank(), #remove x axis labels
        axis.ticks.x=element_blank(), #remove x axis ticks
        #axis.text.y=element_blank(),  #remove y axis labels
        #axis.ticks.y=element_blank()  #remove y axis ticks
  )

