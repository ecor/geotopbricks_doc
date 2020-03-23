###############################################################################
# Date: 11/ 01 / 2020
# Author: Emanuele Cordano
###############################################################################

rm(list=ls())

# library(geotopbricks)
# library(reshape2)
# library(ggplot2)
# library(lubridate)
# library(mapview)
# library(magrittr)
# library(stringr)
# library(dplyr)
# 
# ##
# library(leaflet)
# library(RColorBrewer)

##
library(raster)
library(magrittr)
library(leaflet)

ss <- "mean"
wdir <- '/home/ecor/local/rpackages/geotopbricks_doc_private/snowhydro2020/poster/' 

out <- 'resources/data/rendena_snow_%s.grd' %>% sprintf(ss) 
out <- sprintf(fmt="%s%s",wdir,out)

msd <- 400
out <- stack(out)
if (ss=="mean") {
  out <- out/10 ## mm to cm
 
  out[out>msd] <- msd
  
}  
URL = "https://{s}.tile.opentopomap.org/{z}/{x}/{y}.png"
ATTRIBUTION = 'Map data: &copy; <a href="http://www.openstreetmap.org/copyright">OpenStreetMap</a>, <a href="http://viewfinderpanoramas.org">SRTM</a> | Map style: &copy; <a href="https://opentopomap.org">OpenTopoMap</a> (<a href="https://creativecommons.org/licenses/by-sa/3.0/">CC-BY-SA</a>)'


tione_location <- c(lon = 10.7267900,lat = 46.0355000)
leaf <-  leaflet() %>% addTiles(urlTemplate=URL,attribution=ATTRIBUTION) 
leaf <- leaf %>% setView(lat=tione_location["lat"]+0.01*7,lng=tione_location["lon"],zoom=10) 

## Image png dimensions (width and height)
vwidth = 992/2
vheight = 744/2


basemap <- list()

colors <-   c("white","yellow","green","blue","pink")
breakss <- list()
breakss$mean <- c(50,100,250,500,750,1000,1500,2000,3000,msd+0:2)
breakss$max <-  c(50,100,250,500,750,1000,1500,2000,3000,msd+0:2)
breakss$nday <- c(3,c(1:4,6,8,10,15,20,25,30)*7)
breakss <- as.data.frame(breakss)


leafs <- list()

for (it in names(out)) {
  
  print(it)
  r <- as.factor(out[[it]])
  leaft <- leaf %>% addRasterImage(r,colors=colors,opacity=0.7) 
  leaft <- leaft %>% addLegend(position="bottomright",pal=colorNumeric(colors,domain=breakss[,ss]),values=breakss[,ss])
  leafs[[it]] <- leaft
 
  mapshot(leaft, file = sprintf("%sresources/images/map/%s_%s_winter.png",wdir,ss,it),vwidth = vwidth,vheight = vheight,zoom=1)
  
}





