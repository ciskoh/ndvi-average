#!/bin/bash
set -o nounset
set +e
r.mask -r||true
set -e


#to run this script launch with
#     "  bash /home/matt/Dropbox/github/average/avg-lms-an.sh  "

#################################################################################

# ##MAIN Script to evaluate NDVI change in one area throughout the year
# 2015-11-19 Modified script for average
# steps: 1-importing the images(script avg-ndvi.sh) 2-athmospheric correctio-(script avg-ndvi.sh) 3-NDVI(script avg-ndvi.sh) 4-NDVI analysis against-landscape patches (avg-ls-cat.sh) 5-Export NDVI images

#################################################################################

echo "##############################################################"

echo "Script to evaluate NDVI change in one area throughout the year 

####################################################################"


echo "steps: 
1-importing the images(script ndvi.sh) 
2-athmospheric correction(script ndvi.sh) 

3-NDVI(script ndvi.sh) 

4-creation of landscape map (ls-cat.sh)

4-NDVI analysis against landscape patches  

5-Export NDVI images"



g.region res=30
#detecting folder where script is running "sdir"

sdir=$(cd -P -- "$(dirname -- "$0")" && pwd -P)

echo "sdir is $sdir"
#read ok
#manual input for basic variable or script


varpath=$(zenity --file-selection)
	. $varpath


#writing file with script details
readme=$foldout/README-script-details.txt #path to readme txt
echo "Analysis of NDVI Variance in one area throughout the year" >$readme
loc=$(g.gisenv -n get=LOCATION_NAME)
da=$(date)
echo "Executed for the area of $loc on $da">>$readme 

sets=$(sed -n 3,13p $varpath)
echo "
The following settings where used:

$sets

***************************">>$readme



#create output folder

mkdir -p $foldout/ndvi
mkdir -p $foldout/statistics
mkdir -p $foldout/vectors
mkdir -p $foldout/rasters


g.region res=30

#landscape vector map creation or importing

if [ "$shc" -eq "1" ]; then

	. $sdir/avg-ls-cat.sh;
	
fi

echo "landscape created, is it all ok????"


r.mask raster=landscape


####END of Importing and correcting landscape

echo "END of Importing and correcting landscape"
#read ok
################LANDSAT import, athmospheric correction and ndvi calculation on subscript ndvi.sh



if [ "$imp" -eq "1" ];
	then
	echo "I will import the images"
	#read ok
	. $sdir/avg-ndvi.sh;
	else 
	nlist2=`cat $foldout/statistics/ndvi_list2.txt`
	echo "I will not import the images, will use those instead: $nlist2"
	##read ok;
fi

echo "end of image classification"



#########classification of ndvi variance through variance.sh
#r.mask -r||true

## for state map
#s=a0
#basemap=landscape_state
#mkdir -p $foldout/state
#foldout2=$foldout/state




#STEP 4: QUANTILE CALCULATIONS


#starting cycle for each category

r.mask -r ||true

echo "

***************************************************
starting cycle 
for VP calculations WITH LANDFORMS


****
*************************************************" 
antype=$VPtype
mkdir -p $foldout/"results_"$antype  #creating folder for storing results

foldout2=$foldout/"results_"$antype	#folder for results variable

landscape=landscape  #map to use with landforms



. /home/matt/Dropbox/github/average/avg-VP.sh #launching script for VP calculation



###########END of VP calculation WITH LANDFORMS ####################################################


echo "

***************************************************
starting 
degradation calculation WITH LANDFORMS


****
*************************************************" 
#read ok

. /home/matt/Dropbox/github/average/avg-deg.sh


g.remove -f type=rast pattern=corr*,fin.* #deleting final degradation files
#r.mask -r ||true
#scount=0

##############################Start VP and DEG calculation NO LANDFORMS  ######################################################

r.mask -r ||true

echo "

***************************************************
starting cycle 
for VP calculations NO LANDFORMS


****
*************************************************" 
antype=$VPtype"_NO_LF"

mkdir -p $foldout/"results_"$antype  #creating folder for storing results

foldout2=$foldout/"results_"$antype	#folder for results variable

r.mapcalc "landscapeNOLF = int((landscape-10)/100)"

landscape=landscapeNOLF  #map to use NO landforms


. /home/matt/Dropbox/github/average/avg-VP.sh #launching script for VP calculation



###########END of VP calculation NO LANDFORMS ####################################################


echo "

***************************************************
starting 
degradation calculation NO LANDFORMS


****
*************************************************" 
#read ok

. /home/matt/Dropbox/github/average/avg-deg.sh


################################################################################################################################

###final addition to $readme file to confirm that the script was completed

a=$(date)
echo "
***************************

Script finished successfully at $a !!!!!!

***************************" >>$readme






echo "ALL finished
#
##
###
####
#####
######
#######


GOODBYE GOODBYE GOODBYE GOODBYE GOODBYE


#######
######
####
###
##
#"




