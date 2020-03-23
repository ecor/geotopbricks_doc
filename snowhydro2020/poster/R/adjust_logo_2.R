## Emanuele Cordano 
rm(list=ls())
library(jpeg)
library(magrittr)
library(raster)
rendena100_logo_f <- '~/local/rpackages/geotopbricks_doc_private/snowhydro2020/poster/resources/logo/logo_rendena100_textinside_small.jpg'
geotop_logo_f <- '~/local/rpackages/geotopbricks_doc_private/snowhydro2020/poster/resources/logo/logo_geotop.jpg'
logo_out_f <- '~/local/rpackages/geotopbricks_doc_private/snowhydro2020/poster/resources/logo/logo_geotop_rendena100.jpg'

rendena100_logo <- rendena100_logo_f %>% stack() ##readJPEG(native=FALSE)
masterl <- rendena100_logo
geotop_logo     <- geotop_logo_f     %>% stack() ##readJPEG(native=FALSE)

####
fact <- ncol(geotop_logo)/nrow(geotop_logo)
nrowm <- nrow(masterl)
ncolm <- nrowm*fact %>% as.integer()
ext <- extent(geotop_logo)
geotop_logo_m <- geotop_logo %>% resample(y=raster(nrow=nrowm,ncol=ncolm,ext=ext))

###

out <- list()
v <- c(1,1,1)*255
for (i in (1:nlayers(masterl))) {
  
###  out[,,i] <- rbind(out0[,,i],out0[,,i])
  
    temp1 <-  rendena100_logo[[i]] %>% as.matrix()
    
    temp2 <-  geotop_logo_m[[i]] %>% as.matrix()
  
    
    
    out[[i]] <-rbind(temp1,temp2)/255

}

###
dims <- dim(out[[1]]) 

out2 <- array(as.numeric(NA),c(dim(out[[1]]),length(out)))

for (i in 1:length(out)) {
  
  out2[,,i] <- out[[i]]
  
}





writeJPEG(out2, target = logo_out_f)
