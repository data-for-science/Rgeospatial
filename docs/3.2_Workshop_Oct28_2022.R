#Email Tyler: tyler.hampton@uwaterloo.ca
# Workshop Walkthrough October 28, 2022

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

##
# We will start from the very very basics, and increase complexity to 
# talking about objects and functions

1+1
x=1
x <- 1
a = 2
b= 3
c <- 7
x+x
x*a
x^a
b/c
# indivudal "things", "atoms"
population = c(1,2,5,7,8,10) # result is a vector, a group of atoms
population
# use hashtag to save a comment
# write something that isn't code

# functions you'll see frequently
# the packages we most often use are base, then stats and utils
# c() #concatenate
# rep()

rep(x,6)
rep(6,x) # how did we know what order to put the function inputs?

# to get help, type question mark or hit the F1 key on Windows
#  while your cursur is in the text of the function
?rep
rep.int(x,6)
rep_len(x,6)


# we want coefficient of variation
# from the help menu we leaned about sd for standard deviation
population
# helpful variable names
sdp = sd(population)
mup = mean(population)
# CV = sd/mean
sd(population)/mean(population)
# the output of a function is either just a number in your console, or 
#    a new object
CVp = sd(population)/mup
CVp = sdp/mup
CVp
# CV = 0.64

# naming objects
# mashing up objects and functions
# custom functions, multiple inputs

# in R, squiggly brackets always means functions
# here we create the functin with squiggly
coefvar = function(x){
  sd = sd(x)
  mu = mean(x)
  cv = sd/mu
  return(cv)
}  # the squiggly bracket surrounds what happens in the function
coefvar(population)
CVp = coefvar(population)
CVp
# spaces and indents, spaces don't matter

# making custom functions:
# make a "swiss army knife" function
# example with multiple function inputs
swiss = function(x,output){
  sd = sd(x)
  mu = mean(x)
  cv = sd/mu
  if(output=="sd"){return(sd)} # text strings are surrounded by quotes
  if(output=="mu"){return(mu)}
  if(output=="cv"){return(cv)}
}

# comment about Boolean
# if statements, 
x == x # double equal, if equal is the statement
a == a
(a+x) == b
x == b
a < b # greater and less than
a > x
b < x
population
x %in% population # %in%
length(population)
population %in% x
population==x
x==population
population == 5

# for help, get the yellow helper box when typing, or hit tab key
swiss(population,"sd")
# inputs, if in right order, dont need to be named
swiss(output="mu",x=population)
swiss(population,"mu")
swiss(population,"cv")

# atoms
# vectors, created by the c function
#     also created by functions like rep
six = rep(x,6)
six
population
seq(from=1,to=10,by=2)
 # how do we know this is a vector?


# other object types
# dataframes
# the function to create is data.frame
# data frames are created by reading in a csv, or brand new from vectors
df = data.frame(
  c("a","b","c"),
  seq(1,7,by=3)
)

df
u = "a text string"
u
colnames(df)=c("letters","numbers") # make the names pretty
df
df = data.frame(
  "letters"=c("a","b","c"),
  "numbers"=seq(1,7,by=3) # confusing is that letters and numbers aren't in quotes
)
df
df = data.frame(
  letters=c("a","b","c"),
  numbers=seq(1,7,by=3) # confusing is that letters and numbers aren't in quotes
)
df
# names and colnames, acting on a dataframe, give the same output
df
View(df)
# use the View function,  or open in Excel, to examine your data, check for
#   flaws or characteristics

# Evaluate your dataframe, sanity checks
names(df)
dim(df) # dimensions
# the return is numebr of rows then columns
# 3 2
nrow(df)
ncol(df)

head(df,n=2) # head and dim are the two most important
tail(df,n=2)
# gives the top or bottom, head() or tail(), defaults to six rows

df
str(df) # structure
summary(df)
names(df)
# navigating datasets

df

# to navigate columsn, use money sign
df$letters
df$numbers

df$letters == c("a","b","c")


# indices indicate data struction
# indices are surrounded by square brackets
# () we know this means ?? some function is happening here?
# {} we know this means some kind of custom function
#      means you are creating a custom function or a custom sequence of functions (read into "apply" family of functions, sapply, lapply)
# [] we know this means indices of some kind

# how do we know it's a vector if functions used for "higher dimension" objects
#   e.g. dataframe, with (x,y) row and column directions, don't work
dim(population)
nrow(population)

length(population)
nrow(df)
length(df)

twohundred = seq(1,200,by=1)

# to know it is a vector, we look for the indices, there is 
# only "one dimension" to this object


df$letters[2]
df$numbers[3]
df$letters[4]

# use the form row, comma, column
df[2,2] # second column is numbers, retrieve second row
names(df)
df[3,1]

df$letters
df[,1] # leave the space for row empty to return all rows, comma,  then 
       #    first column
df[1,] # leave the space for column empty returns first row, both columns
df[2,]
df[3,]
df[4,] # but not the fourth row because it doesn't exist


