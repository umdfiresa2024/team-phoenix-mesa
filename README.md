# Progress Report
William & Sebastian

## Research Question

- What is the impact of air pollution caused by light rail stations on
  demographics in Phoenix and Mesa?

## Hypothesis

- The Light Rail in Phoenix-Mesa should help alleviate the amount of
  PM2.5 being released into the air, helping decrease air quality
  diseases around the area. Phoenix-Mesa has seen an increase in
  population, it has had a 16.31% increase in population from 2004 to
  2012, increasing further as the years progressed. this increase in
  population is enough to congest roads and increase the demand for
  power to provide to the citizens. All of this can increase the levels
  of PM2.5. the light rail will help alleviate the by delivering faster,
  community transportation that would decrease the number of cars in the
  streets. With fewer cars in the streets, roads can help decongest
  faster. So Overall, the impact of the light rail on air pollution in
  the Phoenix-Mesa region (Maricopa County) will increase as more people
  use the light rail, further reducing one of their biggest contributors
  of PM2.5 pollution.

## Data

``` r
library("tidyverse") 
library("knitr") 
library("terra") 
library("maptiles")
```

- Timeline of interest

  - Given the time frame of the data we have access to from NASA, the
    only stations that existed then all opened on December 27th, 2008.
    We want to track the pollution in an equal timeframe before and
    after the opening, so we chose the timeframe of January 1st, 2004 to
    January 1st, 2012

- Station locations

  - We used a Google API key to collect the coordinates of each of these
    stations, manually collecting the few that Google didn’t
    automatically find.

    ``` r
    c<-read.csv("Coordinates.csv") %>%   
      select(Station, lat2, lon2) 
    kable(c)
    ```

    | Station                                   |     lat2 |      lon2 |
    |:------------------------------------------|---------:|----------:|
    | 19th Ave/Montebello Station,Phoenix       | 33.52060 | -112.0997 |
    | 19th Ave/Camelback Station,Phoenix        | 33.50954 | -112.0988 |
    | 7th Ave/Camelback Station,Phoenix         | 33.50931 | -112.0833 |
    | Central Ave/Camelback Station,Phoenix     | 33.50886 | -112.0739 |
    | Campbell/Central Ave Station,Phoenix      | 33.50095 | -112.0738 |
    | Indian School/Central Ave Station,Phoenix | 33.49575 | -112.0738 |
    | Osborn/Central Ave Station,Phoenix        | 33.48685 | -112.0738 |
    | Thomas/Central Ave Station,Phoenix        | 33.48123 | -112.0738 |
    | Encanto/Central Ave Station,Phoenix       | 33.47365 | -112.0738 |
    | McDowell/Central Ave Station,Phoenix      | 33.46497 | -112.0738 |
    | Roosevelt/Central Ave Station,Phoenix     | 33.45934 | -112.0739 |
    | Van Buren/Central Ave Station,Phoenix     | 33.45114 | -112.0737 |
    | Washington/Central Ave Station,Phoenix    | 33.44889 | -112.0739 |
    | 3rd St/Washington Station,Phoenix         | 33.44835 | -112.0706 |
    | 12th St/Washington Station,Phoenix        | 33.44825 | -112.0573 |
    | 24th St/Washington Station,Phoenix        | 33.44819 | -112.0293 |
    | 38th St/Washington Station,Phoenix        | 33.44810 | -111.9999 |
    | 44th St/Washington Station,Phoenix        | 33.44818 | -111.9879 |
    | 50th St/Washington Station,Phoenix        | 33.44698 | -111.9753 |
    | Priest Dr/Washington Station,Phoenix      | 33.44200 | -111.9560 |
    | Center Pkwy/Washington Station,Phoenix    | 33.43806 | -111.9466 |
    | Mill Ave/3rd St Station,Phoenix           | 33.42700 | -111.9400 |
    | Veteran’s Way/College Station,Phoenix     | 33.42600 | -111.9360 |
    | University Dr/Rural Rd Station,Phoenix    | 33.42073 | -111.9270 |
    | Dorsey/Apache Blvd Station,Phoenix        | 33.41477 | -111.9169 |
    | McClintock/Apache Blvd Station,Phoenix    | 33.41474 | -111.9083 |
    | Smith-Martin/Apache Blvd Station,Phoenix  | 33.41479 | -111.9008 |
    | Price-101 Fwy/Apache Blvd Station,Phoenix | 33.41500 | -111.8880 |
    | Sycamore/Main St Station,Phoenix          | 33.41500 | -111.8700 |

