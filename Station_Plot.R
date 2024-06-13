library("maptiles")
library("terra")
library("tidyverse")

#city centroid
stations <- read.csv("Coordinates.cvs")
sources <- read.csv("Poll_Coordinates.cvs")

df<-stations |>
  select(lon2, lat2)

df2<-sources |>
  select(lon2, lat2)

#converts df into a spatvector
x <- vect(df, geom=c("lon2", "lat2"), crs="+proj=longlat +ellps=WGS84 +datum=WGS84 +no_defs ")
y <- vect(df2, geom=c("lon2", "lat2"), crs="+proj=longlat +ellps=WGS84 +datum=WGS84 +no_defs ")

plot(x)
plot(y)

#check unit of x
crs(x)

#create a 1 km (1000 meter) buffer (radius)
pts_buffer<-buffer(x, width = 400)

plot(pts_buffer)

#approximate size of the background
extent<-buffer(x, width = 400)

bg <- get_tiles(ext(extent))

plot(bg)

plot(x)
#points(x)
lines(pts_buffer)
points(y, col = "red")

outfile <- "buffer.shp"
writeVector(pts_buffer, outfile, overwrite=TRUE)
