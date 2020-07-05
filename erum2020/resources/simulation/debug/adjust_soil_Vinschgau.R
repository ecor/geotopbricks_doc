rm(list=ls())
library(geotopbricks)

wpath <- '/home/ecor/local/rpackages/geotopbricks_doc_private/user2019/'
wpath_3D <- sprintf('%s/resources/simulation/Vinschgau',wpath)
nsoil <-   get.geotop.inpts.keyword.value('SoilLayerTypes',wpath=wpath_3D,numeric=TRUE)
soilpar <- get.geotop.inpts.keyword.value('SoilParFile',wpath=wpath_3D,data.frame=TRUE,level=1:nsoil)
soilinit <- get.geotop.inpts.keyword.value('HeaderSoilInitPres',wpath=wpath_3D)
soildz <-   get.geotop.inpts.keyword.value('HeaderSoilDz',wpath=wpath_3D)
depth <- 1000
for (it in names(soilpar)) {
  
  c <- identical(soilpar[[it]],soilpar[[1]])
  print(c)
  ### 
  dz <- soilpar[[it]][,soildz] ##array(NA,nrow(soilpar[[it]]))
  z <- dz
  z[1] <- dz[1]/2
  for (i in 2:length(z)) {
    z[i] <- z[i-1]+(dz[i]+dz[i-1])/2
    
  }
   
  psi <- z-depth
  
  soilpar[[it]][,soilinit] <- psi
  write.table(soilpar[[it]],file=it,sep=",",row.names=FALSE,quote=FALSE)
}