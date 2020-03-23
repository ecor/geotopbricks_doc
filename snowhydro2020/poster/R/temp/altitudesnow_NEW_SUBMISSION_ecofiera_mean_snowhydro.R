# TODO: Add comment
# 
# Author: ecor
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

####wpath <- '/home/ecor/rendena100_sim/trial/rendena100_trial002_in'
wpath <- '/home/ecor/local/simulation/geotop20sim/rendena100m_snow1989_2015_real_scenario/'
wpath45 <- '/home/ecor/local/simulation/geotop20sim/rendena100m_snow1989_2015_lRCP45_modified_scenario/'
wpath85 <- '/home/ecor/local/simulation/geotop20sim/rendena100m_snow1989_2015_modified_scenario/'
sep <- "/"
if (str_sub(wpath,start=-1)==sep) sep <- ""

mmapfolder <- wpathout <- paste(c(wpath,wpath45,wpath85),"external/monthly",sep=sep) ###   '/home/ecor/activity/2017/rendena100/simulation/monthly_maps




alt_map <-  get.geotop.inpts.keyword.value("DemFile",raster=TRUE,wpath=wpath)

dz <- 200
alt_map_z <- ceiling(alt_map/dz)*dz
ss <- "mean"
mapfiles <- list.files(mmapfolder,pattern=".asc",full.name=TRUE) %>% extract(str_detect(.,ss))


names(mapfiles) <- mapfiles ### list.files(mmapfolder,pattern=".asc",full.name=TRUE)

##prefix <- c("nday","mean","max")
##title <- c("Duration (days","Mean Depth (mm)","Max Depth (mm)")
##aggrstack <- c("sum","mean","max")
##names(title) <- prefix
##names(aggrstack) <- prefix
##ss <- "mean"
##ytitle <- title[ss]



##mapfiles <- mapfiles[str_detect(mapfiles,ss)]



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





dfo <- df





cc <- system.time(out <- (df) %>% as.tbl() %>% group_by(scenario,yearw) %>% summarize(file=paste(file,collapse=","),decade=decade[1]) %>% mutate(idcode=paste0(scenario,"_",yearw)))







cm <- system.time(outseas <- out$file %>% str_split(pattern=",") %>% lapply(FUN=stack) %>% lapply(FUN=mean) %>% stack() %>% stack(alt_map_z))
names(outseas) <- c(out$idcode,"altitude")


####
####

####
####

outseas_df <- outseas %>% as.data.frame(xy=FALSE,na.rm=TRUE) %>% melt(id=c("altitude")) 
names(outseas_df)[names(outseas_df)=="variable"] <- "idcode"
outseas_df <- outseas_df %>% as.tbl() %>% group_by(idcode,altitude) %>% summarize(value=mean(value))


oo <- out %>% select(scenario,yearw,decade,idcode) %>% right_join(outseas_df) %>% filter(!is.na(decade)) 
oo2 <- oo %>% group_by(decade,altitude) %>% summarize(q25=quantile(value,probs=0.25),median=median(value),q75=quantile(value,probs=0.75))


##
oo2$scenario_type <- "none"
oo2$scenario_type[oo2$decade %in% c("1996-2005","2006-2015")] <- "Observation"
oo2$scenario_type[oo2$decade %in% c("RCP 4.5","RCP 8.5")] <- "Forecast"
oo2$scenario_type = factor(oo2$scenario_type, levels=c("Observation","Forecast"))

oo2 <- oo2 %>% filter(altitude>=500 & altitude<=2800)

##




###
##stack_ <- function(x,sep=",") str
# cm <- system.time(
#   outseas <- out$file %>% str_split(pattern=",") %>% lapply(FUN=stack) %>% lapply(FUN=mean) %>% stack()
#   names(outseas) <- out$idcode 
#   )



###
title <- c("Duration (days","Mean Depth (mm)","Max Depth (mm)")[2]
ggq <- ggplot(data = oo2, aes(x=altitude,y=median, by=decade, color=decade,fill=decade))+geom_line()
ggq <- ggq+ylab(title)+xlab("Elevation (m a.s.l.)")
## NO TITLE ggggq <- ggq+ggtitle(title)
ggq <- ggq+geom_ribbon(data = oo2, aes(x=altitude,ymax=q75,ymin=q25, color=decade,by=decade,alpha=decade))+scale_alpha_manual(name="Q25-Q75",values=c(0.3,0.3,0.3,0.3),breaks=NULL)

