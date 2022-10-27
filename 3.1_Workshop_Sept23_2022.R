#Email Tyler: tyler.hampton@uwaterloo.ca
# Workshop Walkthrough September 23, 2022

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


data("world",package = "spData")
head(world)
plot(world)
View(world)


plot(world$geom)


ggplot(data = world)+
  geom_sf()


ggplot(data = world)+
  geom_sf(aes(fill=pop,col=area_km2))

ggplot(data = world)+
  geom_point(aes(x=lifeExp,y=area_km2))

ggplot(data=world)+
  geom_sf(aes(fill=log10(pop)))+
  scale_fill_gradientn(colors=c("blue","red"))

ggplot(data=world)+
  geom_sf(aes(fill=region_un))


Ontario = st_read("data/CanadaCensusShapes/Canada_provinces_Ontario.shp",quiet=FALSE)

world$name_long
"Canada" %in% world$name_long
world$name_long=="Canada"
which(world$name_long=="Canada")

subset(world,name_long=="Canada")

Canada = subset(world,name_long=="Canada")

plot(Canada$geom)

ggplot()+
  geom_sf(data=Canada,col="red",fill="pink")

tm_shape(shp=Canada)+
  tm_polygons()+
tm_shape(shp=Canada)+
  tm_borders(col="red")

Canada
Ontario


ggplot()+
  geom_sf(data=Canada,col="red",fill="pink")+
  geom_sf(data=Ontario)




tm_shape(shp=Canada)+
  tm_polygons()+
  tm_shape(shp=Ontario)+
  tm_polygons()

st_crs(Canada)
raster::crs(Canada)
st_crs(Canada)$proj4string
Canada

st_crs(Ontario)$proj4string


Canada_AEA = st_transform(x=Canada,crs=st_crs(Ontario))

tm_shape(shp = Canada_AEA)+
  tm_polygons()+
  tm_shape(shp = Ontario)+
  tm_polygons()
tm_shape(shp = Canada)+
  tm_polygons()


# retrieved from
# https://github.com/r-tmap/tmap/issues/49
library(tmap)
nc = st_read(system.file("shape/nc.shp", package="sf"))
some_counties <- dplyr::filter(nc, substring(NAME, 1, 1) %in% c("A", "B"))
gridvals <- sf::st_make_grid(nc, n = c(30, 15)) %>% 
  sf::st_cast("MULTILINESTRING")
res <- sf::st_intersection(some_counties, gridvals)

tm_shape(nc) + 
  tm_polygons("SID79")+
  tm_shape(res)+
  tm_lines()
# end retrieved from

# using buffer and rasters, extract values

cities = st_read("data/worldcities/ne_10m_populated_places_simple.shp")

tm_shape(cities)+
  tm_dots(size = "pop_max")

"Canada" %in% cities$sov0name
cacities = subset(cities,sov0name=="Canada")

tm_shape(cacities)+
  tm_dots()

cacities = st_transform(cacities,st_crs(Ontario))

tm_shape(cacities)+
  tm_dots()+
  tm_shape(Ontario)+
  tm_borders()

tm_shape(Ontario)+
  tm_borders()+
  tm_shape(cacities)+
  tm_bubbles(size="pop_max")


# Making a shape out of nothing

tm_shape(Ontario)+
  tm_borders()

# 43°32′09″N 80°13′44″W

Proj_CAAEA = "+proj=aea +lat_0=40 +lon_0=-96 +lat_1=50 +lat_2=70 +x_0=0 +y_0=0 +datum=NAD83 +units=m +no_defs"

guelph.pt = 
data.frame(
  name="Guelph",
  type="City",
  longitude = -(80+13/60),
  latitude = (43+32/60)
) %>%
  st_as_sf(x=.,coords=c("longitude","latitude"),
           crs="EPSG:4326") %>%
  st_transform(.,
               crs="ESRI:102001" # st_crs(Ontario)
                 )

tm_shape(Ontario)+
  tm_borders()+
  tm_shape(guelph.pt)+
  tm_bubbles()



lon=seq(-140,-45,2)
df=data.frame(
  lon=c(lon,rev(lon)),
  lat=c(rep(c(47.6,30),each=length(lon)))) %>%
  rbind(., .[1,])
ggplot(data=df,aes(x=lon,y=lat))+
  geom_path(arrow=arrow(ends="both",type = "closed"))+geom_point()
seattle=df %>% 
  as.matrix()%>%
  list()%>%
  st_polygon()%>%
  st_sfc()%>%
  st_sf(., crs = "EPSG:4326")%>%
  st_transform(.,"ESRI:102001")


tm_shape(Ontario)+
  tm_borders()+
  tm_shape(seattle)+
  tm_borders()


# Raster examples, Section 3
cover = raster::raster("data/canada_2015_land_cover/CAN_NALCMS_2015_v2_land_cover_100m/landcover_SouthernOntario.tif")
coverkey = read.csv("data/canada_2015_land_cover/land_cover_key.csv")
cover
head(cover)
plot(cover)

tm_shape(cover)+
  tm_raster()

guelph.pt = guelph.pt %>% st_transform(.,crs=st_crs(cover))
guelph.pt


guelph.buffer = st_buffer(guelph.pt,dist=50000)

tm_shape(Ontario)+
  tm_borders()+
  tm_shape(guelph.buffer)+
  tm_polygons()+
  tm_shape(guelph.pt)+
  tm_dots()

guelph.cover = raster::crop(cover,extent(guelph.buffer)) %>%
  raster::mask(.,guelph.buffer)


tm_shape(guelph.cover)+
  tm_raster()


guelph.vals = raster::getValues(guelph.cover)



guelph.data = plyr::count(guelph.vals)
names(guelph.data)=c("code","ncells")
guelph.data$pct = guelph.data$ncells/sum(guelph.data$ncells)



test = st_buffer(cacities,50000)
  
