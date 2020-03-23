## Emanuele Cordano 
rm(list=ls())
library(jpeg)
library(magrittr)
library(raster)
rendena100_logo <- '~/local/rpackages/geotopbricks_doc_private/snowhydro2020/poster/resources/logo/logo_rendena100_textinside_small.jpg'
rendena100_logo_double <- '~/local/rpackages/geotopbricks_doc_private/snowhydro2020/poster/resources/logo/logo_rendena100_textinside_small_double.jpg'
out0 <- rendena100_logo %>% readJPEG(native=FALSE)
cf <- c(2,1,1)
out <- array(as.numeric(NA),dim(out0)*cf)


for (i in 1:(dim(out)[3])){
  
  out[,,i] <- rbind(out0[,,i],out0[,,i])
  
  
  
  
}


writeJPEG(out, target = rendena100_logo_double)