- Factors that impact PM2.5 in the city

  Many factors contribute to the PM2.5 level in the air in Maricopa
  County, this is the Phoenix-Mesa area we are focusing on. According to
  Maricopa’s official website, some of the biggest contributors to PM2.5
  pollution include wood burning, power plants, congested highways,
  construction sites, and unpaved roads. Using the same technique of
  acquiring their coordinates from Google API, we can make a table that
  contains some of the biggest contributors around this county, some
  more centralized in the city than others.

``` r
sources <- read.csv("Poll_Coordinates.csv") %>%     
  filter(Source != "SOURCE Arizona") %>%     
  select(Source,lat2,lon2) 
kable(sources) 
```

| Source                                                |     lat2 |      lon2 |
|:------------------------------------------------------|---------:|----------:|
| Intersection of Interstate 17 & Interstate 10 Arizona | 33.46184 | -112.1083 |
| Intersection of Interstate 10 & U.S. 60 Arizona       | 33.38801 | -111.9676 |
| Palo Verde Nuclear generation Station Arizona         | 33.38800 | -112.8617 |
| Agua Fria Generating Station Arizona                  | 33.55432 | -112.2138 |
| Arlington Valley Plant Arizona                        | 33.34170 | -112.8897 |
| Gila River Generating Station Arizona                 | 32.97500 | -112.6944 |
| Harquahala Generating Station Arizona                 | 33.47573 | -113.1136 |
| Kyrene Power Plant Arizona                            | 33.35560 | -111.9353 |
| Mesquite Power Plant Arizona                          | 33.34500 | -112.8642 |
| Ocotillo Power Plant Arizona                          | 33.42320 | -111.9123 |
| Red Hawk Power Station Arizona                        | 33.33456 | -112.8406 |
| Santan Power Plant Arizona                            | 33.33250 | -111.7503 |
| West Phoenix Power Plant Arizona                      | 33.44170 | -112.1583 |

## Plotting Stations

Once we had the coordinates, we could plot them out and create a map
displaying the stations and the line they all service, as well as a
circular buffer representing the station’s area of effect.

``` r
stations <- read.csv("Coordinates.csv") 
sources <- read.csv("Poll_Coordinates.csv")  
df<-stations |>   select(lon2, lat2)  
df2<-sources |>   select(lon2, lat2)  
#converts df into a spatvector 
x <- vect(df, geom=c("lon2", "lat2"), crs="+proj=longlat +ellps=WGS84 +datum=WGS84 +no_defs ") 
y <- vect(df2, geom=c("lon2", "lat2"), crs="+proj=longlat +ellps=WGS84 +datum=WGS84 +no_defs ") 
#these are the stations  plot(x) #these are our sources of Pollution in Maricopa County 
plot(y) 
```

![](README_files/figure-commonmark/unnamed-chunk-4-1.png)

This would then put buffers over our stations with a 1000m radius. We
get a more complete map by combining a map background, our points, and
their station buffers.

``` r
#create a 1 km (1000 meter) buffer (radius)  
pts_buffer<-buffer(x, width = 400) 
plot(pts_buffer)   
```

![](README_files/figure-commonmark/unnamed-chunk-5-1.png)

``` r
#approximate size of the background 
extent<-buffer(x, width = 400)  
bg <- get_tiles(ext(extent))  
plot(bg)  
#plotting the Stations and their buffers,as well as sources of pollution 
lines(pts_buffer) 
points(x, col = "red") 
points(y, col = "blue") 
```

![](README_files/figure-commonmark/unnamed-chunk-5-2.png)

``` r
outfile <- "buffer.shp" 
writeVector(pts_buffer, outfile, overwrite=TRUE) 
```

## **Gathering Meteorology Data**

