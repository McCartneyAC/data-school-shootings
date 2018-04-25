library(tidyverse)
library(ggthemes)
setwd("V:\\datasets\\data-school-shootings-master\\")
killins<-read_csv("V:\\datasets\\data-school-shootings-master\\school-shootings-data.csv")

pal<-("")


killins %>%
  group_by(year) %>% 
  count(shooting_type) %>% 
  ggplot(aes(x = year, y = n, fill = fct_reorder(shooting_type, -n))) + 
  geom_col() + 
  coord_flip()+
  scale_fill_brewer(palette="Set3") +
  labs(
    title = "Fatalities from School Shootings Since Columbine",
    x = "Year",
    y = "Count of Shootings",
    fill = "Shooting Type",
    caption = "Data Via Washington Post"
  ) + 
  theme_few()
