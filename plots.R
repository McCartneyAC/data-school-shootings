library(tidyverse)
library(ggthemes)
setwd("V:\\datasets\\data-school-shootings-master\\")
killins<-read_csv("V:\\datasets\\data-school-shootings-master\\school-shootings-data.csv")

pal<-("")


killins %>%
  group_by(year) %>% 
  count(shooting_type) %>% 
  ggplot(aes(x = year, y = n, fill = fct_reorder(shooting_type, -n))) + 
  geom_col(color="black") + 
  coord_flip()+
  scale_fill_brewer(palette="Set3") +
  labs(
    title = "School Shootings Since Columbine",
    x = "Year",
    y = "Count of Shootings",
    fill = "Shooting Type",
    caption = "Data Via Washington Post"
  ) + 
  theme_few()+
  guides(color=FALSE)

killins %>%
  group_by(shooting_type) %>% 
  summarize(killed = sum(killed)) %>% 
  mutate(shooting_type = fct_reorder(shooting_type, -killed)) %>% 
  filter(killed >= 1) %>% 
  ggplot(aes(x = shooting_type, y = killed, fill = shooting_type)) +
  geom_col(color="black") +
  coord_flip() +
  scale_fill_brewer(palette="Set3")+
  labs(
    title="Fatalities by Shooting Type",
    y = "Fatalities",
    x = "",
    caption = "Data Via Washington Post"
  ) + 
  theme_few() +
  guides(fill = FALSE)

summary(lm(killed~year, data = killins))
