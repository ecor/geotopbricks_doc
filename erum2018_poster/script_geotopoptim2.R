rm(list=ls())
library(geotopbricks)
library(geotopOptim2)
library(stringr)
library(ggplot2)
library(reshape2)

wpath_sim <- wpath_B2 <- "resources/simulation/Matsch_B2_SMC_ET" 

tz="Etc/GMT-1"

obs <- get.geotop.inpts.keyword.value("ObservationProfileFile",wpath=wpath_B2,data.frame=TRUE,date_field='Date12.DDMMYYYYhhmm.')
str(obs)

####SoilLiq
ltk <- get.geotop.inpts.keyword.value("ObservationLookupTblFile",wpath=wpath_sim,data.frame=TRUE,formatter="",col_sep=";")
head(ltk)
##knitr::kable(ltk)

var <- 'soil_moisture_content_200'
ivar <- which(ltk$obs_var==var)
gtkw  <- ltk[ivar,"geotop_where"]
depth <- as.character(ltk[ivar,"geotop_what"])
gtks <- str_split(gtkw,"[+]")[[1]]
gval <- get.geotop.inpts.keyword.value(gtks,wpath=wpath_B2,data.frame=TRUE,date_field="Date12.DDMMYYYYhhmm.",tz=tz, zlayer.formatter="z%04d")

swc_sim <- do.call(args=gval,what="+")[,depth]
swc_obs <- obs[,var][index(swc_sim)]
df <- data.frame(time=index(swc_sim),obs=swc_obs,sim=swc_sim)
dfm <- melt(df,id="time")

gg <- ggplot(data=dfm,aes(x=time,y=value,col=variable))+geom_line()+theme_bw()

## CUGGINO!!!!

t(gof(obs=df$obs,sim=df$sim))
stop("HERE")

SWC_B2  <- get.geotop.inpts.keyword.value(ltk[ltk$obs_var==var,"geotop_where"],wpath=wpath_B2,data.frame=TRUE,
                                          ,date_field="Date12.DDMMYYYYhhmm.",tz=tz,
                                          zlayer.formatter="z%04d")[,depth]



rm(list=ls())
library(geotopbricks)
library(geotopOptim2)
library(stringr)
library(ggplot2)
library(reshape2)
library(lubridate)
wpath_B2 <- "resources/simulation/Matsch_B2_SMC_ET" 

tz="Etc/GMT-1"

obs <- get.geotop.inpts.keyword.value("ObservationProfileFile",wpath=wpath_B2,data.frame=TRUE,date_field='Date12.DDMMYYYYhhmm.')


ltk <- get.geotop.inpts.keyword.value("ObservationLookupTblFile",wpath=wpath_sim,data.frame=TRUE,formatter="",col_sep=";")



var <- 'soil_moisture_content_200'
ivar <- which(ltk$obs_var==var)
gtkw  <- ltk[ivar,"geotop_where"]
depth <- as.character(ltk[ivar,"geotop_what"])
gtks <- str_split(gtkw,"[+]")[[1]]
gval <- get.geotop.inpts.keyword.value(gtks,wpath=wpath_B2,data.frame=TRUE,date_field="Date12.DDMMYYYYhhmm.",tz=tz, zlayer.formatter="z%04d")

swc_sim <- do.call(args=gval,what="+")[,depth]
swc_obs <- obs[,var][index(swc_sim)]
df <- data.frame(time=index(swc_sim),obs=swc_obs,sim=swc_sim)
dfm <- melt(df,id="time")

gmodobs <- ggplot(data=dfm,aes(x=time,y=value,col=variable))+geom_line()+theme_bw()+ggtitle("20cm-deep soil Water Content vs Time")+ylab("swc")
library(lubridate)
vare <- 'latent_heat_flux_in_air'
om <- geotopLookUpTable(wpath = wpath_sim ,tz=tz)
vv <- str_detect(names(om),vare)
df <- as.data.frame(om[,vv])
df$time <- index(om)
df <- df[year(df$time)==2015,]
dfm <- melt(df,id="time")
gmodobs_e <- ggplot(data=dfm,aes(x=time,y=value,col=variable))+geom_line()+theme_bw()+ggtitle("Real Evapotranspiration vs Time")+ylab("latent heat flux [W/m2]")
