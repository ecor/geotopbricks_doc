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

wpath <- '/home/ecor/local/simulation/geotop20sim/rendena100m_snow1989_2015_real_scenario/'
wpath45 <- '/home/ecor/local/simulation/geotop20sim/rendena100m_snow1989_2015_lRCP45_modified_scenario/'
wpath85 <- '/home/ecor/local/simulation/geotop20sim/rendena100m_snow1989_2015_modified_scenario/'
sep <- "/"
if (str_sub(wpath,start=-1)==sep) sep <- ""
## SNOW MAPS DIRECTORY
mmapfolder <- wpathout <- paste(c(wpath,wpath45,wpath85),"external/monthly",sep=sep)
# ELEVATION MAP
alt_map <-  get.geotop.inpts.keyword.value("DemFile",raster=TRUE,wpath=wpath)
dz <- 200
alt_map_z <- ceiling(alt_map/dz)*dz
ss <- "mean"
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

cc <- system.time(out <- (df) %>% as.tbl() %>% group_by(scenario,yearw) %>% summarize(file=paste(file,collapse=","),decade=decade[1]) %>% mutate(idcode=paste0(scenario,"_",yearw)))

## Aggregate maps of seasonal mean snow depth
cm <- system.time(outseas <- out$file %>% str_split(pattern=",") %>% lapply(FUN=stack) %>% lapply(FUN=mean) %>% stack() %>% stack(alt_map_z))
names(outseas) <- c(out$idcode,"altitude")

## Casting to data frame and melting
outseas_df <- outseas %>% as.data.frame(xy=FALSE,na.rm=TRUE) %>% melt(id=c("altitude")) 
names(outseas_df)[names(outseas_df)=="variable"] <- "idcode"
## Averaging for each altitude band 
outseas_df <- outseas_df %>% as.tbl() %>% group_by(idcode,altitude) %>% summarize(value=mean(value))

## Right join between 'out' and 'outseas_df'  tables (tibbles) 
oo <- out %>% select(scenario,yearw,decade,idcode) %>% right_join(outseas_df) %>% filter(!is.na(decade)) 
oo2 <- oo %>% group_by(decade,altitude) %>% summarize(q25=quantile(value,probs=0.25),median=median(value),q75=quantile(value,probs=0.75))


## DownStream selection
oo2$scenario_type <- "none"
oo2$scenario_type[oo2$decade %in% c("1996-2005","2006-2015")] <- "1.Observation"
oo2$scenario_type[oo2$decade %in% c("RCP 4.5","RCP 8.5")] <- "2.Forecast"
oo2$scenario_type = factor(oo2$scenario_type, levels=c("1.Observation","2.Forecast"))

oo2 <- oo2 %>% filter(altitude>=500 & altitude<=2800)

file_oo2 <- '/home/ecor/local/rpackages/geotopbricks_doc_private/snowhydro2020/poster/R/output/'
file_oo2 <- '/home/ecor/local/rpackages/geotopbricks_doc_private/snowhydro2020/poster/resources/data/'
file_oo2_csv <- file_oo2 %>% paste0("mean_altitude.csv")
write.table(oo2,file=file_oo2_csv,sep=",",row.names = FALSE,quote=FALSE)