To check the effects of pollution from sources around the city, whether
it comes from stations, power plants, and highways or the effects of
policies that might affect these levels of pollution, we need
meteorological data. we will be using data from NASA, through its Land
Data Assimilation System (LDAS) and its global counterpart (GLDAS).
These data can be gathered from NASA’s website. We downloaded all
relevant data into a Google Drive folder, ranging from the dates of
01/01/2000 to 30/12/20214. This already covers our original date range
of 01/01/2000 to 01/01/2012.

The code below opens this data and loops through its files to only get
the relevant dates. Next, it uses the buffer zones around the train
stations to only put the data from these areas. Lastly, it puts it all
into a CSV file.

``` r
files<-dir("G:/Shared drives/2024 FIRE Light Rail/DATA/GLDAS/")

output<-c()

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
  output<-rbind(output, metdf)
  print(files[i])
}
 
write.csv(output, "met_data.csv", row.names=F)
```

## **Gathering PM2.5 Data**

Similarly to Meteorology data, we need to also gather PM2.5 to see the
changes these stations have on this type of pollution. we focus on the
same time frame as meteorology data. Our data comes from NASA. We
downloaded the data into another Google Drive folder. we then use a
nested for-loop to go through each folder (which are months), and go
through each day (they are TIF files containing satellite images of the
US). The buffers we used for the meteorology data are also used again to
focus on those parts of the map. We put all these daily files into a
folder that will be used later on.

``` r
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
```

## **Combining all data gathered**

Now that we have station locations, sources of pollution locations,
meteorology data, and PM2.5 data, we combine all of these into one
single data frame. Holiday dates were added and compared to dates on the
time frame to verify if those dates were holidays. all of the data are
then combined into a data frame using merge() and outputted into a CSV
file.

``` r
setwd("PM25_daily")
file_list <- list.files()

dataset<-data.frame()

for (file in file_list){
    temp_dataset <-read.csv(file)
    dataset<-rbind(dataset, temp_dataset)
    rm(temp_dataset)
}
setwd("..")
stations<-read.csv("Coordinates.csv")
merge1<-merge(dataset,stations, by.x = "city_num", by.y = "X")
newdates <- gsub("(....)(..)(..)(\\.tif)", "\\1-\\2-\\3", merge1$date)
merge1$date <- as.Date(newdates)
holidays <- read.csv("major_holidays_2000_2025.csv")
is_holiday <- newdates %in% holidays$date
merge1$is_holiday <- is_holiday
merge1$dow <- weekdays(merge1$date)
merge1$month <- format(merge1$date, "%m")
dfm<-read.csv("met_data.csv")
newdates2 <- as.Date(gsub("(....)(..)(..)(\\.020\\.nc4)", "\\1-\\2-\\3", dfm$date))
dfm$date <- newdates2
merge2<-merge(merge1, dfm, by.x="date", by.y="date")

write.csv(merge2, "Big_Data.csv")
```

## Modeling and using DB-OLS regression

we now want to create a model that would give us a coefficient that we
can use to tell the relationship between the pollution levels and the
metro stations opening. we will create our dates for the start of the
analysis to the end of it, the opening date of the stations, when
construction began for the stations, and a policy that was enacted
around that same time. df2 has our initial big data that was combined
above, but it removes unnecessary columns that wont be used on the
regression.

``` r
df<-read.csv("Big_Data.csv")
df2<-df %>% mutate(date=as.Date(date, format='%Y-%m-%d'))
df2 <- subset(df2, select = -c(V1, V2, V3, lon, lat, address, X, lat2, lon2, Station))

#period of analysis

startdate<-as.Date("2004-12-01", format='%Y-%m-%d')
enddate<-as.Date("2012-12-01", format='%Y-%m-%d')
opendate<-as.Date("2008-12-27", format='%Y-%m-%d')
conststart<-as.Date("2005-03-01", format='%Y-%m-%d')
poldate<-as.Date("2004-01-21", format='%Y-%m-%d')
```

We now add variables that will be used for the regression. we have a
policy variable that would be a 1 when it is active and 0 when it is
not. Like with with Metro open, it just states which dates the metro
stations where open or not. other variables are temperature, wind,
humidity and time variable.

