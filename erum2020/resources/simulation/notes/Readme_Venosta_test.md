# GEOtop test simulations for the real time Venosta case study

## Purpose
Prepare a first simulations tests sets for a near-real time, pre-operational case study
to simulate evapotranspiration, soil moisture, snow maps and time series with the **GEOtop v3.0** model.
Those simulations are planned for the **WP6.1** of the **DPS4ESLAB** project.
Simulations are performed by G. Bertoldi, E- Bortoli with the support of A. Costa.

Test area is the **Vinschgau/Venosta Valley** in South Tyrol, (italy).

--------------------------
## Base simulation
Original simulation taken from:
[**Vinschgau_1000_dstr_GEOtop_1_225_9_019**](/shared/data2/Simulations/Simulation_GEOtop_1_225_ZH/Vinschgau/SimTraining/BrJ/Vinschgau/catchment/Vinschgau_1000_dstr_GEOtop_1_225_9_019), which is in the folder:
/shared/data2/Simulations/Simulation_GEOtop_1_225_ZH/Vinschgau/SimTraining/BrJ/Vinschgau/catchment.

Those simulations have been performed in 2014 by G.Bertoldi, S. Della Chiesa, J. Brenner, K. Kofler in the framework of the project **HydroAlp**, to simulate climatic impacts on the water cycle of the Venosta valley.
More info on the HydroAlp project can be found in the [HydroAlp webgis](http://webgis.eurac.edu/hydroalp/)

### History of the old HydroAlp Venosta simulations:

Simulations performed GEOtop V.1.225 on Vinschgau at 1000x1000m resolution, with multipoint input/output and at catchment scale.

You get more info on the simulations here: [Simulation 1000x1000_readme.txt](/shared/data2/Simulations/Simulation_GEOtop_1_225_ZH/Vinschgau/SimTraining/BrJ/Vinschgau/catchment/Simulation 1000x1000_readme.txt).

Settings:
- 20 years simulation  from 1990 to 2009
- simulation originally prepared by Stefano Della Chiesa May 2013
- simulation improved by Christian Kofler July 2013 and by Johannes Brenner August 2013
- 38 meteo input stations  (17 daily P and 17 meteo station with hourly Ta and Rh, plus Transect stations B1, B2, B3)
- fixed wind speed of 2m/s
- Initial Input data and SOIL parameter as WG1 simulation (MaE)
- Soil parameters as in B2 station
- catchment test but run in 1D mode
- point output location B2 station (620815, 5171506) for calibration purpose (soil moisture - 5 and 20cm, evapotranspiration)
- some SWIMM Stations set as potential output cordinates (11)
- bedrock of fixed 2000 mm depth added
- BrJ changed vegetation parameters (rooting depth and LAI according to PlaPaDa database)
- vegetation / soil parametrization according former work (transect) Stefano

Results:
- Reasonable results at B2 comparable to those of transect
- See file Vinschgau_1000_dstr_GEOtop_1_225_9_019_calibration.pdf.
- confirms ET divergent trend along south and north aspect and 2000m elevation gradient along 20 years
- ET: to low, dynamics ok.  monthly ET ok, underestimation in winter (jan,feb)
- SWCtotal = soil_liq + soil_ice, SWC (daily) overestimation, little dynamic reaction to rain

------------------------------------------------------------------
## Test simulations for DPS4ESLAB project

Here are reported the info of all simulations performed

-------------------------------------------------------
#### Sim name: Vinschgau_test_1D_001

**Purpose:**
* test if it is working with GEOtop v3 version

**Settings:**
* as Vinschgau_1000_dstr_GEOtop_1_225_9_019
* 1D simulation

**Results:**
* working

**To dos:**
* parameters and results consistency still to check
* input meteo reading of 34 stations could be improved with Open-MP

-------------------------------------------------------
#### Sim name: Vinschgau_test_1D_002 - 004

**Purpose:**
* crack recovery  recovery / spin-upfeatures in GEOtop

**Settings:**
* as Vinschgau_test_1D_001
* 1D simulation
* changed recovery settings

**Results:**
* understood different recovery / spin-up settings

-------------------------------------------------------
#### Sim name: Vinschgau_test_3D_001

**Purpose:**
* test if it is working with GEOtop v3 version

**Settings:**
* as Vinschgau_1000_dstr_GEOtop_1_225_9_019
* 3D simulation
* Meteo data
  * Most of the input meteo stations have daily inputs
  * Only Mazia transect stations have hourly data
  * constant wind speed of 2 m/s
  * time constant lapse rates
* 11 land cover types
* 9 soil types
* InitWaterTableDepth = 10000
* there is no river network file


**Results:**
* working very slowly
* problems of water budget convegence
* working till the end
* wrong bedrock map equal to aspect

**To dos:**
* parameters and results consistency still to check
* add correct bedrock (1000 mm constant depth)
* update input meteo stations with recent hourly data

-------------------------------------------------------
#### Sim name: Vinschgau_test_3D_002

**Purpose:**
* improve settings of Vinschgau_test_3D_001

**Settings:**
* as Vinschgau_test_3D_001
* constant bedrock depth 1000 mm
* river network map

**Results:**
*

**To dos:**
*
