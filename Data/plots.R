library(tidyverse)
library(ggthemes)
devtools::install_github("McCartneyAC/mccrr")
library(mccrr)
library(RColorBrewer)
# devtools::install_github("thomasp85/gganimate")
# devtools::install_github("thomasp85/tweenr")
library(gganimate)
library(ggmosaic)
library(extrafont)
library(lubridate)
library(sf)
library(fiftystater)
citation("ggmap")
# setwd("J:\\datasets\\data-school-shootings-master\\")
setwd("V:\\PPOL Lit Review\\Data")
killins<-read_csv("school-shootings-data.csv")
killins <- killins %>% 
  arrange(uid)
shootings<-killins

pal0<-c("indiscriminate" = "#BC80BD",
        "targeted" = "#8DD3C7", 
        "accidental" = "#FDB462", 
        "targeted and indiscriminate" = "#80B1D3",
        "unclear" = "#BEBADA", 
        "accidental or targeted" ="#D9D9D9", 
        "public suicide" = "#B3DE69", 
        "public suicide (attempted)" ="#FFFFB3", 
        "hostage suicide" = "#FCCDE5")
pal2<-c("#FFFFB3", "#8DD3C7","#BC80BD", "#80B1D3", "#BEBADA","#D9D9D9", "#B3DE69","#FDB462", "#FCCDE5")
killins %>% 
  group_by(shooting_type) %>% 
  count()



# visualizations

# incidents by year
killins %>%
  group_by(year) %>% 
  count(shooting_type) %>% 
  ggplot(aes(x = year, y = n, fill = fct_reorder(shooting_type, n))) + 
  geom_col(color="black") + 
  coord_flip()+
  scale_fill_manual(values = pal0) +
  labs(
    title = "School Shootings Since Columbine",
    x = "Year",
    y = "Count of Shootings",
    fill = "Shooting Type",
    caption = "Data Via Washington Post"
  ) + 
  scale_x_continuous(breaks=1999:2018) +
  theme_minimal()+
  guides(color=FALSE) +
  geom_hline(yintercept = 11.0, color = "black") + 
  geom_hline(yintercept = (11.0 + 3.28), color = "gray") +
  geom_hline(yintercept = (11.0 - 3.28), color = "gray") + 
  annotate("text", x = 1999, y = 11, label = "mean = 11       sd = 3.28")


# fatalities by year



killins %>%
  group_by(year, shooting_type) %>% 
  summarize(n = sum(casualties)) %>% 
  ggplot(aes(x = year, y = n, fill = fct_reorder(shooting_type, n))) + 
  geom_col(color="black") + 
  coord_flip()+
  scale_fill_manual(values = pal0) +
  labs(
    title = "School Shootings Since Columbine",
    x = "Year",
    y = "Count of Casualties",
    fill = "Shooting Type",
    caption = "Data Via Washington Post"
  ) + 
  scale_x_continuous(breaks=1999:2018) +
  theme_minimal()+
  guides(color=FALSE) +
  geom_hline(yintercept = 21.4, color = "black") + 
  geom_hline(yintercept = (21.4 + 19.9), color = "gray") +
  geom_hline(yintercept = (21.4 - 19.9), color = "gray") + 
  geom_hline(yintercept = (21.4 + 19.9 + 19.9), color = "gray") + 
  geom_hline(yintercept = (21.4 + 19.9 + 19.9 + 19.9), color = "gray") + 
  annotate("text", x = 2000, y = 21.4, label = "mean = 21.4       sd = 19.9")



killins %>% 
  group_by(year) %>% 
  mutate(mark = row_number()) %>% 
  select(year, casualties, shooting_type, mark) %>% 
  ggplot(aes(x = year, 
             y = mark, 
             alpha = log(casualties + 0.1),
             # alpha = casualties,
             fill = shooting_type)) + 
  geom_tile(color = "black") + 
  geom_text(label = killins$casualties, stat = "identity")+
  scale_fill_manual(values = pal0) +
  scale_x_continuous(breaks=1999:2018) +
  guides(alpha = FALSE) + 
  theme_textbook()+
  theme(axis.title.x = element_blank(),
        axis.text.x = element_blank(),
        axis.ticks.x = element_blank()) + 
  coord_flip() +
  labs(
    title = "School Shootings Since Columbine",
    subtitle = "Count of Killed or Wounded",
    x = "Year",
    y = "",
    fill = "Shooting Type",
    caption = "Data Via Washington Post"
  )



killins %>% 
  filter(year == 2012)

killins %>% 
  filter(casualties > 0) %>% 
  filter(!is.na(shooter_relationship1)) %>% 
  group_by(shooter_relationship1, shooting_type) %>% 
  count() %>% 
  ggplot() + 
  geom_mosaic(aes(weight = n, 
                  x = product(fct_reorder(shooter_relationship1,n)),
                  fill = shooting_type, 
                  color = "black")) + 
  coord_flip() + 
  scale_fill_manual(values = pal0) + 
  labs(
    title = "School Shootings Since Columbine",
    subtitle = "By shooter Relationship and Type",
    x = "Shooter Relationship to School",
    y = "",
    fill = "Shooting Type",
    caption = "Data Via Washington Post"
  )
  

