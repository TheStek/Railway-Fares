library(tidyverse)
library(ggplot2)
library(gtable)
library(grid)
library(gridExtra)

data <- read.csv("C:/Users/User/Documents/4. Fourth Year/Project/Railway-Fares/Code/3. ML/Test Results.csv")
output_directory <- "C:/Users/User/Documents/4. Fourth Year/Project/Write Up Artifacts/Testing/"

subset_mapping <- tibble(
  code_name = c('dist', 'dist_time', 'dist_remoteness', 'full', 'simd'),
  name = c('Distance', 'Distance + Time', 'Distance + Remoteness', 'Full', 'SIMD'),
  Category = c('Non-SIMD', 'Non-SIMD', 'Non-SIMD', 'SIMD', 'SIMD'),
  Category2 = c('Non-SIMD', 'Non-SIMD', 'Non-SIMD', 'Full', 'SIMD')
  )




data <- data %>%
  inner_join(subset_mapping, by = c("Subset" = "code_name")) %>%
  mutate(Method = paste(Model, name, sep = ' - '),
         MethodCat = paste(Model, Category, sep = ' - '),
         MethodCat2 = paste(Model, Category2, sep = ' - '))



best_models <- ggplot(data = data %>%
         filter(Test.Score > 0.8))+
  geom_boxplot(aes(x = reorder(Method, Test.Score), y = Test.Score, fill = Category), lwd = 0.3,fatten = 0.3, outlier.size = 0.1)+
  coord_flip() +
  xlab("ML Model - Subset")+
  ylab("Test Score")+
  theme(legend.position = "bottom")


ggsave(paste(output_directory, "Test Results.pdf", sep = ''),
       width = 6,
       height = 5,
       units = "in",
       dpi = 500,
       plot = best_models)


summarised_results <- data %>%
  group_by(Subset, Model, n) %>%
  summarise(mean_score = mean(Test.Score), std_score = sd(Test.Score)) %>%
  mutate(se = std_score / sqrt(n),
         ci_width = qt(1 - (0.025 / 2), n - 1) * se,
         lower.ci = mean_score - ci_width,
         upper.ci = mean_score + ci_width)


full_remote <- summarised_results %>%
  filter(Subset == "dist_time" | Subset == "dist_remoteness")

full_remote_difference <- full_remote %>%
  inner_join(full_remote, by = "Model") %>%
  filter(Subset.x == "dist_remoteness")%>%
  mutate(difference = mean_score.x - mean_score.y)


full_remote_difference %>%
  select(Model, mean_score.x, mean_score.y, difference)

dist_remote_full <- ggplot(data = data %>%
         filter(Subset == "full" | Subset == "dist_remoteness")) +
  geom_boxplot(aes(x = reorder(Model, Test.Score), y = Test.Score, fill = name), lwd = 0.3,fatten = 0.3, outlier.size = 0.1)+
  coord_flip()+
  xlab("Model")+
  ylab("Test Score")+
  labs(fill = "Subset")+
  theme(legend.position = "bottom")

ggsave(paste(output_directory, "Dist_remoteness+Full Boxplot.pdf", sep = ''),
       width = 6,
       height = 5,
       units = "in",
       dpi = 500,
       plot = dist_remote_full)



subset_boxplot <- ggplot(data = data)+
  geom_boxplot(aes(x = reorder(name, Test.Score), y = Test.Score, fill = Category), lwd = 0.3,fatten = 0.3, outlier.size = 0.1)+
  coord_flip() +
  xlab("Subset")+
  ylab("Test Score")+
  theme(legend.position = "none")


model_boxplot <- ggplot(data = data)+
  geom_boxplot(aes(x = reorder(Model, Test.Score), y = Test.Score, fill = Category), lwd = 0.3,fatten = 0.3, outlier.size = 0.1)+
  coord_flip() +
  xlab("Model")+
  ylab("Test Score")+
  theme(legend.position = "bottom")

model_subset_boxplots <- grid.arrange(rbind(ggplotGrob(subset_boxplot), ggplotGrob(model_boxplot)))

ggsave(paste(output_directory, "Model+Subset Boxplots.pdf", sep = ''),
       width = 6,
       height =6,
       units = "in",
       dpi = 500,
       plot = model_subset_boxplots)
