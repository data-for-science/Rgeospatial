INSTALL BEFORE WORKSHOP
================
Tyler Hampton

# Update RStudio and R

Be sure to be running the newest version of RStudio.

Be sure to be running R version 4.3 or greater.

[How to Update R on
Windows](https://bootstrappers.umassmed.edu/bootstrappers-courses/courses/rCourse/Additional_Resources/Updating_R.html)

[How to Update R on
Mac](https://www.linkedin.com/pulse/3-methods-update-r-rstudio-windows-mac-woratana-ngarmtrakulchol/)

# Install or Update Packages

In order to equip R with functionality for gis data, we need to load or
install several packages. Because this is an intermediate+ workshop, I
have code written in sometimes complicated formats, but I will do my
best to explain what I am doing. There are many ways to do the same
thing in R. Similarly, there are many different packages in R that can
handle the same types of data. We will use the pairing of the *ggplot2*
and *sf* packages. We’ll load several other packages we’ll use. In
particular, the *spData* package contains lots of open-source geospatial
data that we can use! For the most current version, we need to access
the github code repository for *spDataLarge*. A list of data is here:
<https://cran.r-project.org/web/packages/spData/spData.pdf>

``` r
#this is a custom function that that can load multiple packages at once
loadpackages=function(packages){  for(p in packages){
  if(!require(p,character.only=T)){install.packages(p)}
  # IF require returns FALSE, the package is missing and will be installed
  library(p,character.only=T,quietly=T,verbose=F)
  # next, it calls the package with library
  }} 


loadpackages(c(
           "tmap", # Thematic Map Visualization, makes maps!
           "ggplot2", # Makes ggplots! Can also make maps
           "sf",   # "Simple Features", handles vector data
           "raster", # For working with Raster Data
           "terra", # A newer package for working with Raster data
           "ggrepel", # Labels on ggplots
           "plyr", # The split-apply-combine paradigm
           "data.table", # Works with data.frames
           "dplyr", # Data manipulation
           "purrr", # Functional Programming Tools
           "devtools", # Download custom R packages
           "spData" # Spatial Datasets
           ))

if(!require("dfsspatdat",character.only=T)){
  options(timeout = 400) # Download time may approach 400 seconds
  devtools::install_github("data-for-science/dfs_spatdat")
}
# devtools::install_github installs a package from its github directory
library(dfsspatdat)

if(!require("spDataLarge",character.only=T)){
  devtools::install_github("Nowosad/spDataLarge")
}
library(spDataLarge)
```