``` r
df3<-df2 %>%
  filter(date>=startdate & date<=enddate) %>%
  mutate(policy=ifelse(date>=poldate, 1, 0)) %>%
  mutate(MetroOpen=ifelse(date>=opendate, 1, 0)) %>%
  mutate(dow=wday(date)) %>%
  mutate(construction=ifelse(date>conststart & date<opendate, 
                             1, 0)) %>%
  #Create P(t) variables
  mutate(t=as.numeric(date-startdate)) %>%
  mutate(t2=t^2, t3=t^3, t4=t^4) %>%
  #Create lagged values (do this for temperature, humidity, and wind speed)
  arrange(city_num, date) %>%
  group_by(city_num) %>%
  mutate(lag_temp=lag(Tair_f_tavg)) %>%
  mutate(lag_temp2=lag_temp^2, lag_temp3=lag_temp^3, lag_temp4=lag_temp^4) %>%
  mutate(lag_wind=lag(Wind_f_tavg)) %>%
  mutate(lag_wind2=lag_wind^2, lag_wind3=lag_wind^3, lag_wind4=lag_wind^4) %>%
  mutate(lag_hum=lag(Qair_f_tavg)) %>%
  mutate(lag_hum2=lag_hum^2, lag_hum3=lag_hum^3, lag_hum4=lag_hum^4) %>%
  mutate(MetroTime=MetroOpen*t, MetroTime2=MetroOpen*t2, MetroTime3=MetroOpen*t3, MetroTime4=MetroOpen*t4)
```

Our first simple regression is just to see the effect on PM2.5 when the
metro is open. this is not a good model as it only considers one
variable. we would need to add more variables to see if any hidden
variables might be affecting the levels of pollution in our areas. so we
begin to add more regression to see how the variable “Metro Open”
changes with each regression and added variable.

``` r
#simple regression
summary(m1<-lm(log(pm25) ~ MetroOpen , data=df3))
```


    Call:
    lm(formula = log(pm25) ~ MetroOpen, data = df3)

    Residuals:
         Min       1Q   Median       3Q      Max 
    -1.81005 -0.25654 -0.02298  0.23402  2.09546 

    Coefficients:
                 Estimate Std. Error t value Pr(>|t|)    
    (Intercept)  2.235255   0.002008 1112.94   <2e-16 ***
    MetroOpen   -0.071515   0.003064  -23.34   <2e-16 ***
    ---
    Signif. codes:  0 '***' 0.001 '**' 0.01 '*' 0.05 '.' 0.1 ' ' 1

    Residual standard error: 0.399 on 69199 degrees of freedom
      (5126 observations deleted due to missingness)
    Multiple R-squared:  0.007809,  Adjusted R-squared:  0.007795 
    F-statistic: 544.7 on 1 and 69199 DF,  p-value: < 2.2e-16

``` r
summary(m1<-lm(log(pm25) ~ MetroOpen + as.factor(dow) + as.factor(month), data=df3))
```


    Call:
    lm(formula = log(pm25) ~ MetroOpen + as.factor(dow) + as.factor(month), 
        data = df3)

    Residuals:
        Min      1Q  Median      3Q     Max 
    -2.0435 -0.2192  0.0073  0.2271  2.1418 

    Coefficients:
                        Estimate Std. Error t value Pr(>|t|)    
    (Intercept)         2.401302   0.005897 407.188  < 2e-16 ***
    MetroOpen          -0.073246   0.002778 -26.366  < 2e-16 ***
    as.factor(dow)2    -0.002600   0.005143  -0.505 0.613251    
    as.factor(dow)3    -0.009915   0.005143  -1.928 0.053879 .  
    as.factor(dow)4     0.016594   0.005143   3.226 0.001255 ** 
    as.factor(dow)5     0.014670   0.005143   2.852 0.004345 ** 
    as.factor(dow)6     0.052751   0.005143  10.256  < 2e-16 ***
    as.factor(dow)7     0.017099   0.005143   3.325 0.000885 ***
    as.factor(month)2  -0.245479   0.006844 -35.868  < 2e-16 ***
    as.factor(month)3  -0.359717   0.006676 -53.878  < 2e-16 ***
    as.factor(month)4  -0.324935   0.006732 -48.268  < 2e-16 ***
    as.factor(month)5  -0.265823   0.006676 -39.817  < 2e-16 ***
    as.factor(month)6  -0.233232   0.006732 -34.645  < 2e-16 ***
    as.factor(month)7  -0.200728   0.006676 -30.066  < 2e-16 ***
    as.factor(month)8  -0.305255   0.006676 -45.722  < 2e-16 ***
    as.factor(month)9  -0.244434   0.006732 -36.309  < 2e-16 ***
    as.factor(month)10 -0.232710   0.006676 -34.857  < 2e-16 ***
    as.factor(month)11  0.040281   0.006732   5.984 2.19e-09 ***
    as.factor(month)12  0.216976   0.006631  32.720  < 2e-16 ***
    ---
    Signif. codes:  0 '***' 0.001 '**' 0.01 '*' 0.05 '.' 0.1 ' ' 1

    Residual standard error: 0.3618 on 69182 degrees of freedom
      (5126 observations deleted due to missingness)
    Multiple R-squared:  0.1847,    Adjusted R-squared:  0.1845 
    F-statistic:   871 on 18 and 69182 DF,  p-value: < 2.2e-16

