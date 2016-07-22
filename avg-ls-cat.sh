#!/bin/sh



#algorithm for creation of homogeneous landscape categories based on dtm and land use map. Used in yearly ndvi analysis and similar.
#Requires land use/management map, dtm


r.mask -r ||true



## Import files

g.remove -f type=raster name=MASK

#change mapset resolution

g.region res=10

#Import DTM

echo " Importing DTM"
r.in.gdal --overwrite --quiet input=$DTM output=DTM

echo " Importing land use"
v.in.ogr --overwrite --quiet dsn=$LU output=LU_vec snap=1e-07

#g.list type=rast,vect
echo "verify imported files"
##read ok

#END of import files

############################    WORK ON LAND USE #################################################################

# Rasterize land use

echo "rasterizing land use" 

echo "LU raster will have two 0"

v.to.rast --overwrite input=LU_vec output=lu.rast2 use=attr attribute_column=$col 
r.mapcalc 'lu.rast=lu.rast2*100'

r.mask --overwrite raster=lu.rast 

#patch neighbors to delete no data

#r.patch --o input=lu.neigh7,lu.neigh5,lu.neigh3,lu.neigh1 output=lu.gen






##########Work on DTM#########################

#change mapset resolution

g.region vect=LU_vec res=30


#verify dtm resolution and correct it 
r.resamp.interp --overwrite input=DTM output=dtm15 method=bicubic

#create slope and aspect from dtm

echo "creating slope and aspect from dtm" 
r.slope.aspect --overwrite --verbose elevation=dtm15 slope=slope aspect=asp precision=FCELL 

####1b+5b reclass raster in appropriate classes
echo "working on aspect"


####2 reclass aspect 
#asp.reclass has no "0"!!!
########

r.reclass --overwrite input=asp output=asp.reclass rules=$arul

####3 neghborhood generalisation

##################################
#reclassification is done by eliminating all areas under 2 hectares (1) than filling that with homogeneous areas from neighborhood generalisation(2) 
#######################################

#reclass small areas (1)
r.reclass.area input=asp.reclass output=asp.recl_big value=2 mode=greater

###fill the holes (2)

#neighbour gen 1
#r.neighbors -c input=asp.reclass output=asp.neigh1 method=mode size=1

#neighbour gen 3 
#r.neighbors -c input=asp.reclass output=asp.neigh3 method=mode size=3

#neighbour gen 5
#r.neighbors -c input=asp.reclass output=asp.neigh5 method=mode size=5

#neighbour gen 7
#r.neighbors -c input=asp.reclass output=asp.neigh7 method=mode size=7

#patch neighbors to delete no data

#r.patch --overwrite input=asp.recl_big,asp.neigh7,asp.neigh5,asp.neigh3,asp.neigh1 output=asp.gen

r.mapcalc "asp.gen =asp.reclass" ||true

echo " is asp.gen ok?"
##read ok
#send categories and labels to txtfile

r.describe -1 -n map=asp.gen >$foldout/statistics/asp_cat.txt

#g.remove -f type=rast name=asp.recl_big,asp.neigh7,asp.neigh5,asp.neigh3,asp.neigh1

####4 reclass slope slope.reclass has one "0"
 
r.reclass --overwrite input=slope output=slope.reclass rules=$srul

##################################
#reclassification is done by eliminating all areas under 2 hectares (1) then filling that with homogeneous areas from neighborhood generalisation 
#######################################
#reclassifying small areas (1)
r.reclass.area --overwrite input=slope.reclass output=slope.recl_big value=2 mode=greater

#neghborhood generalisation (2)
#neighbour gen 1
#r.neighbors -c --overwrite input=slope.reclass output=slope.neigh1 method=mode size=1

#neighbour gen 3 
#r.neighbors -c --overwrite input=slope.reclass output=slope.neigh3 method=mode size=3

#neighbour gen 5
#r.neighbors -c  --overwrite input=slope.reclass output=slope.neigh5 method=mode size=5

