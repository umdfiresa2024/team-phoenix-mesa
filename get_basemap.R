library("maptiles")
library("terra")

buff<-vect("buffer.shp")

#list of providers https://cran.r-project.org/web/packages/maptiles/maptiles.pdf
#https://github.com/riatelab/maptiles?tab=readme-ov-file

#get background map
bg <- get_tiles(ext(buff),provider = "Esri.NatGeoWorldMap", crop = TRUE)

plot(bg)
plot(buff, add=TRUE)
