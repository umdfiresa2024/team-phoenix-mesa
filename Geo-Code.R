library("tidyverse")
library("ggmap")
c<-read.csv("Phoenix-Mesa stations and dates - Sheet1.csv",header=F)
c2<-c %>%
  mutate(Station= paste(V1,"Station,Phoenix"))
register_google(key = "AIzaSyCA9_G1smyPrHEIa92k1IF0dwBsAGFCNXM", write = TRUE)

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


write.csv(geo, "Coordinates.cvs")

poll<-read.csv("Pollution Sources for Phoenix-Mesa - Sheet1.csv",header=F)

poll2<-poll %>%
  mutate(Source= paste(V1,"Arizona"))
register_google(key = "AIzaSyCA9_G1smyPrHEIa92k1IF0dwBsAGFCNXM", write = TRUE)

poll.geo <- mutate_geocode(poll2,location=Source,output="latlona")


geo2<-poll.geo %>%
  mutate(lat2=ifelse(Source=="Intersection of Interstate 17 & Interstate 10 Arizona", 33.461843, lat))

geo2<-geo2 %>%
  mutate(lon2=ifelse(Source=="Intersection of Interstate 17 & Interstate 10 Arizona", -112.108286, lon))


geo2<-geo2 %>%
  mutate(lat2=ifelse(Source=="Intersection of Interstate 10 & U.S. 60 Arizona", 33.388009, lat2))

geo2<-geo2 %>%
  mutate(lon2=ifelse(Source=="Intersection of Interstate 10 & U.S. 60 Arizona", -111.967622, lon2))


geo2<-geo2 %>%
  mutate(lat2=ifelse(Source=="Palo Verde Nuclear generation Station Arizona", 33.38800, lat2))

geo2<-geo2 %>%
  mutate(lon2=ifelse(Source=="Palo Verde Nuclear generation Station Arizona", -112.8617, lon2))

geo2<-geo2 %>%
  mutate(lat2=ifelse(Source=="Arlington Valley Plant Arizona", 33.3417, lat2))

geo2<-geo2 %>%
  mutate(lon2=ifelse(Source=="Arlington Valley Plant Arizona", -112.8897, lon2))


geo2<-geo2 %>%
  mutate(lat2=ifelse(Source=="Gila River Generating Station Arizona", 32.975, lat2))

geo2<-geo2 %>%
  mutate(lon2=ifelse(Source=="Gila River Generating Station Arizona", -112.6944, lon2))


geo2<-geo2 %>%
  mutate(lat2=ifelse(Source=="Kyrene Power Plant Arizona", 33.3556, lat2))

geo2<-geo2 %>%
  mutate(lon2=ifelse(Source=="Kyrene Power Plant Arizona", -111.9353, lon2))

geo2<-geo2 %>%
  mutate(lat2=ifelse(Source=="Mesquite Power Plant Arizona", 33.345, lat2))

geo2<-geo2 %>%
  mutate(lon2=ifelse(Source=="Mesquite Power Plant Arizona", -112.8642, lon2))

geo2<-geo2 %>%
  mutate(lat2=ifelse(Source=="Santan Power Plant Arizona", 33.3325, lat2))

geo2<-geo2 %>%
  mutate(lon2=ifelse(Source=="Santan Power Plant Arizona", -111.7503, lon2))


geo2<-geo2 %>%
  mutate(lat2=ifelse(Source=="West Phoenix Power Plant Arizona", 33.4417, lat2))

geo2<-geo2 %>%
  mutate(lon2=ifelse(Source=="West Phoenix Power Plant Arizona", -112.1583, lon2))


write.csv(geo2, "Poll_Coordinates.cvs")