casualties_by_yr_type <- killins %>%
  group_by(year, shooting_type) %>% 
  summarize(casualties_total = sum(casualties)) 

incidents_by_yr_type <- killins %>% 
  group_by(year, shooting_type) %>% 
  count()

incidents_and_casualties <- left_join(
  casualties_by_yr_type, 
  incidents_by_yr_type, 
  by = c("year" = "year", "shooting_type" = "shooting_type")
)



killins %>%
  group_by(shooting_type) %>% 
  summarize(killed = sum(killed)) %>% 
  mutate(shooting_type = fct_reorder(shooting_type, -killed)) %>% 
  filter(killed >= 1) %>% 
  ggplot(aes(x = shooting_type, y = killed, fill = shooting_type)) +
  geom_col(color="black") +
  coord_flip() +
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
  scale_fill_manual(values = pal0) +
  labs(
    title="Killed and Wounded by Shooting Type",
    y = "Casualties",
    x = "",
    caption = "Data Via Washington Post"
  ) + 
  guides(fill = FALSE)




sources<-paste_data()

sources %>% 
  group_by(source) %>% 
  count() %>% 
  ggplot(aes(x = fct_reorder(source,n), y = n, fill = source)) + 
  geom_col() + 
  coord_flip() + 
  scale_fill_manual(values = pal2) + 
  labs(
    title="Source of Weapons used in Shootings",
    y = "Number",
    x = "Source",
    caption = "Data Via Washington Post"
  ) + 
  guides(fill = FALSE)



######## MAP -----------------------
# ?geocode()
# killins <- killins %>% 
#   mutate(location = paste(city, state)) %>% 
#   mutate_geocode(location, source = "dsk")
# use lon.1, lat.2
names(killins)
killins <- killins %>%
  mutate(longitude = long) %>% 
  mutate(latitude = lat) %>% 
  filter(state_fips != 15)
killins %>% 
  select(latitude, longitude) %>% 
  filter(latitude < 140) %>% 
  head()
# map <-
#   get_map(
#     location = "United States",
#     zoom = 4,
#     # source = "osm",
#     maptype = "toner"
#   )



library(fiftystater)

data("fifty_states")
as_tibble(fifty_states)
st_as_sf(fifty_states, coords = c("long", "lat"))
st_as_sf(fifty_states, coords = c("long", "lat")) %>% 
  # convert sets of points to polygons
  group_by(id, piece) %>% 
  summarize(do_union = FALSE) %>%
  st_cast("POLYGON")
# convert fifty_states to an sf data frame
(sf_fifty <- st_as_sf(fifty_states, coords = c("long", "lat")) %>% 
    # convert sets of points to polygons
    group_by(id, piece) %>% 
    summarize(do_union = FALSE) %>%
    st_cast("POLYGON") %>%
    # convert polygons to multipolygons for states with discontinuous regions
    group_by(id) %>%
    summarize())
st_crs(sf_fifty) <- 4326



killins$date<-mdy(killins$date)


ggplot(data = sf_fifty) +
  geom_sf() +
  geom_point(data = killins,
             aes(
               y = latitude,
               x = longitude,
               color = shooting_type,
               size = casualties
             ))  + 
  scale_color_manual(values = pal0) + 
    guides(size = FALSE) +
  transition_time(killins$date) +
  # transition_reveal(killins$year) + 
  ease_aes('linear') +
  enter_grow() +
  shadow_mark(past = TRUE, future = FALSE)+
  labs(
    title = "School Shootings in US by Type",
    subtitle = "Date: {frame_time}",
    caption = "Data via Washington Post"
  )

anim_save("shootings_over_time.gif")

# facet geography by type:
ggplot(data = sf_fifty) +
  geom_sf() +
  geom_point(data = killins,
             aes(
               y = latitude,
               x = longitude,
               color = shooting_type,
               size = casualties
             ))  + 
  scale_color_manual(values = pal0) + 
  guides(size = FALSE) +
  facet_wrap(~shooting_type) +
  labs(
    title = "School Shootings in US by Type",
    caption = "Data via Washington Post"
  )



# map_animation <- ggmap(map) +
#   geom_point(data = killins,
#              aes(
#                y = latitude,
#                x = longitude,
#                color = shooting_type,
#                size = casualties
#              )) + 
#   scale_color_manual(values = pal)
# transition_time(year) +
#   ease_aes('linear') +
#   enter_fade() +
#   exit_fade()

map_animation

names(killins)
# statistics amd descriptive data
summary(lm(casualties~year, data = killins))

killins %>% 
  group_by(year) %>% 
  tally() %>% 
  summarize(mu = mean(n), sigma = sd(n))

killins %>% 
  group_by(year) %>% 
  summarize(n = sum(casualties)) %>% 
  summarize(mu = mean(n), sigma = sd(n))

model1data<-killins %>% 
  group_by(year) %>% 
  count()
summary(lm(n~year, data=model1data))
