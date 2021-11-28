library(dplyr)
library(tidyverse)
library(sf)
library(jsonlite)
library(USAboundaries)
library(leaflet)
library(tibbletime)
library(ggthemes)
library(scales)
library(ggplot2)

httpgd::hgd()
httpgd::hgd_browse()

starts <- read.csv("data/Starts.csv")
team <- read.csv("data/TeamStats.csv")

glimpse(starts)

abbr <- starts %>% group_by(Team) %>%
    summarise(count = n())

view(abbr)

topqb <- starts %>% group_by(Team, Player) %>%
    count(Player, name="TotalStarts") %>%
    group_by(Team) %>%
    slice(which.max(TotalStarts))

write.csv(topqb, "data/topqb.csv")
