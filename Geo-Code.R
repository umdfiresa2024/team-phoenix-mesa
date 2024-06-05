library("tidyverse")
library("ggmap")
c<-read.csv("Phoenix-Mesa stations and dates - Sheet1.csv",header=F)
c2<-c %>%
  mutate(Station= paste(V1,"Station,Phoenix"))
register_google(key = "AIzaSyBFzZRvnnrYw2l5CQRrbBnPZt2-EIAsiD8", write = TRUE)

addr.geo <- mutate_geocode(c2,location=Station,output="latlona")

geo<-addr.geo %>%
  mutate(lat2=ifelse(Station=="Priest Dr/Washington Station,Phoenix", 33.442, lat))

geo<-geo %>%
  mutate(lon2=ifelse(Station=="Priest Dr/Washington Station,Phoenix", -111.956, lon))


geo<-geo %>%
  mutate(lat2=ifelse(Station=="Mill Ave/3rd St Station,Phoenix", 33.427, lat2))

geo<-geo %>%
  mutate(lon2=ifelse(Station=="Mill Ave/3rd St Station,Phoenix", -111.94, lon2))


geo<-geo %>%
  mutate(lat2=ifelse(Station=="Veteran's Way/College Station,Phoenix", 33.426, lat2))

geo<-geo %>%
  mutate(lon2=ifelse(Station=="Veteran's Way/College Station,Phoenix", -111.936, lon2))


geo<-geo %>%
  mutate(lat2=ifelse(Station=="Price-101 Fwy/Apache Blvd Station,Phoenix", 33.415, lat2))

geo<-geo %>%
  mutate(lon2=ifelse(Station=="Price-101 Fwy/Apache Blvd Station,Phoenix", -111.888, lon2))


geo<-geo %>%
  mutate(lat2=ifelse(Station=="Sycamore/Main St Station,Phoenix", 33.415, lat2))

geo<-geo %>%
  mutate(lon2=ifelse(Station=="Sycamore/Main St Station,Phoenix", -111.870, lon2))