# Actually working with geospatial data!
#install.packages("spData")
library("spData")
library("sf")
library("data.table")
library("ggplot2")

# the tidyverse, a dataframe correlary called a tibble

data("world",package = "spData")

dim(world)
head(world)
names(world)
str(world)
summary(world)

head(world$name_long)

world$name_long[4]
world$area_km2[4]

world = setorder(world,-area_km2)
head(world)

seq(1,6,1)
c(1:6)
c(1,2,3,4,5,6)
1:6

world[1,]
world[1:6,]

# aesthetics determines plot characteristics
ggplot(
  data=df, # first you add data
  aes(x=letters,y=numbers), #then add aesthetics
  )+ # then plus sign, not literally doing addition
  geom_point() # then add your "geom"

ggplot(data=df)

ggplot(data=df,aes(x=letters,y=numbers))

ggplot(data=df,aes(x=letters,y=numbers))+
  geom_col()
# geom_col for column plot

ggplot(data=head(world),aes(x=name_long,y=area_km2))+geom_col() 

# information in "top" ggplot call applies to all geoms
ggplot(data=head(world),aes(x=name_long,y=area_km2))+
  geom_col()+
  geom_point()


ggplot()+
  geom_col(
    data=head(world),aes(x=name_long,y=area_km2)
  )
# if the data and aesthetics are in the geom, 
#   then it only applies to that geom


ggplot(data=world)+
  geom_sf()
# note that I didn't have to identify aesthetics
#  in order to get a boring map


# explore other aesthetics to get more information
ggplot()+
  geom_col(
    data=head(world),
    aes(
      x=name_long,y=area_km2,fill=continent
        )
  )

ggplot()+
  geom_col(
    data=world,
    aes(
      x=name_long,y=area_km2,fill=continent
    )
  )

ggplot(data=world)+
  geom_sf(aes(fill=continent))

ggplot(data=world)+
  geom_sf(aes(fill=pop))

ggplot(data=world)+
  geom_sf(aes(fill=log10(pop)))

ggplot(data=world)+
  geom_sf(aes(fill=log10(gdpPercap)))

# how to add information


readdata = as.data.frame(world)
head(readdata)
readdata=subset(readdata,select=-geom)
head(readdata)

world = subset(world,select=c(name_long,geom))
head(world)


ggplot(data=world)+geom_sf()

# join together the data
# need a function called join, specifically left_join

?left_join
?join # can be found in dplyr package

library(dplyr) # package name doesn't need to be in quotes

# left join prioritizes the rows in the first thing, "x"
world = left_join(world,readdata,by="name_long")

head(world)
names(world)

data("coffee_data",package = "spData")
head(coffee_data)

world = left_join(world,coffee_data,by="name_long")

ggplot(data=world)+
  geom_sf(aes(fill=coffee_production_2016))


# Reading in Data
# for vector data, read function is read_sf()

prov = read_sf("data/CanadaCensusShapes/Canada_provinces.shp")
prov

# when looking on the internet, you might find help
# guides with functions like readOGR, these are now out of use

ggplot(data=prov)+geom_sf(aes(fill=Pop16))

# ggplot is ok for maps, ggplot is great if you're familiar with it
# a package called tmap is new and shiny and great for both
# vector and raster


# transition to raster

library(tmap)
library(raster)
cover = raster(file.path("data",
                         "canada_2015_land_cover",
                         "CAN_NALCMS_2015_v2_land_cover_100m",
                         "landcover_SouthernOntario.tif"))

coverkey = read.csv("data/canada_2015_land_cover/land_cover_key.csv")

rgb2hex <- function(r,g,b) rgb(r, g, b, maxColorValue = 255)
coverkey$HEX = sapply(1:nrow(coverkey),function(i){
  rgb2hex(coverkey$Red[i],coverkey$Green[i],coverkey$Blue[i])})

# look up factors
# factors apply an inherent order to character values

df
df$letters = factor(df$letters,levels=c("c","b","a"))
df$letters
df$numbers = factor(df$numbers)
ggplot(data=df,aes(x=letters,y=numbers))+geom_point()
# ggplot likes to do things alphabetically

cover=as.factor(cover)

# instead of ggplot()
tm_shape(cover)+
  tm_raster()


key = levels(cover)[[1]] # for another time, the double square bracket is a special index
key = left_join(key,subset(coverkey,select=c(ID,code,HEX)),by="ID")
levels(cover) = key

tm_shape(cover)+
  tm_raster(palette=levels(cover)[[1]]$HEX,style="cat",showNA=FALSE)

# Question: how to zoom in a map
ggplot(data=world)+
  geom_sf()+
  #ylim()+xlim()+
  #coord_cartesian()+ in a regular plot, coord_cartesion won't
  #      cut off data, especially relevant for boxplots
  coord_sf(xlim = c(-80,-60),ylim=c(40,60))
# coord_sf is the correlary for geomspatial maps