ggq <- ggq+scale_color_manual(name="Decade/Scenario",values=c("blue","green","magenta","orange"),breaks=NULL)
ggq <- ggq+scale_fill_manual(name="Decade/Scenario",values=c("blue","green","magenta","orange"))

ggq <- ggq+theme_bw()
ggq <- ggq+facet_grid(. ~ scenario_type)




# 
# mmstack <- stack(mmap_aggrf,alt_map)
# 
# 
# ###
# 
# 
# mdf <- as.data.frame(mmstack)
# 
# #nyy <- sprintf("Y%04d",year[names(mdf)[names(mdf)!="layer"]])
# #names(mdf)[names(mdf)!="layer"] <- nyy
# names(mdf)[names(mdf)=="layer"] <- "altitude"
# ##stop("HHHH")
# mdfm <- melt(mdf,id="altitude")
# 
# names(mdfm)[names(mdfm)=="value"] <- "aggrfs"
# mdfm <- mdfm[which(mdfm$altitude>=400 & mdfm$altitude<2200),]
# 
# 
# ##mdfm$value <- factor(mdfm$value)
# ##index <- sprintf("%s_%02d",mdfm$variable,mdfm$aggrfs)
# ##stop("MI FERMO QUI")
# dz <- 200
# mdfm$altitude_z <- ceiling(mdfm$altitude/dz)*dz
# ####
# index <- sprintf("%s_%04d",mdfm$variable,mdfm$altitude_z)
# 
# ###
# #aggrfs_min <- tapply(X=mdfm$aggrfs,INDEX=index,FUN=min,na.rm=TRUE)
# #aggrfs_max <- tapply(X=mdfm$aggrfs,INDEX=index,FUN=max,na.rm=TRUE)
# #aggrfs_q25 <- tapply(X=mdfm$aggrfs,INDEX=index,FUN=quantile,probs=0.25,na.rm=TRUE)
# #aggrfs_median <- tapply(X=mdfm$aggrfs,INDEX=index,FUN=median,na.rm=TRUE)
# #aggrfs_q75 <- tapply(X=mdfm$aggrfs,INDEX=index,FUN=quantile,probs=0.75,na.rm=TRUE)
# aggrfs_mean <- tapply(X=mdfm$aggrfs,INDEX=index,FUN=mean,na.rm=TRUE)
# #aggrfs_sd <- tapply(X=mdfm$aggrfs,INDEX=index,FUN=sd,na.rm=TRUE)
# 
# 
# 
# nnn <- names(aggrfs_mean)
# ss <- str_split(nnn,"_")
# 
# 
# dafm <- data.frame(
# 		year=sapply(X=ss,FUN=function(x){as.numeric(x[2])}),
# 		scenario=sapply(X=ss,FUN=function(x){x[3]}),
# 		altitude=as.numeric(sapply(X=ss,FUN=function(x){as.numeric(x[4])})),
# 		stringsAsFactors=FALSE
# 		)
# 
# 
# dafm$aggrfs <- aggrfs_mean[nnn]
# 
# dafm$decade <- "none"
# dafm$decade[dafm$year>=1996 & dafm$year<=2005 & dafm$scenario=="OBS"] <- "1996-2005"
# dafm$decade[dafm$year>=2006 & dafm$year<=2015 & dafm$scenario=="OBS"] <- "2006-2015"
# dafm$decade[dafm$year>=2006 & dafm$year<=2015 & dafm$scenario=="RCP45"] <- "RCP 4.5"
# dafm$decade[dafm$year>=2006 & dafm$year<=2015 & dafm$scenario=="RCP85"] <- "RCP 8.5"
# dafm <- dafm[dafm$decade!="none",]
# #stop("A LUNEDI")
# 
# ####dafm <- dafm[dafm$scenario_type!="none",]
# 
# index2 <- sprintf("%s_%04d",dafm$decade,dafm$altitude)
# 
# 
# zaaggrfs_min <- tapply(X=dafm$aggrfs,INDEX=index2,FUN=min,na.rm=TRUE)
# zaaggrfs_max <- tapply(X=dafm$aggrfs,INDEX=index2,FUN=max,na.rm=TRUE)
# zaaggrfs_q25 <- tapply(X=dafm$aggrfs,INDEX=index2,FUN=quantile,probs=0.25,na.rm=TRUE)
# zaaggrfs_median <- tapply(X=dafm$aggrfs,INDEX=index2,FUN=median,na.rm=TRUE)
# zaaggrfs_q75 <- tapply(X=dafm$aggrfs,INDEX=index2,FUN=quantile,probs=0.75,na.rm=TRUE)
# zaaggrfs_mean <- tapply(X=dafm$aggrfs,INDEX=index2,FUN=mean,na.rm=TRUE)
# zaaggrfs_sd <- tapply(X=dafm$aggrfs,INDEX=index2,FUN=sd,na.rm=TRUE)
# 
# 
# ### 
# ### FARE UN TAPPLTY PER AGGREGARE I GIORNI 
# ##stop("")
# 
# ###index2 <- sprintf("%s_%04d",dafm$decade,dafm$altitude)
# 
# 
# 
# 
# 
# #
# #
# #zaaltitude_q25 <- tapply(X=dafm$altitude_q25,INDEX=index2,FUN=mean,na.rm=TRUE)
# #zaaltitude_q75 <- tapply(X=dafm$altitude_q75,INDEX=index2,FUN=mean,na.rm=TRUE)
# #zaaltitude_median <- tapply(X=dafm$altitude_median,INDEX=index2,FUN=mean,na.rm=TRUE)
# #zaaltitude_mean <- tapply(X=dafm$altitude_mean,INDEX=index2,FUN=mean,na.rm=TRUE)
# #zaaltitude_sd <- tapply(X=dafm$altitude_sd,INDEX=index2,FUN=mean,na.rm=TRUE)
# index3 <- names(zaaggrfs_median)
# sss <- str_split(index3,"_")
# dbfm <- data.frame(
# 		decade=sapply(X=sss,FUN=function(x){x[1]}),
# 		altitude=as.numeric(sapply(X=sss,FUN=function(x){x[2]})),
# 	######	scenario=sapply(X=sss,FUN=function(x){x[3]}),
# 		stringsAsFactors=FALSE
# 		)
# ###
# ###
# 
# dbfm$aggrfs_q25 <- zaaggrfs_q25[index3]
# dbfm$aggrfs_q75 <- zaaggrfs_q75[index3]
# dbfm$aggrfs_median <- zaaggrfs_median[index3]
# dbfm$aggrfs_mean <- zaaggrfs_mean[index3]
# dbfm$aggrfs_sd <- zaaggrfs_sd[index3]
# dbfm$aggrfs_max <- zaaggrfs_max[index3]
# dbfm$aggrfs_min <- zaaggrfs_min[index3]
# 
# dbfm$scenario_type <- "none"
# dbfm$scenario_type[dbfm$decade %in% c("1996-2005","2006-2015")] <- "Observation"
# dbfm$scenario_type[dbfm$decade %in% c("RCP 4.5","RCP 8.5")] <- "Forecast"
# dbfm$scenario_type = factor(dbfm$scenario_type, levels=c("Observation","Forecast"))
# 
# 
# ###gg <- ggplot(data = dbfm, aes(ymin=altitude_q25,ymax=altitude_q75,y=altitude_median,x=aggrf, by=decade, color=decade,fill=decade))+geom_ribbon() ## +geom_line()
# titlem <- paste(sprintf("%02d",monthsel),collapse=",")
# nfilep <- sprintf('/home/ecor/Dropbox/R-packages/OpenRendena100/mapcover/plot/month%s',titlem)
# 
# ## QUANTILES
# 
# nfile <- paste(nfilep,"quantitiles.png",sep="")
# title <- sprintf("Q25-Q50-Q75 Snow Coverage Duration (months %s) vs Elevation" ,titlem)
# ggq <- ggplot(data = dbfm, aes(x=altitude,y=aggrfs_median, by=decade, color=decade,fill=decade))+geom_line()
# ggq <- ggq+ylab(ytitle)+xlab("Elevation (m a.s.l.)")
# ## NO TITLE ggggq <- ggq+ggtitle(title)
# ggq <- ggq+geom_ribbon(data = dbfm, aes(x=altitude,ymax=aggrfs_q75,ymin=aggrfs_q25, color=decade,by=decade,alpha=decade))+scale_alpha_manual(name="Q25-Q75",values=c(0.3,0.3,0.3,0.3),breaks=NULL)
# 
# ggq <- ggq+scale_color_manual(name="Decade/Scenario",values=c("blue","green","magenta","orange"),breaks=NULL)
# ggq <- ggq+scale_fill_manual(name="Decade/Scenario",values=c("blue","green","magenta","orange"))
# ggq <- ggq+facet_grid(. ~ scenario_type)
# ggq <- ggq+theme_bw()
# ##ggm <- ggm+geom_ribbon(data = dbfm, aes(x=altitude,ymax=aggrfs_max,ymin=aggrfs_min, color=decade,by=decade,alpha=decade))+scale_alpha_manual(name="min-max",values=c(0.1,0.1))
