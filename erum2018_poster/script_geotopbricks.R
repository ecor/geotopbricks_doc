rm(list = ls())
library(geotopbricks) 
library(ggplot2)
library(reshape2)
## SET GEOTOP WORKING DIRECTORY
wpath_B2 <- "resources/simulation/Matsch_B2_Ref_007" 

## See  'get.geotop.geetop.inpts.keyword.value' 
## help(get.geotop.inpts.keyword.value,help_type="html")
###Getting soil water content (SWC)
###
SWC_B2  <- get.geotop.inpts.keyword.value("SoilLiqContentProfileFile",wpath=wpath_B2,data.frame=TRUE,
                                          ,date_field="Date12.DDMMYYYYhhmm.",tz="Etc/GMT-1",
                                          zlayer.formatter="z%04d")

wpath_P2 <- "resources/simulation/Matsch_P2_Ref_007" 
SWC_P2  <- get.geotop.inpts.keyword.value("SoilLiqContentProfileFile",wpath=wpath_P2,data.frame=TRUE,
                                          ,date_field="Date12.DDMMYYYYhhmm.",tz="Etc/GMT-1",
                                          zlayer.formatter="z%04d")

## Box Plot
time <- index(SWC_B2)
SWC_B2_18cm <- SWC_B2[,"z0018"]
SWC_P2_18cm <- SWC_P2[,"z0018"]
## Daily Aggregation
SWC_B2_18cm_aggr <-aggregate(x=SWC_B2_18cm,by=as.Date(index(SWC_B2)), FUN=mean)
SWC_P2_18cm_aggr <-aggregate(x=SWC_P2_18cm,by=as.Date(index(SWC_P2)), FUN=mean)
months <- as.character(index(SWC_B2_18cm_aggr),format="%m-%Y")
df <- data.frame(month=months,P2=as.vector(SWC_P2_18cm_aggr),B2=as.vector(SWC_B2_18cm_aggr))
dfp <- df[df$month %in% c("08-2010","08-2011","08-2012","08-2013","08-2014"),]
dfpm <- melt(dfp,id="month")

SWC_Boxplot <- ggplot(dfpm, aes(x=as.factor(month), y=value))+geom_boxplot()
SWC_Boxplot <- SWC_Boxplot+ggtitle("Box Plot: Daily Soil Water Content")+ylab("SWC")+xlab("")+theme_bw()+facet_grid(. ~ variable)
show(SWC_Boxplot)

### METEO_DATA
meteo_B2  <- get.geotop.inpts.keyword.value("MeteoFile",wpath=wpath_B2,data.frame=TRUE)
meteo_P2  <- get.geotop.inpts.keyword.value("MeteoFile",wpath=wpath_P2,data.frame=TRUE)
ipreckey <- get.geotop.inpts.keyword.value("HeaderIPrec",wpath=wpath_B2)
## WARNING: in this case meteo data has an hourly frequency. 
meteo_B2_aggr <-aggregate(x=meteo_B2,by=as.Date(index(meteo_B2)),FUN=mean,na.rm=TRUE)
meteo_B2_aggr$prec <- meteo_B2_aggr[,ipreckey]*24
meteo_B2_aggr_time <-  index(meteo_B2_aggr)
meteo_B2_aggr <- as.data.frame(meteo_B2_aggr)
meteo_B2_aggr$time <- meteo_B2_aggr_time
meteo_B2_aggr$month <- as.character(meteo_B2_aggr$time,format="%m-%Y")

meteo_B2_aggr <- meteo_B2_aggr[meteo_B2_aggr$month %in% c("08-2010","08-2011","08-2012","08-2013","08-2014"),]
valmin <- 0.9
meteo_B2_aggr_p <- meteo_B2_aggr[meteo_B2_aggr$prec>valmin,]
prec_Boxplot <- ggplot(meteo_B2_aggr_p, aes(x=as.factor(month), y=prec))+geom_boxplot()
prec_Boxplot <- prec_Boxplot+ggtitle("Daily Precipitation Depth in the rainy days")+ylab("Precipitation [mm]")+xlab("")+theme_bw()

show(prec_Boxplot)

### MONTHLY SUM 

monthlyprec <- tapply(X=meteo_B2_aggr$prec,INDEX=meteo_B2_aggr$month,FUN=sum)
xx <- names(monthlyprec)
prec_barplot <- ggplot(data=NULL, aes(x=xx, y=monthlyprec))+geom_bar(stat="identity")+theme_bw()
prec_barplot <- prec_barplot+ylab("Monthly Precipitation Depth [mm]")+xlab("")

show(prec_barplot)

