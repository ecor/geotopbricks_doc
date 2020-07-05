
library(geotopbricks)
library(lubridate)

###wpath_3D <- 'resources/simulation/Vinschgau_test_3D_002'
wpath <- '/home/ecor/local/rpackages/geotopbricks_doc_private/user2019/'
wpath_3D <- sprintf('%s/resources/simulation/Vinschgau',wpath)
basin <- get.geotop.inpts.keyword.value("LandCoverMapFile",wpath=wpath_3D,raster=TRUE)
tz <- "Etc/GMT-1"
keyword <- 'SoilLiqContentTensorFile'
keyword <- 'SoilTotWaterPressTensorFile'
start <-  get.geotop.inpts.keyword.value("InitDateDDMMYYYYhhmm",date=TRUE,wpath=wpath_3D,tz=tz) 

dt <-     get.geotop.inpts.keyword.value('OutputSoilMaps',wpath=wpath_3D,numeric=TRUE)


end <- get.geotop.inpts.keyword.value("EndDateDDMMYYYYhhmm",date=TRUE,wpath=wpath_3D,tz=tz) 
when <- start+hours(dt)*(1:11)
when <- as.POSIXct(when)
b <- brickFromOutputSoil3DTensor(x=keyword,when=when,wpath=wpath_3D,tz=tz)###,timestep=dt)
b
b[[1]]
b[[10]]

plot(b[[1]])
plot(b[[10]])
dpsi <-b[[10]]-b[[1]]

db <- b

for (i in 2:length(db)) {
  
  db[[i]] <- b[[i]]-b[[i-1]]/dt
  
  
  
}


###help("brickFromOutputSoil3DTensor") ## for more details
(b[[11]])