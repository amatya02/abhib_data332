install.packages("kableExtra")
install.packages("here")
# load libraries
library(dplyr)
library(ggplot2)
library(readxl)
library(tidyr)
library(tidyverse)
library(here)
library(kableExtra)

rm(list=ls())
setwd("~/Documents/r_projects/fish")
fish <- read_csv(here("fish.csv"))
kelp_abur <- read_excel("kelp_fronds.xlsx", sheet="abur")

fish_garibaldi <- fish %>%
  dplyr::filter(common_name == "garibaldi")

fish_mohk <- fish %>%
  dplyr::filter(site=="mohk")

fish_over50 <- fish %>%
  dplyr::filter(total_count>=50)

fish_tsp <- fish %>%
  filter(common_name=="garibaldi"|
           common_name=="blacksmith"|
           common_name=="black surfperch"
  )
fish_3sp <- fish %>%
  dplyr::filter(common_name %in% c ("garibaldi", "blacksmith", "black surfperch"))

fish_gar_2016 <- fish %>%
  dplyr::filter(year==2016 | common_name == "garibaldi")

aque_2018 <- fish %>% 
  filter(year == 2018, site == "aque")

aque_2018 <- fish %>% 
  filter(year == 2018 & site == "aque")

aque_2018 <- fish %>% 
  filter(year == 2018) %>% 
  filter(site == "aque")

fish_bl <- fish %>% 
  filter(str_detect(common_name, pattern = "black"))

fish_it <- fish %>% 
  filter(str_detect(common_name, pattern = "it"))

abur_kelp_fish <- kelp_abur %>% 
  full_join(fish, by = c("year", "site")) 

kelp_fish_left <- kelp_abur %>% 
  left_join(fish, by = c("year","site"))

kelp_fish_injoin <- kelp_abur %>% 
  inner_join(fish, by = c("year", "site"))