### MONTHLY COUNT 
print(valmin)
perc_ <- function(x,valmin=valmin) {
  
  print(x)
  print(valmin)
  length(which(x>valmin))/length(x)*100}
nmonthlyprec <- tapply(X=meteo_B2_aggr$prec,INDEX=meteo_B2_aggr$month,FUN=perc_,valmin=valmin)
xx <- names(nmonthlyprec)
nprec_barplot <- ggplot(data=NULL, aes(x=xx, y=nmonthlyprec))+geom_bar(stat="identity")+theme_bw()
nprec_barplot <- nprec_barplot+ylab("Monthly Rainy Days [%]")+xlab("")

show(nprec_barplot)
dev_off()
par(mfrow=c(1,2))

###
#http://www.cookbook-r.com/Graphs/Multiple_graphs_on_one_page_(ggplot2)/
###
# Multiple plot function
#
# ggplot objects can be passed in ..., or to plotlist (as a list of ggplot objects)
# - cols:   Number of columns in layout
# - layout: A matrix specifying the layout. If present, 'cols' is ignored.
#
# If the layout is something like matrix(c(1,2,3,3), nrow=2, byrow=TRUE),
# then plot 1 will go in the upper left, 2 will go in the upper right, and
# 3 will go all the way across the bottom.
#
multiplot <- function(..., plotlist=NULL, file, cols=1, layout=NULL) {
  library(grid)
  
  # Make a list from the ... arguments and plotlist
  plots <- c(list(...), plotlist)
  
  numPlots = length(plots)
  
  # If layout is NULL, then use 'cols' to determine layout
  if (is.null(layout)) {
    # Make the panel
    # ncol: Number of columns of plots
    # nrow: Number of rows needed, calculated from # of cols
    layout <- matrix(seq(1, cols * ceiling(numPlots/cols)),
                     ncol = cols, nrow = ceiling(numPlots/cols))
  }
  
  if (numPlots==1) {
    print(plots[[1]])
    
  } else {
    ```
    
    Here is a GEOtop simulation  folder with observation: 
      
      ```{r echo=TRUE,eval=FALSE,collapse=TRUE}
    tz <- "Etc/GMT-1"
    
    wpath <- system.file('geotop-simulation/B2site',package="geotopOptim2")
    
    
    ```
    
    Here is the full name (with complete path) of GEOtop executable built file: 
      
      ```{r echo=TRUE,eval=TRUE,collapse=TRUE}
    
    
    bin  <-'/home/ecor/local/geotop/GEOtop/bin/geotop-2.0.0' 
    
    ```
    
    In most cases, geotopOptim2 copies the simulation folder and run GEOtop with modified calibration input parameters in temporary directories:  
      
      ```{r echo=TRUE,eval=TRUE,collapse=TRUE}
    
    
    ## LOcal path where to write output for PSO
    runpath <- "/home/lv70864/ecordano/temp/geotopOptim_tests"
    runpath <- "/home/ecor/temp/geotopOptim_tests"
    
    
    ```
    
    The function **geotopExec** running a GEOtop simulation can enter a vector of paratemers which are replaced with the ones formerly set in the original simulation directory **wpath** . Analogously the function **geotopPSO** performing a PSO calibration of GEOtop through **geotopExec** and **geotopGOF** needs two vectors: one for upper values, the other for lower values.   A set of soil calibration parameters can be set though a csv file.  
    ```{r,eval=FALSE}
    
    help(geotopExec,help_type="html")
    help(geotopGOF,help_type="html")
    help(geotopPSO,help_type="html")
    ```
    Here is an example that can be downloaded by package examples:
      
      ```{r echo=TRUE,eval=TRUE,collapse=TRUE}
    
    geotop.soil.param.file <-  system.file('examples-script/param/param_pso_c003.csv',package="geotopOptim2") 
    geotop.soil.param <- read.table(geotop.soil.param.file,header=TRUE,sep=",",stringsAsFactors=FALSE)
    lower <- geotop.soil.param$lower
    upper <- geotop.soil.param$upper
    suggested <- geotop.soil.param$suggested
    names(lower) <- geotop.soil.param$name
    names(upper) <- geotop.soil.param$name
    names(suggested) <-  geotop.soil.param$name
    
    
    
    knitr::kable(geotop.soil.param)
    
    ```
    
    Here is the columns **lower** and **upper** stand for lower and upper values whereas the **suggested** column contains initial guess values for **geotopPSO**.  Generally a good practical examples on how to set  these parameters is given below: 
      
      ```
    prefix__name,lower,upperGrenarally 
    SOIL__N,1.45,1.89
    SOIL__Alpha,0.00131,0.0131
    SOIL__ThetaSat,0.41,0.53
    SOIL__ThetaSat_bottomlayer,0.08,0.09
    SOIL__ThetaRes,0.05,0.07
    SOIL__LateralHydrConductivity,0.0923,0.1
    SOIL__NormalHydrConductivity,0.0923,0.1
    SOIL__LateralHydrConductivity_bottomlayer,0.00923,0.01
    SOIL__NormalHydrConductivity_bottomlayer,0.00923,0.01
    SOIL__SoilInitPresL0001,-10000,100
    SOIL__SoilInitPresL0002,-10000,100
    SOIL__SoilInitPresL0003,-10000,100
    SOIL__SoilInitPresL0004,-10000,100
    SOIL__SoilInitPresL0005,-10000,100
    SOIL__SoilInitPresL0006,-10000,100
    SOIL__SoilInitPresL0007,-10000,1000
    SOIL__SoilInitPresL0008,-10000,1000
    SOIL__SoilInitPresL0009,-10000,0
    SOIL__PsiGamma,0.5,1
    SOIL__SoilDepth,3000,30000
    SOIL__NumberOfSoilLayers,9,20
    VECTOR_1_LSAI,2,4
    ```
    
    where "N", "Alpha", "ThetaSat", "LateralHydrConductivity", "NormalHydrConductivity", "ThetaRes",,.. are GEOtop keyword referred to the respective soil parameters. By default, "geotopPSO" considers soil parameters uniformly distributed within the soil profile unless they are repated in the CSV file with some suffixes, like "_bottomlayer"  or "_ALL". In "_bottomlayer" case, the parameter (upper and lower) values are referred to the first (near surface) layer and the last (bottom) layer and the values of internal layers are exponentially interpolated. In this case a decrease of hydraulic conductivity or soil porosity can be modeled. In "_ALL" case, soil parameter is taken as variables with soil layers. So the reported values refer to a range for so many soil parameter of the same type how many the soil layers are. If the keywords contains the suffix "_V_L%04d" with the decimal formatter, the soil parameter is calibrated only for the soil specific layer. 
    The keyword "SoilInitPres" refers to the initial soil water pressure head. If the formatter "L%04d" is appended as a suffix, the value is referred to the indicated layer. The keyword "PsiGamma" refers to the soil water pressure gradient along the terrain-normal downward direction and is applied to calculate initial soil water pressure head in the above layers assuming a continuous profile. 
    "SoilDepth" and "NumberOfSoilLayers" refer to the whole soil depth (which now corresponds to the whole soil column used as domain for balance equation integration) and the number of soil layers in which the soil column is divided. Soil layer thickness increase with depth following a geometric progression.
    
    Then,the target variables are here set :
      
      
      
    ```{r echo=TRUE,eval=FALSE,collapse=TRUE}
   
    var <- 'soil_moisture_content_50'
    x <- (upper+lower)/2
   
    
    ```
    
    
    ```{r echo=TRUE,eval=FALSE,collapse=TRUE}
    
    pso <- geotopPSO(par=suggested,run.geotop=TRUE,bin=bin,
                     simpath=wpath,runpath=runpath,clean=TRUE,data.frame=TRUE,
                     level=1,intern=TRUE,target=var,gof.mes="RMSE",lower=lower,upper=upper,control=control)
    
    
    
    
    
    if (USE_RMPI==TRUE) mpi.finalize()
    
    ```
    
    
    Note the various macros within the `vignette` section of the metadata block above. These are required in order to instruct R how to build the vignette. Note that you should change the `title` field and the `\VignetteIndexEntry` to match the title of your vignette.
    
    
    ## Examples: 
    
    Examples of simulations to optimize could be found here <https://github.com/EURAC-Ecohydro/geotopOptim2/tree/master/inst/examples_script>
      
      Examples of scripts to launch optimization in background on a cluster for the EURAC Monalisa dataset could be found here:
      <https://github.com/EURAC-Ecohydro/MonaLisa/tree/master/Rscript>
      
    # Set up the page
    grid.newpage()
    pushViewport(viewport(layout = grid.layout(nrow(layout), ncol(layout))))
    
    # Make each plot, in the correct location
    for (i in 1:numPlots) {
      # Get the i,j matrix positions of the regions that contain this subplot
      matchidx <- as.data.frame(which(layout == i, arr.ind = TRUE))
      
      print(plots[[i]], vp = viewport(layout.pos.row = matchidx$row,
                                      layout.pos.col = matchidx$col))
    }
  }
}



multiplot(prec_barplot,nprec_barplot,cols=2)

## http://www.cookbook-r.com/Graphs/Multiple_graphs_on_one_page_(ggplot2)/
  

