library(terra)
library(tidyverse)
files<-dir("G:/Shared drives/2024 FIRE Light Rail/DATA/GLDAS/")

for(i in 1822:4384){
  r<-rast(paste0("G:/Shared drives/2024 FIRE Light Rail/DATA/GLDAS/", files[i]))
  
  sta<-vect("buffer.shp")
  
  #crops raster to contain only buffers around stations
  int<-crop(r, sta,
            snap="in",
            mask=TRUE)
  
  #convert cropped raster into dataframe and fine average value
  metdf<-terra::extract(int, sta, fun="mean", na.rm=TRUE)  %>%
    summarise(across(where(is.numeric), ~ mean(.x, na.rm = TRUE))) %>%
    select(-ID)
  
  metdf$date<-files[i]
  print(files[i])
}

write.csv(metdf, "met_data.csv", row.names=F)
