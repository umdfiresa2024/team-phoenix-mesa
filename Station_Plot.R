library("maptiles")
library("terra")
library("tidyverse")
library("ggplot2")
library("dplyr")
#city centroid
stations <- read.csv("Coordinates.csv")
sources <- read.csv("Poll_Coordinates.csv")

df<- stations %>%
  select(lon2,lat2)

df2<- sources %>%
  filter(Source != "SOURCE Arizona") %>%
  select(lon2,lat2)

#converts df into a spatvector
x <- vect(df, geom=c("lon2", "lat2"), crs="+proj=longlat +ellps=WGS84 +datum=WGS84 +no_defs ")
y <- vect(df2, geom=c("lon2", "lat2"), crs="+proj=longlat +ellps=WGS84 +datum=WGS84 +no_defs ")

plot(x)
plot(y)


#create a 1 km (1000 meter) buffer (radius)
pts_buffer<-buffer(x, width = 400)

plot(pts_buffer)

#approximate size of the background
extent<-buffer(x, width = 400)

bg <- get_tiles(ext(extent))

plot(bg)

#plotting the Stations and their buffers ,as well as sources of pollution
lines(pts_buffer)
points(x, col = "red")
points(y, col = "blue")

outfile <- "buffer.shp"
writeVector(pts_buffer, outfile, overwrite=TRUE)
