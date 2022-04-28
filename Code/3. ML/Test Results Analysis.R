library(tidyverse)

data <- read.csv("C:/Users/User/Documents/4. Fourth Year/Project/Railway-Fares/Code/3. ML/Test Results.csv")


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



ggplot(data = data %>%
         filter(Test.Score > 0.9))+
  geom_boxplot(aes(x = reorder(Method, Test.Score), y = Test.Score, fill = Category, color = Category))+
  coord_flip() +
  xlab("ML Model - Subset")+
  ylab("Test Score")+
  theme(legend.position = "bottom",
        text = element_text(size = 10))


ggplot(data = data %>%
         filter(Subset != "simd"))+
  geom_boxplot(aes(x = Category, y = Test.Score, fill = Category))+
  coord_flip()+
  xlab("Subset Category")+
  ylab("Test Score")


ggplot(data = data %>%
         filter(Subset != "simd"))+
  geom_boxplot(aes(x = Method, y = Test.Score, fill = Category))+
  coord_flip()+
  xlab("Method - Subset Category")+
  ylab("Test Score")



ggplot(data = data %>%
         filter(Subset != "simd", Subset != "dist", Subset != "dist_time"))+
  geom_boxplot(aes(x = MethodCat2, y = Test.Score, fill = Category2))+
  coord_flip()+
  xlab("Method - Subset Category")+
  ylab("Test Score")+
  scale_fill_manual(values = c("#00BFC4", "#F8766D"))


ggplot(data = data %>%
         filter(Subset == "full" | Subset == "dist_remoteness"))+
  geom_boxplot(aes(x = reorder(Method, Test.Score), y = Test.Score, fill = Category))+
  coord_flip()+
  xlab("Method - Subset Category")+
  ylab("Test Score")


data %>%
  filter(Subset == "simd") %>%
  group_by(Method) %>%
  summarise(m = mean(Test.Score))


ggplot(data = data %>%
         filter(Subset == "full" | Subset == "dist_remoteness")) +
  geom_boxplot(aes(x = reorder(name, Test.Score), y = Test.Score, fill = Category))+
  coord_flip()+
  xlab("Subset")+
  ylab("Test Score")+
  theme(legend.position = "bottom",
        text = element_text(size = 15))


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