#neighbour gen 7
#r.neighbors -c  --overwrite input=slope.reclass output=slope.neigh7 method=mode size=7

#patch neighbors to delete no data

#r.patch --overwrite input=slope.recl_big,slope.neigh7,slope.neigh5,slope.neigh3,slope.neigh1 output=slope.gen 


r.mapcalc "slope.gen =slope.reclass" --overwrite
echo " is slope.gen ok?"
##read ok

#g.remove -f type=rast name=slope.recl_big,slope.neigh7,slope.neigh5,slope.neigh3,slope.neigh1

r.describe -1 -n map=slope.gen >$foldout/statistics/slope_cat.txt

####5 combine slope and aspect

echo " combining slope and aspect" 

r.mapcalc 'slopeasp =slope.gen+asp.gen'

#generalize slope.asp

#neighbour gen 1
#r.neighbors -c input=slope.asp output=slopeasp.neigh1 method=mode size=1

#neighbour gen 3 
#r.neighbors -c input=slope.asp output=slopeasp.neigh3 method=mode size=3

#neighbour gen 5
#r.neighbors -c input=slope.asp output=slopeasp.neigh5 method=mode size=5

#neighbour gen 7
#r.neighbors -c input=slope.asp output=slopeasp.neigh7 method=mode size=7

#patch neighbors to delete no data

#r.patch --o input=slopeasp.neigh7,slopeasp.neigh5,slopeasp.neigh3,slopeasp.neigh1 output=slopeasp.gen

echo "is slopeasp.gen ok?"
##read ok

#g.remove -f type=rast name=slopeasp.neigh7,slopeasp.neigh5,slopeasp.neigh3,slopeasp.neigh1


#######################################################################
#7 merge slopeasp and land use

echo " merging slopeasp and land use"

r.mapcalc "landscape = int(slopeasp+lu.rast)" --overwrite


#generalize landscape small areas
r.reclass.area --overwrite input=landscape output=landscape_big value=2 mode=greater

#neighbour gen 1
r.neighbors -c input=landscape output=landscape.neigh1 method=mode size=1

#neighbour gen 3 
r.neighbors -c input=landscape output=landscape.neigh3 method=mode size=3

#neighbour gen 5
r.neighbors -c input=landscape output=landscape.neigh5 method=mode size=5

#neighbour gen 7
#r.neighbors -c input=landscape output=landscape.neigh7 method=mode size=7

#patch neighbors to delete no data

r.patch --o input=landscape_big,landscape.neigh5,landscape.neigh3,landscape.neigh1 output=landscape

echo "the landscape raster is ready, code is first land use, second slope, third aspect. got it?"
##read ok

echo "check if landscape is ok"
#read ok 

g.remove type=rast name=landscape_big,landscape.neigh7,landscape.neigh5,landscape.neigh3,landscape.neigh1


###################################################################

#export landscape map
r.out.gdal -f --overwrite input=landscape output=$foldout/vectors/landscape_system.tif format=GTiff type=Int16

echo "landscape patch raster has been exported to $foldout/vectors"

#export landscape as vector
r.to.vect -s -v --overwrite --verbose input=landscape output=landscape feature=area
v.out.ogr -s -e  --overwrite --verbose input=landscape type=area output=$foldout/vectors/landscape format=ESRI_Shapefile 

#export area stats per landscape map
echo "

The following landscape categories where created:

" >>$readme
lsv=$(r.stats -n input=landscape) >>$readme

r.mask -r||true

#merge all aspects and slopes for state map
r.reclass input=landscape output=landscape_state rules=/media/matt/MJR-gis/3-Spain/ls_analysis/input/landscape_rules.txt


#removing useless raster
g.remove -f type=rast pattern=t*,MASK
g.remove -f type=rast pattern=t*,MASK
g.remove -f type=rast pattern=t*,MASK

echo "##########################################################################

CREATION OF LANDSCAPE MAP COMPLETE....
.....
....
....
.......RETURNING TO MAIN SCRIPT LMS-AN.SH

#########################################################################################"


