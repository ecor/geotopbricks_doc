###############################################################################
# Date: 11/ 01 / 2020
# Author: Emanuele Cordano
###############################################################################

rm(list=ls())

library(geotopbricks)
library(reshape2)
library(ggplot2)
library(lubridate)
library(mapview)
library(magrittr)
library(stringr)
library(dplyr)

##
library(leaflet)
library(RColorBrewer)

##

wpath <- '/home/ecor/local/simulation/geotop20sim/rendena100m_snow1989_2015_real_scenario/'
wpath45 <- '/home/ecor/local/simulation/geotop20sim/rendena100m_snow1989_2015_lRCP45_modified_scenario/'
wpath85 <- '/home/ecor/local/simulation/geotop20sim/rendena100m_snow1989_2015_modified_scenario/'
sep <- "/"
if (str_sub(wpath,start=-1)==sep) sep <- ""
## SNOW MAPS DIRECTORY
mmapfolder <- wpathout <- paste(c(wpath,wpath45,wpath85),"external/monthly",sep=sep)
# ELEVATION MAP
# alt_map <-  get.geotop.inpts.keyword.value("DemFile",raster=TRUE,wpath=wpath)
# dz <- 200
# alt_map_z <- ceiling(alt_map/dz)*dz
ss <- "mean"
filename <- "~/local/rpackages/geotopbricks_doc_private/snowhydro2020/poster/resources/data/" %>% paste0("rendena_snow_",ss,".grd") 
###   sprintf("~/temp/plot/%s_%s.png",ss,iy)

mapfiles <- list.files(mmapfolder,pattern=".asc",full.name=TRUE) %>% extract(str_detect(.,ss))
names(mapfiles) <- mapfiles ### list.files(mmapfolder,pattern=".asc",full.name=TRUE)

##prefix <- c("nday","mean","max")
##title <- c("Duration (days","Mean Depth (mm)","Max Depth (mm)")

scenario <- array(NA,length(mapfiles))
names(scenario) <- names(mapfiles)

scenario[which(str_detect(mapfiles,wpath45))] <- "RCP45"
scenario[which(str_detect(mapfiles,wpath85))] <- "RCP85"
scenario[which(str_detect(mapfiles,wpath))] <- "OBS"

time <- str_sub(mapfiles,start=-11,end=-5) ## check filenames!!!
time <- as.Date(paste0(time,"-01"),format="%Y-%m-%d")
names(time) <- mapfiles
month <- as.integer(as.character(time,format="%m"))
yearw  <- as.integer(as.character(time,format="%Y"))


###


###

df <- data.frame(time=time,file=mapfiles,scenario=scenario,month=month,yearw=yearw,stringsAsFactors = FALSE)

df$yearw[df$month>=8] <- df$yearw[month>=8]+1

#MONTH SELECTION 
monthsel <-  c(11:12,1:4) ###c(9:12,1:8)
df <- df[df$month %in% monthsel,]
## SELECTION OF PERIODS AND SCANARIOS PERIOD AND SCANARIOS
df$decade <- as.character(NA)
df$decade[df$yearw>=1996 & df$yearw<=2005 & df$scenario=="OBS"] <- "1996-2005"
df$decade[df$yearw>=2006 & df$yearw<=2015 & df$scenario=="OBS"] <- "2006-2015"
df$decade[df$yearw>=2006 & df$yearw<=2015 & df$scenario=="RCP45"] <- "RCP 4.5"
df$decade[df$yearw>=2006 & df$yearw<=2015 & df$scenario=="RCP85"] <- "RCP 8.5"

##IMPORTING MAPS :
## Data Tibble (dataframe) containing   

yearwsel  <- c(1990,1991,1992,1993,1995,1997,2002,2005,2006,2007,2014,2015)
scenariosel <- df$scenario %>% unique() ## ALL SCENARIOS

cc <- system.time(out <- (df) %>% as.tbl() %>% group_by(scenario,yearw) 
                  %>% summarize(file=paste(file,collapse=",")) %>% mutate(idcode=paste0(scenario,"_",yearw))
                  %>% filter(yearw %in% yearwsel) %>% filter(scenario %in% scenariosel))
cm <- system.time(outm <- out$file %>% str_split(pattern=",") %>% lapply(FUN=stack) %>% lapply(FUN=mean) %>% stack() )
names(outm) <- out$idcode

