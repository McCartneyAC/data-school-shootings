library(tidyverse)
library(ggthemes)
setwd("J:\\datasets\\data-school-shootings-master\\")
killins<-read_csv("school-shootings-data.csv")

pal<-("")

# visualizations
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
  scale_x_continuous(breaks=1999:2018) +
  theme_few()+
  guides(color=FALSE)
?scale_x_continuous
  
  
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


killins %>%
  group_by(shooting_type) %>% 
  summarize(casualties = sum(casualties)) %>% 
  mutate(shooting_type = fct_reorder(shooting_type, -casualties)) %>% 
  filter(casualties >= 1) %>% 
  ggplot(aes(x = shooting_type, y = casualties, fill = shooting_type)) +
  geom_col(color="black") +
  coord_flip() +
  scale_fill_brewer(palette="Set3")+
  labs(
    title="Killed and Wounded by Shooting Type",
    y = "Casualties",
    x = "",
    caption = "Data Via Washington Post"
  ) + 
  theme_few() +
  guides(fill = FALSE)


# statistics amd descriptive data
summary(lm(casualties~year, data = killins))

killins %>% 
  group_by(year) %>% 
  tally() %>% 
  summarize(mu = mean(n), sigma = sd(n))

killins %>% 
  group_by(year) %>% 
  tally()

model1data<-killins %>% 
  group_by(year) %>% 
  count()
summary(lm(n~year, data=model1data))
