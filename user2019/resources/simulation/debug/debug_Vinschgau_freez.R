rm(list=ls())
library(geotopbricks)
library(lubridate)
library(rasterList)
library(soilwater)

###wpath_3D <- 'resources/simulation/Vinschgau_test_3D_002'
wpath <- '/home/ecor/local/rpackages/geotopbricks_doc_private/user2019/'
wpath_3D <- sprintf('%s/resources/simulation/Vinschgau__v2.0',wpath)
basin <- get.geotop.inpts.keyword.value("LandCoverMapFile",wpath=wpath_3D,raster=TRUE)
land <- basin
tz <- "Etc/GMT-1"
##keyword <- 'SoilLiqContentTensorFile'
##keyword <- 'SoilTotWaterPressTensorFile'
##SoilLiqContentProfileFile = "output-tabs/thetaliq" 

start <-  get.geotop.inpts.keyword.value("InitDateDDMMYYYYhhmm",date=TRUE,wpath=wpath_3D,tz=tz) 

dt <-     get.geotop.inpts.keyword.value('OutputSoilMaps',wpath=wpath_3D,numeric=TRUE)


end <- get.geotop.inpts.keyword.value("EndDateDDMMYYYYhhmm",date=TRUE,wpath=wpath_3D,tz=tz) 
when <- start+hours(dt)*rev(1211-(0:11))
when <- as.POSIXct(when)
SoilLiqContentTensorFile     <- b <- brickFromOutputSoil3DTensor(x='SoilLiqContentTensorFile',when=when,wpath=wpath_3D,tz=tz)
SoilIceContentTensorFile     <- c <- brickFromOutputSoil3DTensor(x='SoilIceContentTensorFile',when=when,wpath=wpath_3D,tz=tz)
SoilTotWaterPressTensorFile  <- p <- brickFromOutputSoil3DTensor(x='SoilTotWaterPressTensorFile',when=when,wpath=wpath_3D,tz=tz)
SoilTempTensorFile  <- p <- brickFromOutputSoil3DTensor(x='SoilTotWaterPressTensorFile',when=when,wpath=wpath_3D,tz=tz)

elev <- get.geotop.inpts.keyword.value('DemFile',wpath=wpath_3D,raster=TRUE)
slope <- get.geotop.inpts.keyword.value('SlopeMapFile',wpath=wpath_3D,raster=TRUE)
aspect <- get.geotop.inpts.keyword.value('AspectMapFile',wpath=wpath_3D,raster=TRUE)
sky <- get.geotop.inpts.keyword.value('SkyViewFactorMapFile',wpath=wpath_3D,raster=TRUE)
soil <- get.geotop.inpts.keyword.value("SoilMapFile",wpath=wpath_3D,raster=TRUE)

soiltypes <- get.geotop.inpts.keyword.value("SoilLayerTypes",numeric=TRUE,wpath=wpath_3D)
soilpar <- get.geotop.inpts.keyword.value("SoilParFile",data.frame=TRUE,wpath=wpath_3D,level=1:soiltypes)

stop("HERE")
###
sat_cat <- seq(from=0,to=1,length.out=10)






### 





#stop("HERE")


####




###,timestep=dt)
#b
b[[1]]
b[[10]]

plot(b[[1]])
plot(b[[10]])
dpsi <-b[[10]]-b[[1]]

db <- b

for (i in 2:length(db)) {
  
  db[[i]] <- b[[i]]-b[[i-1]]/dt
  
  
  
}


j <- 11
layer <- 2
l <- list(elev=elev,slope=slope,aspect=aspect,sky=sky,land=(land))
l$SoilLiqContentTensorFile <- SoilLiqContentTensorFile[[j]][[layer]]
l$SoilIceContentTensorFile <- SoilIceContentTensorFile[[j]][[layer]]
l$SoilTotWaterPressTensorFile <- SoilTotWaterPressTensorFile[[j]][[layer]]
l$SoilTempTensorFile <- SoilTempTensorFile[[j]][[layer]]
l <- stack(l)
stop("HERE")
l <- as.data.frame(l,na.rm=TRUE)
l <- l[!is.na(l$land),]
nn <- names(l)
ny <- 6
nn <- c(nn[ny],nn[-ny])
l <- l[,nn]
l$land <- factor(l$land)
###plot(l$SoilLiqContentTensorFile,l$SoilTotWaterPressTensorFile)


l <- apply(l,FUN=)