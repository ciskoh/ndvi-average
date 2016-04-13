#!/bin/bash
set -o nounset
set +e
r.mask -r
set -e

#Script that runs through a folder with landsat images, imports them in grass and calculates ndvi for each of them. Used as subscript of ndvi yearly analysis and modifications.

#requires the following variables: 
#fold=folder with satellite images foldout=output 
#foldout=folder with /ndvi subfolder for export

# 1-IMPORTING IMAGES
#set adequate resolution


count=0

g.region res=30
echo "here is the setting from the region:"
g.region -p

#detect name os satellite image

for i in $fold/*;
do

	 #updating the counter


	echo "


	this is the $count time I do the script.....


	"
	#identify month of picture

	echo "i is $i"
	name=${i##*/}
	echo "name is $name"
	##read ok
	ent=$(sed -n '21p' $i/$name"_MTL.txt")
	ent="$(echo "${ent}" | tr -d '[[:space:]]')"

	ldate="${ent##*=}"
	#ldate2=$(echo -e "${ldate}" | sed -e 's/^[[:space:]]*//')
	echo "ent is $ent date is $ldate"
	#read ok
	year=`echo $ldate |cut -d- -f1`
	echo "year is $year"
	#ent2=${ldate#*-}
	#echo "ent2 is $ent2"
	month=`echo $ldate | cut -d- -f2` #month numeric value
	sdate=$month
	
	##read ok
	
		echo "ent is $ent, year is $year,ldate is $ldate sdate is $sdate yoyoyo"
	##read ok
	

	if [ $count -eq "0" ]; then
		
	
		echo "

****************************
		
		The following images are considered for the analysis:

" >>$readme
	fi
	short=$year$month

	echo "name=$short date=$ldate image=$name" >>$readme
	 
	echo "month is $month; check output file $readme"
	#read ok

	short=$year$month

	#short=${name:9:7};
	#echo "short is $short";
	echo "short is $short"
	#read ok

	#subloop to import all bands of the image

	for b in $i/*; do
		echo $b
		#read ok
		temp=`echo $b | rev| cut -d/ -f1 |rev`
		echo "temp is $temp"
		#read ok
		if [[ $temp = *.TIF ]];then
			echo "$temp is a TIF"
			#read ok
			band=${b##*/}
			echo $band
			#read ok
			sband=${band:21:4}
			sband=${sband//./}

			#import bands for image 

			echo "importing band $sband"
			r.in.gdal -o --overwrite input=$b output=$short$sband;
		fi;
	
	done 

	echo "check imported bands of image $name"
	####read ok

	# 2-ATHMOSPHERIC CORRECTION

	#name of metadata file
	meta=$i"/"$name"_MTL.txt"
	
	#name of corrected picture
	corr="corr_"$short
	echo "meta is $meta; corr is $corr"
	#read ok
	#athmospheric correction

	i.landsat.toar input=$short"_B" output=$corr"." metfile=$meta 		sensor=oli8 method=dos2

	echo "check athmospheric corrected images"
	#read ok

	#3-ndvi calculation
	#ndvi for corrected images

	b4=$corr".4"
	b5=$corr".5"

	echo "this are the rasters for ndvi: $b4 and $b5"
	####read ok


	#NDVI calc-string for mapcalc

	r.mapcalc "corr.$short =float($num*($b5-$b4)/($b5+$b4))" --overwrite
		r.mapcalc "ndvi$short =int(corr.$short)" --overwrite	#multiplying to avoid problems  with floats in bash and grass
	echo "verify NDVI: corr$short"
	#read ok
	#exporting NDVI

	r.out.gdal -c -f input=ndvi$short type=Float64 output=$foldout/ndvi/ndvi_$short".tif"

	echo "check exported ndvi at $foldout/ndvi"



	

	echo "cycle restarting"
	####read ok
count=$((count+1));
done

#deleting useless raster
echo "cycle finished!!!!!



deleting useless raster...."

g.remove -f type=rast pattern="$short" #deleting useless rasters
g.remove -f type=rast pattern=corr*


#obtain list of all ndvi maps
g.list -m type=raster pattern=ndvi* separator=comma >/$foldout/statistics/ndvi_list.txt
g.list -m type=raster pattern=ndvi* >/$foldout/statistics/ndvi_list2.txt

echo "check list at /$foldout/statistics/ndvi_list.txt"
####read ok


#end
echo "all the images from $fold have been imported into grass

##################################################################

END OF NDVI.SH

RETURNING TO LMS-AN.SH

#################################################################"


