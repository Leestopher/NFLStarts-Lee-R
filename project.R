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
topqbr <- read.csv("data/topqbr.csv")

glimpse(starts)

abbr <- starts %>% group_by(Team) %>%
    summarise(count = n())

view(abbr)

topqb <- starts %>% group_by(Team, Player) %>%
    count(Player, name = "TotalStarts") %>%
    group_by(Team) %>%
    slice(which.max(TotalStarts))

TotalQbs <- starts %>%
    group_by(Team) %>%
    summarise(TotalQBs = n_distinct(Player))

team <- merge(team, TotalQbs, by = "Team")

write.csv(topqb, "data/topqb.csv")

#Not much for this one, huh? Maybe a small + correlation, but not much.  Darn.
topqbr %>% ggplot(aes(TotalStarts, QBR)) +
    geom_point()

teamqb <- merge(team, topqbr, by = "Team")

glimpse(teamqb)

teamqb <- teamqb %>% mutate(WL = W / (W+L))

#A bit more correlation here.. 5 of the top 6 QB's have above .500
teamqb %>% ggplot(aes(TotalStarts, WL)) +
    geom_point() +
    scale_y_log10()

teamqb %>% ggplot(aes(TotalStarts, TD)) +
    geom_point() +
    scale_y_log10()

teamqb %>% ggplot(aes(TotalStarts, PPG)) +
    geom_point() +
    scale_y_log10()

teamqb %>% ggplot(aes(TotalStarts, OPP.PPG)) +
    geom_point() +
    scale_y_log10()

teamqb %>% ggplot(aes(TotalQBs, TD)) +
    geom_point() +
    scale_y_log10()

teamqb %>% ggplot(aes(QBR, TD)) +
    geom_point()

teamqb %>% ggplot(aes(QBR, WL)) +
    geom_point()
