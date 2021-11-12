library(tidyverse)

fares <- read.csv("C:\\Users\\User\\Documents\\4. Fourth Year\\Project\\Railway-Fares\\Data\\Cleansed Data\\fares.csv")
ticket_types <- read.csv("C:\\Users\\User\\Documents\\4. Fourth Year\\Project\\Railway-Fares\\Data\\Cleansed Data\\ticket_types.csv")

fares_full <- fares %>%
  filter(DIRECTION == 'R') %>%
  mutate(tmp_ORIGIN = DESTINATION_CODE, tmp_DEST = ORIGIN_CODE) %>%
  select(-ORIGIN_CODE, -DESTINATION_CODE) %>%
  rename(ORIGIN_CODE = tmp_ORIGIN, DESTINATION_CODE = tmp_DEST) %>%
  union(fares) %>%
  filter(TICKET_CODE == 'SDS')



fares_full %>%
  inner_join(ticket_types, by = "TICKET_CODE") %>%
  group_by(TICKET_CODE, DESCRIPTION) %>%
  distinct(ORIGIN_CODE, DESTINATION_CODE) %>%
  count() %>%
  arrange(desc(n))

  
recent_single_fares <- fares_full %>%
  group_by(ORIGIN_CODE, DESTINATION_CODE) %>%
  summarise(max_date = max(START_DATE)) %>%
  inner_join(fares_full) %>%
  select(ORIGIN_CODE, DESTINATION_CODE, FARE)


write.csv(recent_single_fares, "C:\\Users\\User\\Documents\\4. Fourth Year\\Project\\Railway-Fares\\Data\\Cleansed Data\\inscope_fares.csv")
  
  