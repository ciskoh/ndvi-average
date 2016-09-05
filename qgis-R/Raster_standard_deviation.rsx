##raster = group
##layer = raster
##layer2 = raster
##output = raster



# phenology 2 - Script to analyse and correct land use map based on phenology

library("raster")
#### Input data ####

## Folder with phenology indicators
# indicators should be as multilayer rasters (Tiff) with each layer correspondign to one year

str.phen <- "/home/matt/Dropbox/ongoing/ndvi mapping/DATA/Greece/4-phenology/indicators"


## Path to Land use map

str.lus <- "/home/matt/Dropbox/ongoing/ndvi mapping/DATA/Greece/4-phenology/landuse2.tif"

#### IMPORTING DATA #####



# importing land use map
lus <- raster(str.lus)
# identifying land use type
l.lus <- unique(as.vector(lus) )




# importing phenology indicators
ind <- list.files(path = str.phen, pattern = "ph*" )

for (i in ind) {
temp.st <- stack( paste( str.phen, "/", i, sep = "" ) ) 
extent(temp.st) <- extent(lus)
name = substr(i, 4, nchar(i)-4 )
assign(paste("ph.", name, sep = ""), temp.st)
}



## end importing data
par(pfrow=c(2,1))
plot(lus)
ncol(lus)
ncol(ph.dur)

extent(ph.dur)
#### Characterisation ####

# function to apply mask
# r is the raster to mask, v is the value to use in lus, returns raster or stack called "masked"

f.mask <- function(r, v) { 
  t.lus.mask <- lus
  t.lus.mask[ t.lus.mask != v ] <- NA 
  masked <- mask(r, t.lus.mask)
  return(masked)
}
x=ph.dur[130,260]
ave= c(20,13,16)
range= cellStats(ph.dur, stat = "max")- cellStats(ph.dur, stat = "min")

# function to calculate difference from average
f.diff <- function(x) {
  a <- as.vector(x)
  if ( !anyNA(a) && x > 0) {
    temp.rsd<- sum(((a-ave)^2)/(ave^2))/length(a) # relative st. deviation
    b <- temp.rsd
  } else b <- 0
  
  x <- as.numeric(b*300)
 
}
  
