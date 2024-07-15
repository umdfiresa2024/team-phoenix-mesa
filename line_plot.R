library("tidyverse")
library("ggplot2")
library("RColorBrewer")
df<-read.csv("Big_Data.csv")
df2<-df %>% filter(city_num==8 | city_num==27) %>% mutate(date = as.Date(date)) %>% 
  mutate(city_num2 = as.character(paste0(city_num, " line")))

pal<-c("red","blue","lightblue","orange")

ggplot(df2, aes(x=date, y=pm25, group=city_num)) + 
  geom_line(aes(color=as.factor(city_num))) +
  geom_smooth(aes(color=as.factor(city_num2))) +
  geom_vline(xintercept=as.numeric(as.Date("2008-01-01"))) +
  scale_color_manual(values=pal) + theme_bw() + labs(color = "Station Number") +
  xlab("Date") + ylab("PM2.5 Level")
  