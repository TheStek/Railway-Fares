library(tidyverse)

data <- read.csv("C:/Users/User/Documents/4. Fourth Year/Project/Railway-Fares/Code/3. ML/Test Results.csv")


subset_mapping <- tibble(
  code_name = c('dist', 'dist_time', 'dist_remoteness', 'full', 'simd'),
  name = c('Distance', 'Distance + Time', 'Distance + Remoteness', 'Full', 'SIMD'),
  Category = c('Non-SIMD', 'Non-SIMD', 'Non-SIMD', 'SIMD', 'SIMD'))




data <- data %>%
  inner_join(subset_mapping, by = c("Subset" = "code_name")) %>%
  mutate(Method = paste(Model, name, sep = ' - '))




ggplot(data = data %>%
         filter(Test.Score > 0.00))+
  geom_boxplot(aes(x = reorder(Method, Test.Score), y = Test.Score, fill = Category, color = Category))+
  coord_flip() +
  xlab("ML Model - Subset")+
  ylab("Test Score")
