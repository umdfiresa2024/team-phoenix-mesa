library("terra")
library("tidyverse")

pts_buffer <- vect("buffer.shp")

path<-"G:/Shared drives/2024 FIRE Light Rail/DATA/PM25/"
months<-dir(path)
# for each month
for (m in 1:length(months)) {
  print(months[m])
  days<-dir(paste0(path,months[m]))
  
  # for each day in this month
  days_output<-c()
  for (d in 1:length(days)) {
    print(days[d])
    
    #read tif file
    r<-rast(paste0(path, months[m], "/", days[d]))
    
    #changes the crs system
    buffer_project<-terra::project(pts_buffer,  crs(r))
    
    #pts_buffer is the buffer around stations
    #crops raster to contain only buffers around stations
    int<-crop(r, buffer_project,
              snap="in",
              mask=TRUE)
    
    #convert cropped raster into dataframe and fine average value
    cntrl_df<-terra::extract(int, buffer_project, fun="mean", na.rm=TRUE)
    
    #rename columns
    names(cntrl_df)<-c("city_num","pm25")
    
    #create a dataframe date, shape index, and pm25
    output <- as.data.frame(c("date"=days[d], cntrl_df))
    
    #combine output with previous looop
    days_output<-rbind(days_output, output)
   
    
  }
  write.csv(days_output, 
            paste0("PM25_daily/lr_centroid_",
                   months[m],
                   ".csv")
            , row.names = F)
  
}