``` r
summary(m1<-lm(log(pm25) ~ MetroOpen + as.factor(dow) + as.factor(month) +lag_temp+lag_wind+lag_hum+construction +policy, data=df3))
```


    Call:
    lm(formula = log(pm25) ~ MetroOpen + as.factor(dow) + as.factor(month) + 
        lag_temp + lag_wind + lag_hum + construction + policy, data = df3)

    Residuals:
         Min       1Q   Median       3Q      Max 
    -2.09097 -0.21128  0.00243  0.21615  2.13539 

    Coefficients: (1 not defined because of singularities)
                         Estimate Std. Error t value Pr(>|t|)    
    (Intercept)        -6.116e-01  1.241e-01  -4.929 8.27e-07 ***
    MetroOpen           1.444e-01  9.192e-03  15.710  < 2e-16 ***
    as.factor(dow)2     1.305e-02  4.960e-03   2.631 0.008509 ** 
    as.factor(dow)3     7.699e-03  4.962e-03   1.552 0.120722    
    as.factor(dow)4     2.748e-02  4.959e-03   5.542 3.01e-08 ***
    as.factor(dow)5     1.966e-02  4.957e-03   3.967 7.30e-05 ***
    as.factor(dow)6     6.236e-02  4.961e-03  12.569  < 2e-16 ***
    as.factor(dow)7     1.812e-02  4.956e-03   3.656 0.000256 ***
    as.factor(month)2  -2.568e-01  6.641e-03 -38.663  < 2e-16 ***
    as.factor(month)3  -4.433e-01  6.890e-03 -64.344  < 2e-16 ***
    as.factor(month)4  -4.292e-01  7.584e-03 -56.591  < 2e-16 ***
    as.factor(month)5  -4.105e-01  8.761e-03 -46.857  < 2e-16 ***
    as.factor(month)6  -4.362e-01  1.041e-02 -41.888  < 2e-16 ***
    as.factor(month)7  -3.136e-01  1.192e-02 -26.309  < 2e-16 ***
    as.factor(month)8  -4.188e-01  1.150e-02 -36.425  < 2e-16 ***
    as.factor(month)9  -3.868e-01  1.042e-02 -37.130  < 2e-16 ***
    as.factor(month)10 -3.420e-01  8.287e-03 -41.263  < 2e-16 ***
    as.factor(month)11 -8.580e-02  7.087e-03 -12.106  < 2e-16 ***
    as.factor(month)12  1.669e-01  6.498e-03  25.679  < 2e-16 ***
    lag_temp            1.139e-02  4.327e-04  26.315  < 2e-16 ***
    lag_wind           -7.030e-02  1.727e-03 -40.702  < 2e-16 ***
    lag_hum            -3.895e+01  7.593e-01 -51.299  < 2e-16 ***
    construction        2.261e-01  9.179e-03  24.636  < 2e-16 ***
    policy                     NA         NA      NA       NA    
    ---
    Signif. codes:  0 '***' 0.001 '**' 0.01 '*' 0.05 '.' 0.1 ' ' 1

    Residual standard error: 0.3484 on 69151 degrees of freedom
      (5153 observations deleted due to missingness)
    Multiple R-squared:  0.2418,    Adjusted R-squared:  0.2415 
    F-statistic:  1002 on 22 and 69151 DF,  p-value: < 2.2e-16
