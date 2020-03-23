## Emanuele Cordano 
rm(list=ls())
library(jpeg)
library(magrittr)
library(raster)
logo1_f <- '~/local/rpackages/geotopbricks_doc_private/snowhydro2020/poster/resources/logo/logo_harvard_fem_p1.jpg'
logo2_f <- '~/local/rpackages/geotopbricks_doc_private/snowhydro2020/poster/resources/logo/logo_harvard_fem_p2.jpg'
logo_out_f <- '~/local/rpackages/geotopbricks_doc_private/snowhydro2020/poster/resources/logo/logo_harvard_fem_p3.jpg'

logo1 <- logo1_f %>% stack() ##readJPEG(native=FALSE)
masterl <- logo1
logo2     <- logo2_f     %>% stack() ##readJPEG(native=FALSE)

####
fact <- ncol(logo2)/nrow(logo2)
ncolm <- ncol(masterl)
nrowm <- ncolm/fact %>% as.integer()
ext <- extent(logo2)
logo2_m <- logo2 %>% resample(y=raster(nrow=nrowm,ncol=ncolm,ext=ext))

###

out <- list()
v <- c(1,1,1)*255
for (i in (1:nlayers(masterl))) {
  
###  out[,,i] <- rbind(out0[,,i],out0[,,i])
  
    temp1 <-  logo1[[i]] %>% as.matrix()
    
    temp2 <-  logo2_m[[i]] %>% as.matrix()
  
    
    
    out[[i]] <-rbind(temp1,temp2)/255

}

###
dims <- dim(out[[1]]) 

out2 <- array(as.numeric(NA),c(dim(out[[1]]),length(out)))

for (i in 1:length(out)) {
  
  out2[,,i] <- out[[i]]
  
}





writeJPEG(out2, target = logo_out_f)
