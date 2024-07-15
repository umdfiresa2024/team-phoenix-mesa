library("maptiles")
library("terra")

c1<-vect("buffer.shp")

c2<-subset(c1, c1$FID>0 & c1$FID<28)
c1df<-as.data.frame(c1)

coef2<-c(coef)*100
coefdf<-as.data.frame(coef2)
cities_coef<-cbind(c2, coefdf)

sources <- read.csv("Poll_Coordinates.csv")
dfy<- sources %>%
  filter(Source != "SOURCE Arizona") %>%
  select(lon2,lat2)
y <- vect(dfy, geom=c("lon2", "lat2"), crs="+proj=longlat +ellps=WGS84 +datum=WGS84 +no_defs ")


#list of providers https://cran.r-project.org/web/packages/maptiles/maptiles.pdf
#https://github.com/riatelab/maptiles?tab=readme-ov-file

bgext<-buffer(c2, width=9000)

#get background map
bg <- get_tiles(ext(bgext),provider = "Esri.WorldShadedRelief", crop = TRUE)

#png(filename="regression_map.png", width=1000, height=700, units="px")

plot(bg)

plot(cities_coef,
     "coef2",
     type="interval",
     breaks=c(-10, -5, 0, 5, 10, 15, 20),
     col=map.pal("gyr"),add=TRUE, legend="topright", plg=list(cex=3))


points(y, col = "blue", cex=3)

#dev.off()