#####
breakss <- list()
breakss$mean <- c(50,100,250,500,750,1000,1500,2000,3000,10000+0:2)
breakss$max <-  c(50,100,250,500,750,1000,1500,2000,3000,10000+0:2)
breakss$nday <- c(3,c(1:4,6,8,10,15,20,25,30)*7)
breakss <- as.data.frame(breakss)
breakss$id <- 1:nrow(breakss)
outmc <- outm %>% cut(breaks=breakss[,ss]) %>% subs(y=breakss[,c("id",ss)],filename=filename,overwrite=TRUE)

##stop("MI FERMO QUI POI PROSEGUO DA QUI")

 stop("MI FERMO QUI")
# ##########
# 
# mmstack_cut1 <- mmstack_cut[[14]]
# levels(mmstack_cut1) <- breaks_df
# 
#
#
#m


leafs <- list()


#obs <- subset(mmstack_cut,nobs)
#years <- c(1990,1991,1992,1993,1995,1997,2002,2005,2006,2007,2014,2015)

#nyears <- nobs[sapply(X=years,FUN=function(x,nn){which(str_detect(nn,as.character(x)))[1]},nn=nobs)]
#nyears <- c(nyears,nrcp45[sapply(X=years,FUN=function(x,nn){which(str_detect(nn,as.character(x)))[1]},nn=nrcp45)])
#nyears <- c(nyears,nrcp85[sapply(X=years,FUN=function(x,nn){which(str_detect(nn,as.character(x)))[1]},nn=nrcp85)])
vwidth = 992/2
vheight = 744/2


basemap <- list()
basemap$URL = "https://{s}.tile.opentopomap.org/{z}/{x}/{y}.png"
basemap$ATTRIBUTION = 'Map data: &copy; <a href="http://www.openstreetmap.org/copyright">OpenStreetMap</a>, <a href="http://viewfinderpanoramas.org">SRTM</a> | Map style: &copy; <a href="https://opentopomap.org">OpenTopoMap</a> (<a href="https://creativecommons.org/licenses/by-sa/3.0/">CC-BY-SA</a>)'
##colors_v <- c("#fcfbfd","#efedf5","#dadaeb","#bcbddc","#9e9ac8","#807dba","#6a51a3","#54278f","#3f007d")
##colors <-   rev(brewer.pal(length(breaks),"BuGn")
colors <-   c("white","yellow","green","blue","pink")
tione_location <- c(lon = 10.7267900,lat = 46.0355000)
leaf <-  leaflet() %>% addTiles(urlTemplate=basemap$URL,attribution=basemap$ATTRIBUTION) 
leaf <- leaf %>% setView(lat=tione_location["lat"]+0.01*7,lng=tione_location["lon"],zoom=10) 


leafs <- list()
stop("HERE")
for (il in (1:nlayers(outmc))[1]) {
  
  print(il)
  r <- as.factor(outmc[[il]])
  leaft <- leaf %>% addRasterImage(r,colors=colors,opacity=0.7) 
  leaft <- leaft %>% addLegend(position="bottomright",pal=colorNumeric(colors,domain=breakss[[ss]]),values=breakss[[ss]])
  leafs[[il]] <- leaft
  ####m2 <- mapview(leaft)
  mapshot(leaft, file = sprintf("~/temp/plot/%s_%s.png",ss,iy),vwidth = vwidth,vheight = vheight,zoom=1)
 ## FARE I MAPSHOT mapshot(leaft, file = NULL,vwidth = vwidth,vheight = vheight,zoom=1)
  
}


######




#########

##stop("QUI")
### https://stackoverflow.com/questions/31336898/how-to-save-leaflet-in-r-map-as-png-or-jpg-file
# > heelp(package="RColorBrewer")
# Error in heelp(package = "RColorBrewer") : 
#   could not find function "heelp"
# > help(package="RColorBrewer")
# > 




# 
# 
# ################
# 
# library(ggmap)
# 
# 
# tione_location <- c(lon = 10.7267900,lat = 46.0355000)
# ##tione_location <- c(lon=10,lat=46)
# ggmm <- ggmap(get_map(location = tione_location,zoom=10, maptype = "hybrid"))
# 
# 
# i <- 5
# r <- projectRaster(obs[[i]], crs = CRS("+proj=longlat +ellps=WGS84 +datum=WGS84 +no_defs"))
# 
# 
# ################



