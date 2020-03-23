# TODO: Add comment
# 
# Author: ecor
###############################################################################

rm(list=ls())

library(geotopbricks)
library(reshape2)
library(ggplot2)
library(lubridate)
library(RColorBrewer)
library(mapview)
####wpath <- '/home/ecor/rendena100_sim/trial/rendena100_trial002_in'
wpath <- '/home/ecor/local/simulation/geotop20sim/rendena100m_snow1989_2015_real_scenario/'
wpath45 <- '/home/ecor/local/simulation/geotop20sim/rendena100m_snow1989_2015_lRCP45_modified_scenario/'
wpath85 <- '/home/ecor/local/simulation/geotop20sim/rendena100m_snow1989_2015_modified_scenario/'
sep <- "/"
if (str_sub(wpath,start=-1)==sep) sep <- ""

mmapfolder <- wpathout <- paste(c(wpath,wpath45,wpath85),"external/monthly",sep=sep) ###   '/home/ecor/activity/2017/rendena100/simulation/monthly_maps




alt_map <-  get.geotop.inpts.keyword.value("DemFile",raster=TRUE,wpath=wpath)



mapfiles <- list.files(mmapfolder,pattern=".asc",full.name=TRUE)

names(mapfiles) <- mapfiles ### list.files(mmapfolder,pattern=".asc",full.name=TRUE)

prefix <- c("nday","mean","max")
title <- c("Duration (days","Mean Depth (mm)","Max Depth (mm)")
aggrstack <- c("sum","mean","max")
names(title) <- prefix
names(aggrstack) <- prefix
ss <- "max"
ytitle <- title[ss]

mapfiles <- mapfiles[str_detect(mapfiles,ss)]
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

df <- data.frame(time=time,file=mapfiles,scenario=scenario,month=month,yearw=yearw,stringsAsFactors = FALSE)

df$yearw[df$month>=8] <- df$yearw[month>=8]+1

#monthsel <- c(12,1,2,3)
monthsel <-  c(11:12,1:4) ###c(9:12,1:8)
df <- df[df$month %in% monthsel,]
index <- paste(df$yearw,df$scenario,sep="_")

mmap <- stack(df$file)

mmap_aggrf <- stackApply(mmap,fun=get(aggrstack[ss]),indices=index)
mmstack <- stack(mmap_aggrf,alt_map)


#####
names(mmstack) <- str_replace(names(mmstack),"index_","")

nobs   <-  names(mmstack)[which(str_detect(names(mmstack),"OBS"))]
nrcp45 <-  names(mmstack)[which(str_detect(names(mmstack),"RCP45"))]
nrcp85 <-  names(mmstack)[which(str_detect(names(mmstack),"RCP85"))]

#####
breaksl <- list()
breaksl[["mean"]] <- c(50,100,250,500,750,1000,1500,2000,3000,10000)
breaksl[["max"]] <- c(50,100,250,500,750,1000,1500,2000,3000,10000)
breaksl[["nday"]] <- c(3,c(1:4,6,8,10,15,20,25,30)*7)

breaks <- breaksl[[ss]]
breaks_df <- data.frame(ID=1:length(breaks),val=breaks)
mmstack_cut0 <- cut(mmstack,breaks=breaks)
mmstack_cut <- mmstack_cut0*NA
#########
for (i in 1:length(breaks)) {
  
  ii <- i
  ii[i==length(breaks)] <- i-1
  mmstack_cut[mmstack_cut0==i] <-breaks[ii]
  
  
}
breaks <- breaks[-length(breaks)]




# stop("MI FERMO QUI")
# ##########
# 
# mmstack_cut1 <- mmstack_cut[[14]]
# levels(mmstack_cut1) <- breaks_df
# 

library(leaflet)
library(RColorBrewer)
m


leafs <- list()


obs <- subset(mmstack_cut,nobs)
years <- c(1990,1991,1992,1993,1995,1997,2002,2005,2006,2007,2014,2015)

nyears <- nobs[sapply(X=years,FUN=function(x,nn){which(str_detect(nn,as.character(x)))[1]},nn=nobs)]
nyears <- c(nyears,nrcp45[sapply(X=years,FUN=function(x,nn){which(str_detect(nn,as.character(x)))[1]},nn=nrcp45)])
nyears <- c(nyears,nrcp85[sapply(X=years,FUN=function(x,nn){which(str_detect(nn,as.character(x)))[1]},nn=nrcp85)])
vwidth = 992/2
vheight = 744/2


for (iy in nyears) {
  
  print(iy)
  r <- as.factor(mmstack_cut[[iy]])
  leaft <- leaf %>% addRasterImage(r,colors=colors,opacity=0.7) 
  leaft <- leaft %>% addLegend(position="bottomright",pal=colorNumeric(colors,domain=breaks),values=breaks)
  leafs[[iy]] <- leaft
  ####m2 <- mapview(leaft)
  mapshot(leaft, file = sprintf("~/temp/plot/%s_%s.png",ss,iy),vwidth = vwidth,vheight = vheight,zoom=1)
  
  
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


