rm(list=ls())


library(geotopbricks)
library(magrittr)
library(sf)
#library(reshape2)
#library(ggplot2)
#library(lubridate)
####wpath <- '/home/ecor/rendena100_sim/trial/rendena100_trial002_in'
wpath <- '/home/ecor/local/simulation/geotop20sim/rendena100m_snow1989_2015_real_scenario/'

meteodf_crs <- wpath %>% paste0("geotop.proj") %>% readLines()

nmeteo <- "NumberOfMeteoStations" %>% get.geotop.inpts.keyword.value(wpath=wpath,numeric=TRUE)

meteo_station_attr <- c("MeteoStationCoordinateX","MeteoStationCoordinateY","MeteoStationCode","MeteoStationName","MeteoStationElevation")

meteo_df <- NA %>% as.character() %>% array(c(nmeteo,length(meteo_station_attr))) %>% as.data.frame()

names(meteo_df) <- meteo_station_attr

for (it in names(meteo_df)) {
  
  vtemp <- it %>% get.geotop.inpts.keyword.value(wpath=wpath,vector_sep=",")
  cond_numeric <- vtemp %>% as.numeric() %>% is.na() %>% which() %>% length()== vtemp %>% is.na() %>% which() %>% length()
  if (cond_numeric) {
    
    meteo_df[,it] <- vtemp %>% as.numeric()
  } else {
    
    meteo_df[,it] <- vtemp
  }
}

meteo_df <- meteo_df %>% st_as_sf(coords=c("MeteoStationCoordinateX","MeteoStationCoordinateY"),crs=meteodf_crs)

## MAPVIEW REPRESENTATION

meteo_df %>% st_transform(crs=4326) %>% st_geometry() %>% mapview::mapview(native.crs=FALSE)

## WRITE SHAPEFILE 
dsn <- '/home/ecor/local/rpackages/geotopbricks_doc_private/snowhydro2020/poster/R/output/rendena_meteo_stations.shp'
dsn <- '/home/ecor/local/rpackages/geotopbricks_doc_private/snowhydro2020/poster/resources/data/rendena_meteo_stations.shp'

st_write(meteo_df,dsn=dsn,delete_dsn=TRUE)
st_read(dsn) %>% st_transform(crs=4326) %>% st_geometry() %>% mapview::mapview(native.crs=FALSE)



