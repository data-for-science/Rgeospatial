#Email Tyler: tyler.hampton@uwaterloo.ca
# Workshop Walkthrough October 28, 2022
# Workshop jamboard https://jamboard.google.com/d/1aXCueccoBW81wtVrWvNYl2seoWBao-OZfRIYbQQiu-8/edit?usp=sharing

loadpackages=function(packages){  for(p in packages){
  if(!require(p,character.only=T)){install.packages(p)}
  # IF require returns FALSE, the package is missing and will be installed
  library(p,character.only=T,quietly=T,verbose=F)}} # next, it calls the package with library

loadpackages(c(
  "ggplot2", # Makes ggplots!
  "sf",   # "Simple Features", handles vector data
  "raster", # For working with Raster Data
  "rgdal", # 'Geospatial' Data Abstraction Library
  # note: rgdal will be retired by the end of 2023
  "tmap", # Thematic Map Visualization
  "ggsn", # Several scale bars for maps
  "ggrepel", # Labels on ggplots
  "maptools", # Manipulating geographic data
  # note: maptools will be retired by the end of 2023
  "plyr", # The split-apply-combine paradigm
  "data.table", # Works with data.frames
  "dplyr", # Data manipulation
  "purrr", # Functional Programming Tools
  "devtools", # Download custom R packages
  "spData" # Spatial Datasets
))

if(!require("spDataLarge",character.only=T)){devtools::install_github("Nowosad/spDataLarge")}
