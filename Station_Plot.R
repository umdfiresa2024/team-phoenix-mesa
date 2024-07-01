library("maptiles")
library("terra")
library("tidyverse")
library("ggplot2")
library("dplyr")
#city centroid
stations <- read.csv("Coordinates.csv")
sources <- read.csv("Poll_Coordinates.csv")
<<<<<<< HEAD
=======

df_station <- stations %>%
  select(lon2,lat2)
  
df2<- sources %>%
  filter(Source != "SOURCE Arizona") %>%
  select(lon2,lat2)

Coor_Combined<-rbind(df_station,df2)

  
xprime <-vect(Coor_Combined, geom=c("lon2", "lat2"), crs="+proj=longlat +ellps=WGS84 +datum=WGS84 +no_defs ")

plot(xprime)

>>>>>>> 5f4063ed4a814f5fe0d6ce4aab07a4c106286784



#converts df into a spatvector
x <- vect(df_station, geom=c("lon2", "lat2"), crs="+proj=longlat +ellps=WGS84 +datum=WGS84 +no_defs ")
#y <- vect(df2, geom=c("lon2", "lat2"), crs="+proj=longlat +ellps=WGS84 +datum=WGS84 +no_defs ")

#ggplot(df_station,aes(x=lon2,y=lat2,color="Station"))+geom_point()


#plot(x)
#plot(y)

#check unit of x
crs(x)

#create a 1 km (1000 meter) buffer (radius)
pts_buffer<-buffer(xprime, width = 400)

#plot(pts_buffer)

#approximate size of the background
extent<-buffer(x, width = 400)

bg <- get_tiles(ext(extent))

plot(bg)

<<<<<<< HEAD

#points(x)
lines(pts_buffer)
points(x, col = "red")
=======
#plot(x)
lines(pts_buffer)
points(xprime, col = "red")
>>>>>>> 5f4063ed4a814f5fe0d6ce4aab07a4c106286784

#outfile <- "buffer.shp"
#writeVector(pts_buffer, outfile, overwrite=TRUE)
