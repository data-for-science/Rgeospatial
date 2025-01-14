Geospatial Analysis and Visualization in R
================
Tyler Hampton

- [GIS with R Tutorial](#gis-with-r-tutorial)
  - [What is a GIS, and what are geospatial
    data?](#what-is-a-gis-and-what-are-geospatial-data)
  - [Map Possibilities with R](#map-possibilities-with-r)
  - [Importance of Projection](#importance-of-projection)
  - [GIS Operations](#gis-operations)
  - [Adjust Settings, Load Packages](#adjust-settings-load-packages)
- [Section 1: Working with Vector
  Data](#section-1-working-with-vector-data)
  - [Examining Geospatial Vector
    Data](#examining-geospatial-vector-data)
  - [Plotting World borders with
    tmap](#plotting-world-borders-with-tmap)
  - [Plotting World borders with
    ggplot2](#plotting-world-borders-with-ggplot2)
  - [Beneath the Trunk: Vector Shapes from
    Scratch](#beneath-the-trunk-vector-shapes-from-scratch)
- [Section 2: Reviewing Map and Shape
  Projections](#section-2-reviewing-map-and-shape-projections)
  - [Reprojecting Vector Data](#reprojecting-vector-data)
  - [Reproject Canada](#reproject-canada)
- [Section 3: Geospatial Operations](#section-3-geospatial-operations)
  - [Operations: Merge, Union, Dissolve,
    Intersect](#operations-merge-union-dissolve-intersect)
    - [Merge](#merge)
    - [Union](#union)
    - [Dissolve](#dissolve)
    - [Intersection](#intersection)
  - [Operation: Intersection](#operation-intersection)
  - [Operation: Dissolve](#operation-dissolve)
  - [Operation: Join](#operation-join)
  - [Operation: Buffer](#operation-buffer)
- [Section 4: Map Aesthetics](#section-4-map-aesthetics)
  - [Joining data](#joining-data)
- [Section 5. Working with Raster
  Data](#section-5-working-with-raster-data)
  - [Raster Data Format](#raster-data-format)
  - [Plotting Raster Data](#plotting-raster-data)
    - [Plot Aesthetics, Multiple Objects with
      tmap](#plot-aesthetics-multiple-objects-with-tmap)
  - [Modifying Raster Data: Mask](#modifying-raster-data-mask)
  - [Projections and Raster Data](#projections-and-raster-data)
  - [More Raster Practice: Multiband
    Imagery](#more-raster-practice-multiband-imagery)
  - [Extracting Data from Rasters](#extracting-data-from-rasters)
  - [Working with Multiple Rasters](#working-with-multiple-rasters)

# GIS with R Tutorial

This introduction to geospatial analysis and visualization in R will
cover the following topics:

- Working with Vector Data
- Working with Raster Data
- Projections and Coordinate Transformations
- Subsetting, Clipping, and Cropping Data
- Making and Saving Maps

For an external resource, check out the textbook [“Geocomputation with
R”](https://r.geocompx.org/) by Robin Lovelace and others. I derived
some of the following excercises from the book.

Please work your way through the tutorial and ask any questions you may
have!

P.S. This document was generated using R Markdown. This is a great tool
for code transparency and data analysis, because the code blocks, code
outputs, and your comments are “knitted” into a single document! Ask us
more about this

## What is a GIS, and what are geospatial data?

A GIS or Geographic Information System stores, organizes, manages,
creates, processes, analyzes … or does anything to geospatial data! When
you create a map, you are most likely using a GIS software to bring in
all your data to layer multiple types of information. But before you
ever create a map, you often need to process, alter, combine, analyze
several data streams to reveal some meaning or answer a question.
Sometimes you use a GIS to alter geospatial data so heavily, it ends up
being just a number! But it’s always important to understand and
visualize where data came from, and especially the characteristics of
that data, including resolution, accuracy, age, frequency, and other
assumptions.

<img
src="https://2012books.lardbucket.org/books/geographic-information-system-basics/section_05/f2619b76bb0d1d0f74b0e8d80ba33496.jpg"
style="width:33.0%" alt="Example of Geospatial Data" /> The best data we
have are still abstractions of the real world. We are limited by the
resolution of our data. The major tenant of GIS is drawing conclusions
about the world based on spatial/topological relationships and
distributions.

Some example questions we might ask using a GIS: *What is the shortest
route from me to the pizza store? *How does rainfall vary with
elevation? *What land use is most frequented by the Eastern Bluebird?
*What is the nearest fire hydrant to a house fire?

In your every-day life, you use web platforms like Google Maps or
OpenStreetMap to examine data or calculate how you move about the world.

The image above includes the 2 primary types of geospatial data: VECTOR
and RASTER.

## Map Possibilities with R

The following images were made using R! They’re at large geographic
scales, but there are so many beautiful opportunities for all scales and
data types. The freedom and curse with making maps is unlimited ways to
slightly tweak, adjust, emphasize components of the data and labeling.
Effective map making is an art form.

<figure>
<img
src="https://f.hypotheses.org/wp-content/blogs.dir/253/files/2014/03/pole_nord.gif"
style="width:33.0%" alt="Making GIF with R" />
<figcaption aria-hidden="true">Making GIF with R</figcaption>
</figure>

<figure>
<img src="http://egallic.fr/R/Blog/Cartes/North_pole/heatmap.png"
style="width:33.0%" alt="Climate Data" />
<figcaption aria-hidden="true">Climate Data</figcaption>
</figure>

<figure>
<img
src="https://procomun.files.wordpress.com/2012/02/pop_landclass.jpg"
style="width:33.0%" alt="Landuse Asia" />
<figcaption aria-hidden="true">Landuse Asia</figcaption>
</figure>

## Importance of Projection

As any introductory GIS course covers, stretching the earth onto a flat
surface results in some distortion.

<img
src="https://previews.123rf.com/images/altomedia/altomedia0805/altomedia080500007/3010547-planet-earth-balloon-inflated-and-deflated.jpg"
style="width:50.0%" alt="Earth as a Balloon" /> The Mercator Projection
is what you most commonly see on wall maps and in platforms like Google.
While it has major navigational benefits, it distorts area to an
increasing amount as you move from the equator to the poles. This
results in the common misconception of the *true* size of many
countries. In particular, many large northern countries (e.g. USA,
Canada, Europe, Russia, China) appear very large compared to equatorial
countries.

The following image shows several countries with correct areas (but
angular distortion).

<figure>
<img src="https://i.redd.it/u330vr220dm51.png" style="width:33.0%"
alt="Deceiving Size" />
<figcaption aria-hidden="true">Deceiving Size</figcaption>
</figure>

While the Mercator projection is the most common in classrooms, there
are infinite possibilities that prioritize different geographic regions
or map characteristics.

<img src="https://imgs.xkcd.com/comics/map_projections.png"
style="width:25.0%" alt="XKCD Map Projections" /> While there are
aesthetic reasons to pick a certain projection for your final map,
having an understanding and proper accounting of the projections used
with your data is critical to make sure any analysis is comparing
“apples to apples”. If you combine data from a Mercator and Albers Equal
Area projection, you’ll end up with nonsense! We will explore this more
in the workshop.

## GIS Operations

In this workshop, in addition to making several maps, we’ll cover
several basic GIS operations. A nonexhaustive list of operations is as
follows: \* (union)\[<https://gisgeography.com/union-tool/>\] \*
(merge)\[<https://gisgeography.com/merge-tool-gis/>\] \*
(join)\[<https://gisgeography.com/spatial-join/>\] \*
(dissolve)\[<https://gisgeography.com/dissolve-tool-gis/>\] \*
(buffer)\[<https://gisgeography.com/buffer-tool-gis/>\] \*
(intersect)\[<https://gisgeography.com/intersect-tool-gis/>\] \*
(clip/mask)\[<https://gisgeography.com/clip-tool-gis/>\] \* subset \*
extract

![Clip
Tool](https://gisgeography.com/wp-content/uploads/2020/10/Clip-Tool-768x243.png)
![Dissolve
Tool](https://gisgeography.com/wp-content/uploads/2020/02/Dissolve-Tool-678x228.png)

Visualizations of geospatial operations are helpful, but many of the
differences between tools reflect how they handle *information* related
to the shapes we see. Tools can be regarded as *adding* or *subtracting*
information, complexity, and spatial extent. I’ve provided a table below
describing how these tools manipulate data. We will refer to these tools
throughout the workshop.

| Function  | Information | Spatial.Extent | Data.Type         |
|:----------|:------------|:---------------|:------------------|
| Union     | Increase    | Increase       | Same              |
| Merge     | Increase    | Increase       | Same              |
| Join      | Increase    | \-             | Different         |
| Dissolve  | Decrease    | \-             | \-                |
| Buffer    | \-          | Increase       | \-                |
| Intersect | \-          | Decrease       | Same              |
| Clip/Mask | \-          | Decrease       | Same or Different |
| Subset    | Decrease    | Decrease       | \-                |
| Extract   | Decrease    | Erase          | \-                |

Let’s get started!

## Adjust Settings, Load Packages

In order to equip R with functionality for gis data, we need to load or
install several packages. Because this is an intermediate+ workshop, I
have code written in sometimes complicated formats, but I will do my
best to explain what I am doing. There are many ways to do the same
thing in R. Similarly, there are many different packages in R that can
handle the same types of data. We will use the pairing of the *tmap* and
*sf* packages. We’ll load several other packages we’ll use. In
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

# Section 1: Working with Vector Data

We’ll start this tutorial with a dataset that should look familiar:
borders of the World’s countries.

## Examining Geospatial Vector Data

From the start, let’s examine some of the open-source geospatial data
that comes with the *spData* package.

The *world* dataset contains shapefiles for 177 countries. We can take
*dim* of *world* to see that like a data frame, it contains data in 177
rows, and has 11 columns. *names* of *world* tells us there are
attributes for each shape such as name, which we would expect, some
regional data, and demographics, including population, life expectancy,
and gross domestic product per capita. Finally, the column **geom**
contains the information that makes this object time different than just
a regular data frame.

``` r
data("world")
dim(world) # take the 'dimensions' of the object, returns rows and columns
```

    ## [1] 177  11

``` r
names(world) # gives column names of object
```

    ##  [1] "iso_a2"    "name_long" "continent" "region_un" "subregion" "type"     
    ##  [7] "area_km2"  "pop"       "lifeExp"   "gdpPercap" "geom"

When we call for *head* of *world*, we can see data for several
countries in Africa and North America. We also see an interesting series
of 6 lines printed ahead of what looks like a regular data frame. We see
that *head* has returned what it calls a “Simple feature collection with
6 features and 10 fields”. Note, it considers the 10 fields as the 11
columns but minus the geom column. We can also see a *bbox* field
defining the geographic extent of the data, and the final two lines
showing us data on the data *projection*. We’ll come to projections in a
moment.

``` r
head(world) # return top 6 items/rows of an object
```

    ## Simple feature collection with 6 features and 10 fields
    ## Geometry type: MULTIPOLYGON
    ## Dimension:     XY
    ## Bounding box:  xmin: -180 ymin: -18.28799 xmax: 180 ymax: 83.23324
    ## Geodetic CRS:  WGS 84
    ## # A tibble: 6 × 11
    ##   iso_a2 name_long  continent region_un subregion type  area_km2     pop lifeExp
    ##   <chr>  <chr>      <chr>     <chr>     <chr>     <chr>    <dbl>   <dbl>   <dbl>
    ## 1 FJ     Fiji       Oceania   Oceania   Melanesia Sove…   1.93e4  8.86e5    70.0
    ## 2 TZ     Tanzania   Africa    Africa    Eastern … Sove…   9.33e5  5.22e7    64.2
    ## 3 EH     Western S… Africa    Africa    Northern… Inde…   9.63e4 NA         NA  
    ## 4 CA     Canada     North Am… Americas  Northern… Sove…   1.00e7  3.55e7    82.0
    ## 5 US     United St… North Am… Americas  Northern… Coun…   9.51e6  3.19e8    78.8
    ## 6 KZ     Kazakhstan Asia      Asia      Central … Sove…   2.73e6  1.73e7    71.6
    ## # ℹ 2 more variables: gdpPercap <dbl>, geom <MULTIPOLYGON [°]>

If we’re enthusiastic about it, we can try right away to plot our map of
the world! Try just using base R *plot*.

``` r
plot(world)
```

![](images/plot%20world-1.png)<!-- -->

…huh, so this isn’t quite what we wanted. Since the world data appeared
to us like a data frame, base R appears to try to plot *all* the data
within it. We could try to have it plot only one series of data though.

``` r
plot(world$geom)
```

![](images/plot%20world2-1.png)<!-- -->

This is closer to what we expected. Of course, we’re hoping to make maps
visualizing some sort of data. To get there, we need to figure out how
geospatial data in R is differentiated from accompanying data
(statistics, categories, names, etc.).

## Plotting World borders with tmap

Instead of base plot, let’s use tmap to visualize the world shapefile.

tmap is an exciting package for geospatial data visualization. The
package is covered extensively in the book [*Geocomputation with
R*](https://r.geocompx.org/) by Robin Lovelace and others.

The tmap style of data visualization and map making uses declarative
coding: similar to using ggplot.

Each object will be wrapped in a call to tm_shape(), followed by the
desired geometry type (e.g., tm_borders, tm_fill, tm_polygons)

``` r
tmap_arrange(
  tm_shape(world)+tm_borders(),
  tm_shape(world)+tm_fill(),
  nrow=1
)
```

![](images/plotworld-1.png)<!-- -->

``` r
tmap_arrange(
  tm_shape(world)+tm_borders()+tm_fill(col="pop"),
  tm_shape(world)+tm_borders()+tm_fill(col="pop",style="log10_pretty"),
  nrow=1
)
```

    ## Some legend labels were too wide. These labels have been resized to 0.55, 0.48, 0.48, 0.48, 0.44, 0.40, 0.40. Increase legend.width (argument of tm_layout) to make the legend wider and therefore the labels larger.

    ## Some legend labels were too wide. These labels have been resized to 0.49, 0.42, 0.37, 0.33, 0.30, 0.27. Increase legend.width (argument of tm_layout) to make the legend wider and therefore the labels larger.

![](images/plotworld2-1.png)<!-- -->

If you are familiar with ggplot and declaritive plotting, the formatting
of aesthetics will be familiar. Call the column/variable by name in
quotations to specify what is mapped to an attribute (e.g, color, fill,
shape, linetype).

With the pop layer as the fill aesthetic, we see a dramatic bright blue
color in China and India. We can improve the scaling of this variable by
showing color as the log of population. This shows a dramatic pathwork
of population sizes across South America, Africa, and Asia as well.

We can also fill the color with a categorical value like region.

``` r
tm_shape(world)+tm_fill(col="region_un")
```

![](images/tmapworld3-1.png)<!-- -->

Earlier, we commented how this geospatial data object behaved a bit like
a dataframe. We can in fact operate on this object with many functions
we often use with dataframes!

For example, we can *subset* the world dataset to plot only the boundary
of Canada. Think earlier when we discussed geospatial operations. We can
create a new object called Canada. We’ve reduced the amount of
information and spatial extent relative to the world object: we no
longer have information about any countries besides Canada. But, we’ve
kept the information type the same: it’s still a polygon.

``` r
tm_shape(shp=subset(world,name_long=="Canada"))+tm_borders()
```

![](images/tmapCanada-1.png)<!-- -->

``` r
Canada = subset(world,name_long=="Canada")
head(Canada)
```

    ## Simple feature collection with 1 feature and 10 fields
    ## Geometry type: MULTIPOLYGON
    ## Dimension:     XY
    ## Bounding box:  xmin: -140.9978 ymin: 41.67511 xmax: -52.6481 ymax: 83.23324
    ## Geodetic CRS:  WGS 84
    ## # A tibble: 1 × 11
    ##   iso_a2 name_long continent   region_un subregion type  area_km2    pop lifeExp
    ##   <chr>  <chr>     <chr>       <chr>     <chr>     <chr>    <dbl>  <dbl>   <dbl>
    ## 1 CA     Canada    North Amer… Americas  Northern… Sove…   1.00e7 3.55e7    82.0
    ## # ℹ 2 more variables: gdpPercap <dbl>, geom <MULTIPOLYGON [°]>

## Plotting World borders with ggplot2

With spatial objects, aesthetics (*aes*) are set the same as in other
ggplots. We can fill by a variable if inside aes(), and values outside
aes will apply to the shape.

``` r
ggplot(data=world,aes(fill=pop))+geom_sf() # alter shape fill by population
```

![](images/ggplotworld-1.png)<!-- -->

``` r
ggplot(data=subset(world,name_long=="Canada"))+geom_sf(color=2)
```

![](images/ggplotworld-2.png)<!-- -->

``` r
ggplot(data=world,aes(fill=region_un))+geom_sf()
```

![](images/ggplotworld-3.png)<!-- -->

``` r
ggplot(data=world,aes(fill=log10(pop)))+ # alter shape fill by log10 of population
  geom_sf()+
  scale_fill_gradientn(
    colors=c("blue","red"), # two end members of color gradient
    limits=c(7,9.3), # max and min of scale
    breaks=7:9, # breaks values for the plot legend
    labels=10^c(7:9), # show labels as 10 to the power of 7 through 9
    na.value="blue" # color for values outside limits()
  )
```

![](images/ggplotworld-4.png)<!-- -->

Challenge: create the following plots:

Did I subset by a particular region, or just a group of countries?

``` r
tm_shape(shp=subset(world,name_long%in%c("Canada","United States","Mexico")))+tm_borders()
```

![](images/tmap2-1.png)<!-- -->

``` r
tm_shape(shp=subset(world,subregion=="Eastern Asia"))+tm_fill(col="gray")+tm_borders(lwd=2)
```

![](images/tmap2-2.png)<!-- -->

## Beneath the Trunk: Vector Shapes from Scratch

``` r
point.wat= data.frame(
    lon=-80.516670,
    lat=43.466667
    ) %>%
  sf::st_as_sf(.,coords=names(.),crs = 4326)

circle.wat = data.frame(angle = seq(0,360,1))
radius = 0.1 #decimal degrees

circle.wat$lon = radius*cos(2*pi*circle.wat$angle/360) +
  st_coordinates(point.wat)[,"X"]
circle.wat$lat = radius*sin(2*pi*circle.wat$angle/360) +
  st_coordinates(point.wat)[,"Y"]
circle.wat = subset(circle.wat,select=-c(angle))

circle.wat = circle.wat %>% 
  as.matrix() %>%
  list() %>%
  st_polygon() %>%
  st_sfc() %>%
  st_sf(., crs = 4326)

tm_shape(circle.wat)+
  tm_borders()+
  tm_shape(point.wat)+
  tm_dots(size=0.1)
```

![](images/circle-wat-1.png)<!-- -->

``` r
#library(OpenStreetMap)
osmtiles <- tmaptools::read_osm(
  tmaptools::bb(circle.wat), type="osm")
tm_shape(osmtiles)+
  tm_rgb(saturation = 0)+
  tm_shape(circle.wat)+
  tm_borders()+
  tm_shape(point.wat)+
  tm_dots(size=0.1)
```

![](images/circle-wat-osm-1.png)<!-- -->

``` r
circlefx = function(center,radius){
  circle = data.frame(angle = seq(0,360,1))
  circle$lon = radius*cos(2*pi*circle$angle/360) + st_coordinates(center)[,"X"]
  circle$lat = radius*sin(2*pi*circle$angle/360) + st_coordinates(center)[,"Y"]
  circle = subset(circle,select=-c(angle))
  circle = circle %>% as.matrix() %>% list() %>%
    st_polygon() %>% st_sfc() %>% st_sf(., crs = 4326)
  return(circle)
}
```

# Section 2: Reviewing Map and Shape Projections

Let’s explore what our data tells us about its projection type. *st_crs*
queries the coordinate reference information for the shapefile. We see
two data types: the EPSG code and the proj4string. EPSG stands for
European Petroleum Survey Group, and is an internationally recognized
numeric code defining the coordinate reference system or **CRS**. The
proj4string shares the same information, but in text format. From this
we can see that the data are projected according to the World Geodetic
System of 1984, in latitudinal and longitudinal coordinates.

``` r
st_crs(world)
```

    ## Coordinate Reference System:
    ##   User input: EPSG:4326 
    ##   wkt:
    ## GEOGCRS["WGS 84",
    ##     DATUM["World Geodetic System 1984",
    ##         ELLIPSOID["WGS 84",6378137,298.257223563,
    ##             LENGTHUNIT["metre",1]]],
    ##     PRIMEM["Greenwich",0,
    ##         ANGLEUNIT["degree",0.0174532925199433]],
    ##     CS[ellipsoidal,2],
    ##         AXIS["geodetic latitude (Lat)",north,
    ##             ORDER[1],
    ##             ANGLEUNIT["degree",0.0174532925199433]],
    ##         AXIS["geodetic longitude (Lon)",east,
    ##             ORDER[2],
    ##             ANGLEUNIT["degree",0.0174532925199433]],
    ##     USAGE[
    ##         SCOPE["Horizontal component of 3D system."],
    ##         AREA["World."],
    ##         BBOX[-90,-180,90,180]],
    ##     ID["EPSG",4326]]

``` r
st_crs(world)$proj4string
```

    ## [1] "+proj=longlat +datum=WGS84 +no_defs"

## Reprojecting Vector Data

So far we’ve been looking at the world through the Mercator Projection.
We’ll use the pipe to pass world to *st_transform* and specify several
different proj4 strings.

``` r
projMollweide="+proj=moll +lon_0=0 +x_0=0 +y_0=0 +ellps=WGS84 +units=m +no_defs"
projRobinson="+proj=robin +lon_0=0 +x_0=0 +y_0=0 +a=6371000 +b=6371000 +units=m +no_defs"
projGallPeters="+proj=cea +lon_0=0 +lat_ts=45 +x_0=0 +y_0=0 +ellps=WGS84 +units=m +no_defs"


tmap_arrange(
  tm_shape(
      world,
      crs =projMollweide)+
    tm_borders()+
    tm_layout(title = "Mollweide"),
  tm_shape(
      world,
      crs =projRobinson)+
    tm_borders()+
    tm_layout(title = "Robinson Sphere"),
  tm_shape(
      world,
      crs =projGallPeters)+
    tm_borders()+
    tm_layout(title = "Gall-Peters Orthographic"),
  nrow=1
)
```

![](images/projections-1.png)<!-- -->

## Reproject Canada

We’ve analyzed the population data contained in the world shapefile. We
can also modify the shapefile itself. We will re-project the shapefile
from a the Ellipsoid WGS84 projection to the Canada Albers Equal Area
Conic Projection. I find this much more visually appealing for Canada.

``` r
Proj_AEA_Can=c("+proj=aea +lat_1=50 +lat_2=70 +lat_0=40 +lon_0=-96 +x_0=0 +y_0=0 ",
       "+ellps=GRS80 +datum=NAD83 +units=m +no_defs")%>%paste0(.,collapse = "")
# Canada Albers Equal Area Conic Projection
# visit http://spatialreference.org/ref/esri/canada-albers-equal-area-conic/proj4/
CanadaAEA=world%>%
  subset(.,name_long=="Canada")%>%
  st_transform(.,Proj_AEA_Can)
tm_shape(CanadaAEA)+
  tm_borders()
```

![](images/Canada-1.png)<!-- -->

# Section 3: Geospatial Operations

Let’s review the geospatial operations discussed at the beginning of our
workshop.

| Function  | Information | Spatial.Extent | Data.Type         |
|:----------|:------------|:---------------|:------------------|
| Union     | Increase    | Increase       | Same              |
| Merge     | Increase    | Increase       | Same              |
| Join      | Increase    | \-             | Different         |
| Dissolve  | Decrease    | \-             | \-                |
| Buffer    | \-          | Increase       | \-                |
| Intersect | \-          | Decrease       | Same              |
| Clip/Mask | \-          | Decrease       | Same or Different |
| Subset    | Decrease    | Decrease       | \-                |
| Extract   | Decrease    | Erase          | \-                |

We jumped right in and starting doing subsets, partly because we saw
that vector shapefiles in R behave and can be manipulated similarly to
data frames. The other operations mostly have functions that come from
the geospatial packages (e.g. sf, raster, terra, stars).

## Operations: Merge, Union, Dissolve, Intersect

``` r
point.wat= data.frame(lon=-80.516670, lat=43.466667) %>% 
  sf::st_as_sf(.,coords=names(.),crs = 4326)
circle.wat = circlefx(point.wat,0.3)

point.glp= data.frame(lon=-80.250000, lat=43.549999) %>% 
  sf::st_as_sf(.,coords=names(.),crs = 4326)
circle.glp = circlefx(point.glp,0.3)

tm_shape(circle.wat)+
  tm_borders()+
  tm_shape(circle.glp)+
  tm_borders()
```

![](images/circles-1.png)<!-- -->

``` r
# personally, I like that ggplots default to a map-view to encompass ALL polygons
# tmap defaults to a map view to encompass the first polygon
ggplot()+
  geom_sf(data=circle.wat,fill="transparent")+
  geom_sf(data=circle.glp,fill="transparent")
```

![](images/circles-2.png)<!-- -->

### Merge

We see with merge that the two shapes just become grouped into one new
object. We can imagine if these shapes had attributes, that to “rbind”
them as we would data frames, they must have the same structure of
columns and names.

``` r
circle.mrg = rbind(
  circle.wat,
  circle.glp
)

dim(circle.mrg)
```

    ## [1] 2 1

``` r
circle.mrg
```

    ## Simple feature collection with 2 features and 0 fields
    ## Geometry type: POLYGON
    ## Dimension:     XY
    ## Bounding box:  xmin: -80.81667 ymin: 43.16667 xmax: -79.95 ymax: 43.85
    ## Geodetic CRS:  WGS 84
    ##                         geometry
    ## 1 POLYGON ((-80.21667 43.4666...
    ## 2 POLYGON ((-79.95 43.55, -79...

``` r
ggplot()+geom_sf(data=circle.mrg,fill="transparent")
```

![](images/circle-merge-1.png)<!-- -->

### Union

Confusingly, the function for a traditional “union” is st_combine, not
st_union. We see by passing the merged shape to st_combine, the output
is a single MULTIPOLYGON with preserved internal boundaries.

``` r
circle.un = sf::st_combine(
  circle.mrg
)

dim(circle.un)
```

    ## NULL

``` r
circle.un
```

    ## Geometry set for 1 feature 
    ## Geometry type: MULTIPOLYGON
    ## Dimension:     XY
    ## Bounding box:  xmin: -80.81667 ymin: 43.16667 xmax: -79.95 ymax: 43.85
    ## Geodetic CRS:  WGS 84

    ## MULTIPOLYGON (((-80.21667 43.46667, -80.21672 4...

``` r
ggplot()+geom_sf(data=circle.un,fill="transparent")
```

![](images/circle-union-1.png)<!-- -->

### Dissolve

Confusingly, the function for a traditional “dissolve” is st_union. We
see by passing the merged shape to st_union., the output is a single
MULTIPOLYGON with dissolved internal boundaries.

``` r
circle.dis = sf::st_union(
  circle.mrg
)

dim(circle.dis)
```

    ## NULL

``` r
circle.dis
```

    ## Geometry set for 1 feature 
    ## Geometry type: POLYGON
    ## Dimension:     XY
    ## Bounding box:  xmin: -80.81667 ymin: 43.16667 xmax: -79.95 ymax: 43.85
    ## Geodetic CRS:  WGS 84

    ## POLYGON ((-79.95 43.55, -79.95005 43.55523, -79...

``` r
ggplot()+geom_sf(data=circle.dis,fill="transparent")
```

![](images/circle-dissolve-1.png)<!-- -->

### Intersection

Confusingly, the function for a traditional “dissolve” is st_union. We
see by passing the merged shape to st_union., the output is a single
MULTIPOLYGON with dissolved internal boundaries.

``` r
circle.int = sf::st_intersection(
  circle.wat,
  circle.glp
)

dim(circle.int)
```

    ## [1] 1 1

``` r
circle.int
```

    ## Simple feature collection with 1 feature and 0 fields
    ## Geometry type: POLYGON
    ## Dimension:     XY
    ## Bounding box:  xmin: -80.55 ymin: 43.25494 xmax: -80.21667 ymax: 43.76173
    ## Geodetic CRS:  WGS 84
    ##                         geometry
    ## 1 POLYGON ((-80.30414 43.2549...

``` r
ggplot()+
  geom_sf(data=circle.dis,lty=2,col="red")+
  geom_sf(data=circle.int,lwd=2,col=1,fill="transparent")
```

![](images/circle-intersection-1.png)<!-- -->

## Operation: Intersection

Let’s examine some new data, and learn a few more operations

``` r
data("worldcities")

head(worldcities)
```

    ## Simple feature collection with 6 features and 14 fields
    ## Geometry type: POINT
    ## Dimension:     XY
    ## Bounding box:  xmin: -58.304 ymin: -34.538 xmax: 0.7890036 ymax: 9.261
    ## Geodetic CRS:  WGS 84
    ##                nameascii      featurecla adm0cap worldcity sov0name adm0name
    ## 1 Colonia del Sacramento Admin-1 capital       0         0  Uruguay  Uruguay
    ## 2               Trinidad Admin-1 capital       0         0  Uruguay  Uruguay
    ## 3            Fray Bentos Admin-1 capital       0         0  Uruguay  Uruguay
    ## 4              Canelones Admin-1 capital       0         0  Uruguay  Uruguay
    ## 5                Florida Admin-1 capital       0         0  Uruguay  Uruguay
    ## 6                 Bassar Admin-1 capital       0         0     Togo     Togo
    ##    adm1name sov_a3 adm0_a3 iso_a2 latitude  longitude pop_max pop_min
    ## 1   Colonia    URY     URY     UY  -34.480 -57.840003   21714   21714
    ## 2    Flores    URY     URY     UY  -33.544 -56.900997   21093   21093
    ## 3 Rio Negro    URY     URY     UY  -33.139 -58.303998   23279   23279
    ## 4 Canelones    URY     URY     UY  -34.538 -56.284002   19698   19698
    ## 5   Florida    URY     URY     UY  -34.099 -56.214998   32234   32234
    ## 6      Kara    TGO     TGO     TG    9.261   0.789004   61845   61845
    ##                      geometry
    ## 1 POINT (-57.83612 -34.46979)
    ## 2     POINT (-56.901 -33.544)
    ## 3     POINT (-58.304 -33.139)
    ## 4     POINT (-56.284 -34.538)
    ## 5     POINT (-56.215 -34.099)
    ## 6     POINT (0.7890036 9.261)

In the dfsspatdat package, the world cities point shapefile has lots of
useful information associated with each city, but imagine we started out
without knowing any of the countries the cities were in. Given only the
coordinates of the cities, we could perform an intersect with the world
object to retrieve the countries!

``` r
capitals_lost = subset(worldcities,
                          featurecla == "Admin-0 capital",
                          select=c(nameascii,geometry))

# test for same projection!
sf::st_crs(capitals_lost) == sf::st_crs(world)
```

    ## [1] TRUE

``` r
# an intersection can be performed with st_intersection()
capitals_lost = sf::st_intersection(
  capitals_lost,
  subset(world,select=c(name_long,geom))
  )

head(capitals_lost)
```

    ## Simple feature collection with 6 features and 2 fields
    ## Geometry type: POINT
    ## Dimension:     XY
    ## Bounding box:  xmin: -77.01136 ymin: -18.13302 xmax: 178.4417 ymax: 51.18113
    ## Geodetic CRS:  WGS 84
    ##             nameascii     name_long                   geometry
    ## 7023             Suva          Fiji POINT (178.4417 -18.13302)
    ## 7197    Dar es Salaam      Tanzania  POINT (39.2664 -6.798067)
    ## 7086           Ottawa        Canada POINT (-75.70196 45.41864)
    ## 7317 Washington, D.C. United States  POINT (-77.01136 38.9015)
    ## 7044           Astana    Kazakhstan  POINT (71.42777 51.18113)
    ## 7284         Tashkent    Uzbekistan  POINT (69.26882 41.30383)

## Operation: Dissolve

So refering back to our map of Canada earlier, I become very picky about
the weird border down the middle of the Great Lakes. I like my maps to
represent the landmass of Canada!

``` r
data("can_prov",package="dfsspatdat")

head(can_prov)
```

    ## Simple feature collection with 6 features and 6 fields
    ## Geometry type: MULTIPOLYGON
    ## Dimension:     XY
    ## Bounding box:  xmin: -141.0181 ymin: 43.39211 xmax: -59.67046 ymax: 69.64746
    ## Geodetic CRS:  NAD83
    ##   PRUID                                  PRNAME          PRENAME
    ## 1    60                                   Yukon            Yukon
    ## 2    47                            Saskatchewan     Saskatchewan
    ## 3    46                                Manitoba         Manitoba
    ## 4    12        Nova Scotia / Nouvelle-\xc9cosse      Nova Scotia
    ## 5    48                                 Alberta          Alberta
    ## 6    59 British Columbia / Colombie-Britannique British Columbia
    ##                PRFNAME PREABBR  PRFABBR                       geometry
    ## 1                Yukon    Y.T.       Yn MULTIPOLYGON (((-136.4776 6...
    ## 2         Saskatchewan   Sask.    Sask. MULTIPOLYGON (((-102.0125 6...
    ## 3             Manitoba    Man.     Man. MULTIPOLYGON (((-94.825 60,...
    ## 4   Nouvelle-\xc9cosse    N.S. N.-\xc9. MULTIPOLYGON (((-66.01903 4...
    ## 5              Alberta   Alta.     Alb. MULTIPOLYGON (((-110.0125 6...
    ## 6 Colombie-Britannique    B.C.    C.-B. MULTIPOLYGON (((-123.3228 4...

``` r
can_prov$Country = "Canada"

#can_pretty = dplyr::summarise(can_prov)
can_pretty = can_prov |>
  dplyr::group_by(Country) |>
  dplyr::summarise()

head(can_pretty)
```

    ## Simple feature collection with 1 feature and 1 field
    ## Geometry type: MULTIPOLYGON
    ## Dimension:     XY
    ## Bounding box:  xmin: -141.0181 ymin: 41.71096 xmax: -52.61941 ymax: 83.1355
    ## Geodetic CRS:  NAD83
    ## # A tibble: 1 × 2
    ##   Country                                                               geometry
    ##   <chr>                                                       <MULTIPOLYGON [°]>
    ## 1 Canada  (((-66.69015 44.64426, -66.68975 44.64523, -66.68975 44.64586, -66.69…

``` r
can_pretty = can_pretty |>
  sf::st_simplify(
  preserveTopology = TRUE,
  dTolerance = 500)

tmap_arrange(
  tm_shape(can_prov)+tm_borders(),
  tm_shape(can_pretty)+tm_borders(),
  nrow=1
)
```

![](images/can_pretty-1.png)<!-- -->

There isn’t a meaningful difference in run-time to perform a dissolve.

``` r
system.time({
  can_pretty = sf::st_union(can_prov)
})
# Workstation Computer
#   user   system elapsed 
#   18.42  1.44   30.31 
# Laptop
#   user   system elapsed 
#   48.41  1.46   148.17 
system.time({
  can_pretty = dplyr::summarise(can_prov)
})
# Workstation Computer
#   user   system elapsed 
#   17.55  0.70   32.11 
# Laptop
#   user   system elapsed 
#   47.97  1.86   149.20
```

## Operation: Join

Despite the new object can_pretty seeming pretty devoid of information,
there are lots of different geometries present. We know Canada has lots
of islands, so they must be wrapped up inside the MULTIPOLYGON. We can
get them out, if we wanted!

``` r
can_singles = sf::st_cast(can_pretty,"POLYGON")

nrow(can_singles)
```

    ## [1] 1265

``` r
head(can_singles)
```

    ## Simple feature collection with 6 features and 1 field
    ## Geometry type: POLYGON
    ## Dimension:     XY
    ## Bounding box:  xmin: -67.01982 ymin: 44.60249 xmax: -65.01579 ymax: 47.13047
    ## Geodetic CRS:  NAD83
    ## # A tibble: 6 × 2
    ##   Country                                                               geometry
    ##   <chr>                                                            <POLYGON [°]>
    ## 1 Canada  ((-66.69048 44.62129, -66.69174 44.64682, -66.7215 44.63302, -66.7257…
    ## 2 Canada  ((-66.75986 44.77242, -66.78128 44.80082, -66.82853 44.76997, -66.836…
    ## 3 Canada  ((-66.9161 44.95209, -66.92134 44.94944, -66.92595 44.94607, -66.9308…
    ## 4 Canada  ((-66.93535 45.01988, -66.95109 45.02571, -66.95452 45.01903, -66.960…
    ## 5 Canada  ((-65.02867 47.12685, -65.03345 47.13004, -65.04542 47.13047, -65.037…
    ## 6 Canada  ((-65.02176 47.12586, -65.02534 47.12032, -65.01579 47.11725, -65.021…

How might we know which is which? Which islands are part of which
provinces?

``` r
can_singles$Index = seq_len(nrow(can_singles))
can_single_centroids = sf::st_centroid(can_singles)
can_single_centroids = sf::st_intersection(
  can_single_centroids,
  subset(can_prov,select=c("PRENAME","geometry")))

can_singles = dplyr::left_join(
  can_singles,
  st_drop_geometry(can_single_centroids),
  by = join_by("Country","Index")
  )

table(can_singles$PRENAME)
```

    ## 
    ##          British Columbia                  Manitoba             New Brunswick 
    ##                        60                         4                        15 
    ## Newfoundland and Labrador     Northwest Territories               Nova Scotia 
    ##                        79                       122                        27 
    ##                   Nunavut                   Ontario      Prince Edward Island 
    ##                       691                        97                         7 
    ##                    Quebec                     Yukon 
    ##                        81                         2

Was this successful?

``` r
tm_shape(can_singles)+
  tm_fill(col = "PRENAME")
```

    ## Some legend labels were too wide. These labels have been resized to 0.59. Increase legend.width (argument of tm_layout) to make the legend wider and therefore the labels larger.

![](images/islands_provinces-1.png)<!-- --> How else might we identify
very prominent islands in Canada?

``` r
can_cities = subset(worldcities,sov0name=="Canada")
sf::st_crs(can_cities) == sf::st_crs(can_singles)
```

    ## [1] FALSE

``` r
can_cities = sf::st_transform(can_cities,sf::st_crs(can_singles))

can_cities = sf::st_intersection(
  subset(can_cities,select=c(nameascii,featurecla,adm1name,geometry)),
  subset(can_singles,select=-c(PRENAME))
)

can_singles = dplyr::right_join(
  can_singles,
  sf::st_drop_geometry(can_cities),
  by = join_by("Country","Index")
)
```

``` r
tmap_arrange(
  tm_shape(subset(can_singles,nameascii=="Victoria"))+
    tm_borders()+
    tm_shape(subset(can_cities,nameascii=="Victoria"))+
    tm_dots(size = 1)+
    tm_layout(title="Victoria, British Columbia"),
  tm_shape(subset(can_singles,nameascii=="St. John's"))+
    tm_borders()+
    tm_shape(subset(can_cities,nameascii=="St. John's"))+
    tm_dots(size = 1)+
    tm_layout(title="St. John's, Newfoundland"),
  tm_shape(subset(can_singles,nameascii=="Charlottetown"))+
    tm_borders()+
    tm_shape(subset(can_cities,nameascii=="Charlottetown"))+
    tm_dots(size = 1)+
    tm_layout(title="Charlottetown, PEI"),
  nrow=1
)
```

![](images/some_islands-1.png)<!-- -->

## Operation: Buffer

How many cities are within 200 kilometers of Toronto?

``` r
can_cities = subset(worldcities,sov0name=="Canada",
                     select=c(nameascii,featurecla,adm1name,pop_max,geometry))
can_cities = sf::st_transform(can_cities,Proj_AEA_Can)

# Brutal burn for Waterloo :(
"Waterloo" %in% can_cities$nameascii
```

    ## [1] FALSE

``` r
toronto_buf = subset(can_cities,nameascii=="Toronto") |>
  sf::st_buffer(dist=150000) |>
  sf::st_geometry()

to_cities = sf::st_intersection(
  can_cities,
  toronto_buf
)
```

``` r
data("can_prov",package="dfsspatdat")
Ontario = subset(can_prov,PRENAME=="Ontario") |>
  sf::st_transform(crs = Proj_AEA_Can)

tm_shape(to_cities)+
  tm_dots(size=0.2)+
  tm_text(text="nameascii",ymod=0.5,size=0.8)+
  tm_shape(Ontario)+
  tm_borders()+
  tm_shape(toronto_buf,is.master=TRUE)+
  tm_borders(lty="dashed")
```

![](images/toronto_area-1.png)<!-- -->

# Section 4: Map Aesthetics

Let’s add a few map elements inherited from the *tmap* package. We’ll
add a north arrow and scale bar, and we can get rid of the grid lines.
If you wanted the axes and coordinates, you can adjust the parameters of
tm_layout().

``` r
map=tm_shape(CanadaAEA)+tm_polygons()+
  tm_layout(title="Map of Canada")+
  tm_compass(type="arrow",position = c("right","top"))+
  tm_scale_bar(breaks=c(0,1000,2000),position = c("left","bottom"),text.size = 0.7)
map+tm_layout(frame = FALSE)
```

![](images/tmapelements-1.png)<!-- -->

``` r
map+tm_layout(frame=TRUE)+tm_grid(projection = "+proj=longlat")
```

![](images/tmapelements-2.png)<!-- -->

## Joining data

*spData* comes with data on where our coffee comes from! Use *left_join*
from *dplyr* to add this data to world. Use the Robinson Sphere to
accentuate the equatorial belt. We’ll use the *st_centroid* function
nested within *st_coordinates* and *cbind* to add X and Y coordinates to
draw labels. We may only want labels for the top coffee contributing
countries, so we can use subset.

``` r
data("coffee_data")
head(coffee_data)
```

    ## # A tibble: 6 × 3
    ##   name_long                coffee_production_2016 coffee_production_2017
    ##   <chr>                                     <int>                  <int>
    ## 1 Angola                                       NA                     NA
    ## 2 Bolivia                                       3                      4
    ## 3 Brazil                                     3277                   2786
    ## 4 Burundi                                      37                     38
    ## 5 Cameroon                                      8                      6
    ## 6 Central African Republic                     NA                     NA

``` r
  # spData tells us production is in units of thousands of 60 kg bags produced by country
  # multiple by 60kg/bag to get kg and divide by 10^3 to get metric tons
coffee_data$coffee_MT_2017 = coffee_data$coffee_production_2017*60/1000

world_coffee=world%>% 
  subset(.,select=c(name_long)) %>% 
  # pass to left_join, join by "name_long"
  left_join(.,coffee_data,by="name_long")%>% 
  st_transform(.,
       "+proj=robin +lon_0=0 +x_0=0 +y_0=0 +a=6371000 +b=6371000 +units=m +no_defs"
               ) %>% 
  cbind(.,st_coordinates(st_centroid(.))) # add coordinates of centroids to data

tm_shape(world_coffee)+
  tm_fill(col="coffee_MT_2017")
```

![](images/coffeemap-1.png)<!-- -->

``` r
ggplot()+
  geom_sf(data=world_coffee,aes(fill=coffee_MT_2017))+
  geom_label_repel( # label the countries
    data=subset(world_coffee,coffee_production_2017>500), # take top coffee producers
    aes(x=X,y=Y,label=name_long), # label aesthetics
                   box.padding = 1, # distance between label and point
                   segment.size=1 # line width
                   )+
  scale_fill_gradientn(name=expression(paste(10^6,"kg coffee ",yr^-1)),
                       # complex text made with expression
    colors=c("lightgray","brown"),
    na.value="white" # value for countries with no data?
    )+
  theme(legend.position = "bottom", # where to place the legend
        panel.background = element_blank(), # remove panel background
        axis.title=element_blank() # remove all axis titles
        )+
  ggtitle("World Coffee Production") # add a title
```

![](images/coffeemap-2.png)<!-- -->

Think about what geospatial operation happened here. We took the world
data, and added information that wasn’t there before! So we increased
the amount of information, but kept data for all the countries, even
though only some can produce coffee. In many cases with *joins*, you
have one geospatial object being joined with new information in a
tabular format. There are cases where you will join information from two
or more sets of geospatial objects, but this can quickly become chaotic.

# Section 5. Working with Raster Data

## Raster Data Format

The eBird project has multiple data products that can be used for
academic research or hobby science. I have down-sized some data from the
Status and Trends dataset for two bird species: the Eastern Bluebird and
the Bobolink. Use the *raster* function to read in a raster. These data
are for occurrence frequency on an annual scale.

``` r
data("easblu_on",package = "dfsspatdat")
data("boboli_on",package = "dfsspatdat")
```

There are many many different types of raster file formats. The raster
package is wonderful in that it can read in almost all of them. (Read
more information on raster
files)\[<https://pro.arcgis.com/en/pro-app/latest/help/data/imagery/supported-raster-dataset-file-formats.htm>\].

Like we did when we first started examining the world shape, let’s just
call our raster object to see its description:

``` r
easblu_on
```

    ## class      : RasterLayer 
    ## dimensions : 761, 1010, 768610  (nrow, ncol, ncell)
    ## resolution : 3780, 2320  (x, y)
    ## extent     : -1099399, 2718401, 263770.6, 2029291  (xmin, xmax, ymin, ymax)
    ## crs        : +proj=aea +lat_0=40 +lon_0=-96 +lat_1=50 +lat_2=70 +x_0=0 +y_0=0 +datum=NAD83 +units=m +no_defs 
    ## source     : easblu_occur_year_Ontario.grd 
    ## names      : full_year 
    ## values     : 0, 0.6049805  (min, max)

There’s useful information here: we see that there are 770 thousand data
points in this raster. The crs of the data is pre-defined, and we can
see it is the Canada Albers Equal Area Conic Projection, with units of
metres.

## Plotting Raster Data

We can use the basic plot function to try to examine the data. With
basic plot, we can add the Ontario border.

``` r
data("can_prov",package="dfsspatdat")
Ontario = subset(can_prov,PRENAME=="Ontario")
Ontario = sf::st_transform(Ontario,sf::st_crs(easblu_on))

plot(easblu_on,xlim=c(800000,1800000),ylim=c(260000,900000))
plot(Ontario$geometry,add=TRUE,main="Eastern Bluebird\nAnnual Frequency")
```

![](images/ebird3-1.png)<!-- -->

### Plot Aesthetics, Multiple Objects with tmap

As we saw earlier, options to plot geospatial data include base plot,
ggplot, and tmap. For plotting both raster and vector data, tmap has
made this much easier than ggplot.

A note about zooming plots: \* Base plot uses xlim and ylim as arguments
in plot \* ggplot uses +coord_sf(xlim=…,ylim=…) to set coordinates for
maps \* tmap uses a more confusing format, where you must create a
bounding box (bbox) object, to be fed to the tm_shape() function.

A note about layering objects with tmap: \* In ggplot, to layer objects
like we did with the coffee plot above, you simply add (+) them on top
of each other. In the coffee plot, we had +geom_sf() and some aesthetics
to plot our countries, color coded by coffee production, and we added
the +geom_label_repel() function to add a second feature, which were
labels attached to the centroid points of a subset of countries. \* In
tmap, each object addition needs two sequential lines: first, a call of
tm_shape() listing the object, and then a mapping function
(e.g. tm_raster, tm_borders, tm_polygons) that corresponds with the
object type.

``` r
sOntbbox = tmaptools::bb(
  sf::st_bbox(c(
  xmin = 800000,
  xmax = 1800000,
  ymin = 260000,
  ymax = 900000
  ),crs = sf::st_crs(easblu_on))
)

tm_shape(easblu_on,is.main = TRUE,bbox=sOntbbox)+
  tm_raster(palette = "Spectral",title = "Annual Frequency")+
  tm_shape(Ontario)+
  tm_borders()+
  tm_layout(legend.position = c("right","center"),
            main.title = "Eastern Bluebird")
```

![](images/raster%20+%20vector%20plot-1.png)<!-- -->

``` r
bobo_freq <- rasterToContour(boboli_on,maxpixels = 10000,nlevels=4)
class(bobo_freq)
```

    ## [1] "SpatialLinesDataFrame"
    ## attr(,"package")
    ## [1] "sp"

``` r
tm_shape(boboli_on,bbox=sOntbbox)+
  tm_raster(palette = "Spectral",title = "Annual Frequency")+
  tm_shape(Ontario)+
  tm_borders()+
  tm_layout(legend.position = c("right","center"),
            main.title = "Bobolink")
```

![](images/ebird%20Bobolink-1.png)<!-- --> \## Multiband Raster Data

Here’s a fun excercise: map the Flag of Canada in the shape of the
country. Earlier we discussed raster formats. If you think about it,
common file types you interact with every day (e.g. png, jpeg) are
actually rasters!

``` r
CAFlag1 = raster(
  system.file("data-shp/CanadaFlag.png", package = "dfsspatdat")
)
CAFlag1
```

    ## class      : RasterLayer 
    ## band       : 1  (of  4  bands)
    ## dimensions : 600, 1200, 720000  (nrow, ncol, ncell)
    ## resolution : 1, 1  (x, y)
    ## extent     : 0, 1200, 0, 600  (xmin, xmax, ymin, ymax)
    ## crs        : NA 
    ## source     : CanadaFlag.png 
    ## names      : CanadaFlag_1

``` r
plot(CAFlag1)
```

![](images/flag1-1.png)<!-- -->

Ok, so we didn’t get anything inteligible from our plot. But the
description of this raster object CAFlag1 gives us some clues: there is
a range of values from 0 to 255, which is the maximum intensity of a
pixel in a png file. The description also tells us there are multiple
bands in this png file. If you know how computer images and screens
work, you might guess that the different bands map onto the Red Green
Blue (RGB) colors in the file.

Since there are multiple bands, we can instead use raster::stack to read
in the data.

``` r
CAFlag=raster::stack(
  system.file("data-shp/CanadaFlag.png", package = "dfsspatdat")
)
names(CAFlag)
```

    ## [1] "CanadaFlag_1" "CanadaFlag_2" "CanadaFlag_3" "CanadaFlag_4"

``` r
# A portable network graphic (PNG) file stores image color in four bands, and we see 
#    that each band has 600 by 1200 cells
plot(CAFlag)
```

![](images/flag2-1.png)<!-- -->

So now to test your knowledge of color theory, which of the bands map to
red, green, and blue?

The bands are actually in order! From red (1), green (2), to blue (3).
In the maple leaf shape, only red is at maximum intensity, so it will be
red. In the band around the leaf, all three colors are at maximum
intensity, so the resulting mixture will create white.

Let’s combine these bands as intended to be seen on a computer: with an
RGB plotting function.

``` r
raster::plotRGB(CAFlag,r=1,g=2,b=3)
```

![](images/flag3-1.png)<!-- -->

``` r
# we see that the first band stores the red data, green in the 2nd, and blue in the 3rd.
```

We’ve spent time on color theory, but let’s come back to GIS. This
excercise serves to show you how to map non-geospatial data. Here, we’ll
re-map the flag’s coordinates to latitude and longitude instead of its
pixel dimensions.

``` r
Canada=subset(world,name_long=="Canada")

extent(CAFlag)<-extent(Canada)
crs(CAFlag)<-st_crs(Canada)$proj4string
# set coordinates for our CAFlag image the same as our geospatial data

tm_shape(CAFlag$CanadaFlag_2,is.main = TRUE)+
  tm_raster(col="CanadaFlag_2",palette = c("red","white"))+
  #     fill the raster by the value of the green band, 
  #     but specify the end color values of red and white
  tm_layout(bg.color = "gray",legend.show = F)+
  tm_shape(Canada)+
  tm_borders()
```

![](images/flag4-1.png)<!-- -->

## Modifying Raster Data: Mask

Maybe we have a dataset at a larger scale than our area of interest. Or
maybe we just want an aesthetically pleasing map with data contained to
an area of interest (as a vector polygon). So far in this workshop, we
haven’t performed any subtractive geospatial operations on vector data.
Here, we’ll use the “mask” function to remove the flag information from
outside of Canada’s land border.

``` r
CAFlagM=raster::mask(CAFlag,Canada) # we will mask out the parts of our image outside Canada

tm_shape(CAFlagM$CanadaFlag_2)+
  tm_raster(col="CanadaFlag_2",palette=c("red","white"))+
  #     fill the raster by the value of the green band, 
  #     but specify the end color values of red and white
  tm_layout(bg.color = "gray",legend.show = F)+
  tm_shape(Canada)+
  tm_borders()
```

![](images/flag%20mask-1.png)<!-- -->

These last graphs might have you thinking in the back of your head that
this isn’t the shape you’re used to seeing for Canada. This is the
effect of map projection. The last plot is shown using the Mercator
projection, using longitude and latitude as coordinates.

## Projections and Raster Data

Let’s revisit our flag, and see how changing the projection of our
shapefile has changed several previously linear features. We’ll use
*projectRaster* to use our original raster and *transform* or *project*
the data to a new CRS. Remember, an important principal of working with
GIS data is that all data you’re working with are in the same CRS when
analyzing and plotting.

``` r
tm_shape(CAFlagM$CanadaFlag_2,is.master = TRUE,projection = Proj_AEA_Can)+
  tm_raster(col="CanadaFlag_2",palette=c("red","white"))+
  tm_layout(bg.color = "gray",legend.show = F)+
  tm_shape(Canada)+tm_borders()
```

![](images/flag%20project-1.png)<!-- -->

## More Raster Practice: Multiband Imagery

Let’s explore some data built into *spDataLarge*. We have access to a
Digital Elevation Model from Zion National Park in Utah, USA.

``` r
zion_dem=system.file("raster/srtm.tif", package = "spDataLarge")%>%raster()
zion_shp=system.file("vector/zion.gpkg", package = "spDataLarge")%>%st_read()%>%st_transform(.,proj4string(zion_dem))
```

    ## Reading layer `zion' from data source 
    ##   `C:\Users\tyler\AppData\Local\R\win-library\4.3\spDataLarge\vector\zion.gpkg' 
    ##   using driver `GPKG'
    ## Simple feature collection with 1 feature and 11 fields
    ## Geometry type: POLYGON
    ## Dimension:     XY
    ## Bounding box:  xmin: 302903.1 ymin: 4112244 xmax: 334735.5 ymax: 4153087
    ## Projected CRS: UTM Zone 12, Northern Hemisphere

``` r
plot(zion_dem,main="Zion NP Elevation")
```

![](images/DEM-1.png)<!-- -->

We see the map coordinates in latitude and longitude, and elevation by
color. We just used base plot to show this raster. Use tmap to plot the
dem with the Zional National Park boundary. *terrain.colors* provides a
nice color pallete for elevation maps, with white highest and green
lowest.

``` r
zion_dem_mask=zion_dem%>%
  raster::crop(.,extent(zion_shp))%>%
  raster::mask(.,zion_shp)

tm_shape(zion_dem_mask)+
  tm_raster(style="cont",palette = terrain.colors(5),title="Elev (m)")+
  tm_shape(zion_shp)+tm_borders()+
  tm_layout(main.title="Zion NP Elevation",
            legend.position = c("right","top"))+
  tm_scale_bar(position = c("left","bottom"))
```

![](images/DEM2-1.png)<!-- -->

We also have satellite imagery taken over this area! The data we have
from the Landsat satellites has optical data in 4 color bands:

- Blue 0.452 - 0.512 nm
- Green 0.533 - 0.590 nm
- Red 0.636 - 0.673 nm
- Near Infrared (NIR) 0.851 - 0.879 nm

We can visualize all four bands:

``` r
landsat = system.file("raster/landsat.tif", package = "spDataLarge") %>%
  brick()

zion_shp=st_transform(zion_shp,crs(landsat))

plot(landsat)
```

![](images/landsat-1.png)<!-- -->

To put them together, we will use the *tm_rgb* function from *tmap* to
creata a True Color image from the three color bands.

``` r
tm_shape(landsat)+
  tm_rgb(r=3, # red band
         g=2, # green band
         b=1, # blue band
         max.value = 26000)+
  tm_shape(zion_shp)+
  tm_borders(col="white")+
  tm_scale_bar(position = c("left","bottom"),text.color = "white")+
  tm_layout(main.title= "Zion National Park",
            title="True Color Image",
            title.position = c("right","top"),
            title.color = "white"
            )
```

    ## stars object downsampled to 888 by 1125 cells. See tm_shape manual (argument raster.downsample)

![](images/landsatcolor-1.png)<!-- -->

Often, researchers use the color bands from Landsat to derive various
data not visible to the naked eye. For instance, in the infrared, water
is highly absorbing, and trees generally emit in the IR. We can create a
false color image by swapping out IR for red.

``` r
tm_shape(landsat)+
  tm_rgb(r=4, # nearIR band
         g=2, # green band
         b=1, # blue band
         max.value = 32000)+
  tm_shape(zion_shp)+
  tm_borders(col="white")+
  tm_scale_bar(position = c("left","bottom"),text.color = "white")+
  tm_layout(main.title= "Zion National Park",
            title="False Color Image",
            title.position = c("right","top"),
            title.color = "white"
            )
```

    ## stars object downsampled to 888 by 1125 cells. See tm_shape manual (argument raster.downsample)

![](images/falsecolor-1.png)<!-- -->

Notice how the lake in the upper middle remains dark, while the forest
in the upper portion shows up as very red. You can see the vegetation
along the stream channel in the lower part of the image as well.

## Extracting Data from Rasters

Raster data for Canadian biomass

<http://ftp.maps.canada.ca/pub/nrcan_rncan/Forests_Foret/canada-forests-attributes_attributs-forests-canada/2011-attributes_attributs-2011/>

``` r
biomass = raster(system.file("data-shp/biomassveg_canada.tif", package = "dfsspatdat"))

data("can_prov")
can_prov = sf::st_transform(can_prov,sf::st_crs(biomass))


plot(biomass,main="Aboveground Biomass (Mg C/ha)")
```

![](images/forestdata-1.png)<!-- -->

``` r
tm_shape(biomass)+
  tm_raster(palette=c("beige","darkgreen"),title=expression("(Mg C "*ha^-1*")"))+
  tm_layout(main.title = "Aboveground Biomass",legend.position = c("right","top"))+
  tm_shape(shp = can_prov)+
  tm_borders()
```

    ## stars object downsampled to 1090 by 918 cells. See tm_shape manual (argument raster.downsample)

![](images/biomassdata2-1.png)<!-- -->

``` r
provBC=can_prov%>%
  subset(.,PRENAME=="British Columbia")
biomassBC=biomass%>%
  raster::sampleRegular(.,500000,asRaster=TRUE)%>%
  raster::crop(.,extent(provBC))%>%
  raster::mask(.,provBC)
cellsize=res(biomassBC)

tm_shape(biomassBC)+
  tm_raster(palette=c("beige","darkgreen"),title=expression("(Mg C "*ha^-1*")"))+
  tm_layout(main.title = "British Columbia",
            title = "Aboveground Biomass",
            legend.outside = TRUE,
            legend.outside.position = "right"
            )+
  tm_shape(shp = provBC)+
  tm_borders()
```

![](images/biomassdata3-1.png)<!-- -->

``` r
(sum(getValues(biomassBC$biomassveg_canada),na.rm=T)*
    cellsize[1]*cellsize[2]* # cell dimentions in m
    (100^-2)* # m2 to ha
    10^6* # Mg to g
    10^-15 # g to Pg
  )%>%round(.,2)%>%
  paste0(.," petagrams (billion tons) of carbon in BC biomasss")
```

    ## [1] "9.35 petagrams (billion tons) of carbon in BC biomasss"

## Working with Multiple Rasters

``` r
data("ontario_lc")
coverkey = read.csv(system.file("data-shp/land_cover_key.csv", package = "dfsspatdat"))

rgb2hex <- function(r,g,b) rgb(r, g, b, maxColorValue = 255)
coverkey$HEX = sapply(1:nrow(coverkey),function(i){
  rgb2hex(coverkey$Red[i],coverkey$Green[i],coverkey$Blue[i])})
ontario_lc
```

``` r
lon=seq(-81.6,-79.8,0.1)
box=data.frame(
  lon=c(lon,rev(lon)),
  lat=c(rep(c(44.4,42.8),each=length(lon)))) %>%
  rbind(., .[1,]) %>%
  as.matrix()%>%
  list()%>%
  st_polygon()%>%
  st_sfc()%>%
  st_sf(., crs = 4326)%>%
  st_transform(.,Proj_AEA_Can)

boxi = box %>% st_transform(st_crs(ontario_lc)$proj4string)
coveri = ontario_lc %>%
  raster::crop(.,extent(boxi)) %>%
  raster::mask(.,boxi) %>%
  raster::projectRaster(.,crs = st_crs(boboli_on)$proj4string,method="ngb")
boxi = box %>% st_transform(st_crs(boboli_on)$proj4string)

raster::is.factor(coveri)
coveri = raster::as.factor(coveri)
key = levels(coveri)[[1]]

key = left_join(key,coverkey[,c("ID","code","HEX")],by="ID")
levels(coveri) <- key
coveri
```

``` r
tm_shape(coveri)+
  tm_raster(title = "Land Cover",
    palette = levels(coveri)[[1]]$HEX,style ="cat",
    showNA=FALSE)+
  tm_layout(main.title = "S Ontario Land Cover",
            legend.outside = TRUE,
            legend.outside.position = "right")
```

``` r
bobo_new = raster::resample(boboli_on,coveri) %>%
  raster::crop(.,extent(boxi)) %>%
  raster::mask(.,boxi)

tm_shape(bobo_new)+
  tm_raster(palette = "Spectral",title = "Annual Frequency")+
  tm_shape(boxi)+
  tm_borders()+
  tm_layout(main.title = "Bobolink in S Ontario",
            legend.outside = TRUE,
            legend.outside.position = "right")
```

``` r
coveri = raster::crop(coveri,bobo_new)

bobo_data = data.frame(
  bobo_freq = values(bobo_new),
  landcover = values(coveri)
)
bobo_data$landcover = round(bobo_data$landcover)
bobo_data$landcat = factor(bobo_data$landcover,
                           levels=1:19,
                           labels=coverkey$code
                           )
bobo_data = subset(bobo_data,!is.na(landcover))
landcoverpct = plyr::count(bobo_data$landcover)
landcoverpct$pct = landcoverpct$freq/sum(landcoverpct$freq)
landcoverpct$code = factor(landcoverpct$x,
                           levels=1:19,
                           labels=coverkey$Description
                           )
```

``` r
ggplot(data=subset(bobo_data,landcover%in%c(5:6,14:17)))+
  geom_boxplot(aes(x=landcat,y=bobo_freq))+
  theme(axis.text.x = element_text(angle=90))+
  ggtitle("Bobolink in S Ontario")+
  ylab("Annual frequency")+
  xlab("Landcover")
```
