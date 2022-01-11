library(tidyverse)
library(gridExtra)

simd_pca <- read.csv("simd_pca.csv")

ggplot(data = simd_pca %>% sample_n(5000))+
  geom_point(aes(x=Component.1, y=Component.2, color = Fare)) +
  scale_colour_viridis_c()+
  labs(x ="Component 1", y= "Component 2", colour = "Fare/£")


ggplot(data = simd_pca %>% sample_n(5000))+
  geom_point(aes(x=Component.1, y=Fare)) +
  labs(x ="Component 1", y= "Fare /£")

grid.arrange(
  ggplot(data = simd_pca %>% sample_n(5000))+
    geom_point(aes(x=Component.1, y=Component.2, color = Fare)) +
    scale_colour_viridis_c()+
    labs(x ="Component 1", y= "Component 2", colour = "Fare/£"),
  
  
  ggplot(data = simd_pca %>% sample_n(5000))+
    geom_point(aes(x=Component.1, y=Fare)) +
    labs(x ="Component 1", y= "Fare /£"),
  
  ncol = 2
)
