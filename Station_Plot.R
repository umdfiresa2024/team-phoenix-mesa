library("maptiles")
library("terra")
library("tidyverse")

#city centroid
stations <- read.csv("Coordinates.cvs")

df<-stations |>
  select(lon2, lat2)

#converts df into a spatvector
x <- vect(df, geom=c("lon2", "lat2"), crs="+proj=longlat +ellps=WGS84 +datum=WGS84 +no_defs ")

plot(x)

#check unit of x
crs(x)

#create a 1 km (1000 meter) buffer (radius)
pts_buffer<-buffer(x, width = 400)

plot(pts_buffer)

#approximate size of the background
extent<-buffer(x, width = 400)

bg <- get_tiles(ext(extent))

plot(bg)
points(x)
lines(pts_buffer)