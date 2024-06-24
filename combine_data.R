library("tidyverse")
setwd("PM25_daily")
file_list <- list.files()

dataset<-data.frame()

for (file in file_list){
    temp_dataset <-read.csv(file)
    dataset<-rbind(dataset, temp_dataset)
    rm(temp_dataset)
}
setwd("..")
stations<-read.csv("Coordinates.csv")
merge1<-merge(dataset,stations, by.x = "city_num", by.y = "X")
newdates <- gsub("(....)(..)(..)(\\.tif)", "\\1-\\2-\\3", merge1$date)
merge1$date <- as.Date(newdates)
holidays <- read.csv("major_holidays_2000_2025.csv")
is_holiday <- newdates %in% holidays$date
merge1$is_holiday <- is_holiday
merge1$dow <- weekdays(merge1$date)
merge1$month <- format(merge1$date, "%m")
dfm<-read.csv("met_data.csv")
newdates2 <- as.Date(gsub("(....)(..)(..)(\\.020\\.nc4)", "\\1-\\2-\\3", dfm$date))
dfm$date <- newdates2
merge2<-merge(merge1, dfm, by.x="date", by.y="date")

write.csv(merge2, "Big_Data.csv")
