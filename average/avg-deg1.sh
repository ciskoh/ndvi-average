#!/bin/bash
set -o nounset
set +e

set -e


r.mask -r||true	

g.remove -f type=rast pattern=fin*,deg*,temp*

########################################################################3
# Part of the script that analyses the variance in NDVI to evaluate degradation
#comes after Vegetation Potential calculation 
#made in March 2016 for Grass 7 by Matteo Jucker Riva matteo.jucker@cde.unibe.ch 
###########################################################################

# Degradation evaluation mode 1: Classes are mean-SD, mean, mean+SD


r.mask -r||true	

		
if [ "$VPtype" = "1" ]; then #if for determining which type of evaluation should be done


#	obtain list of categories and images
#	lsv=$(r.stats -n input=$landscape) list of all categories in landscape map	
#	nlist=$(g.list type=rast pattern=ndvi* separator=space) list of ndvi images	


#	merging of NDVI images with AVERAGE
#	
#	nlist2=`echo $nlist | tr " " ","`	adding commas between list of NDVI images
#	r.series --overwrite input=$nlist2 output=averagendvi method=average	Merging all the maps in NDVI

	#starting cyle for variance analysis
	
	dcount=0
	echo "dcount is $dcount"
	for a in $lsv; do	#cycle through landscape categories
		
				
		
		echo "
		***************************************************
		starting cycle 
		for analysis of degradation with method 1 
		( mean + SD )

		working on category $a
		*****************************************************" 
		r.mask --overwrite --verbose raster=$landscape maskcats=$a	#mask for present category
			x=`r.univar -g --quiet map=MASK`
		echo " mask is $x

all ok?"

		
		### New part to calculate with method 1 MEAN+SD
		
		VP=${genvp[$dcount]} 	 								# value of VP for present category
		min=${arraymin[$dcount]} 								# value of min for present category
		max=${arraymax[$dcount]}
 		
		# Calculating boundaries of categories according to method 1
		
		b=`r.univar -g map=averagendvi` 			
		# getting 90th quantile from single image
		
		eval "$b"
		
		mean=$(echo "($mean+0.5)/1" | bc) 
		stddev=$(echo "($stddev+0.5)/1" | bc) 
		
		b1=$(( mean - stddev ))   # boundary 1 ( VD / Deg )
		b2=$mean              # boundary 2 ( Deg / Healthy )
		b3=$(( mean + stddev ))   # boundary 3 ( Healthy / VP )
				
		echo "min is $min, max is $max, VP is $VP, boundaries are $b1, $b2, $b3"
		
# writing rules to file /tmp/rules.txt

echo "$min thru $b1 = 1" >/tmp/rules.txt
echo "$b1 thru $b2 = 2" >>/tmp/rules.txt
echo "$b2 thru $b3 = 3" >>/tmp/rules.txt
echo "$b3 thru $max = 4" >>/tmp/rules.txt
		
                echo "do map"	
		
		r.reclass input=averagendvi output=deg.$a rules=/tmp/rules.txt
		echo "map deg.$a is complete"
		
		#dividing final map for category according to degradation classes
		r.mapcalc --overwrite file=- <<EOF
		tempdeg1 = deg.$a=1
		tempdeg2 = deg.$a=2 	
		tempdeg3 = deg.$a=3 	
		tempdeg4 = deg.$a=4 		
		tempdeg5 = deg.$a=5 	
EOF

		#getting cell count for each category of degradation
		c1=$(r.univar -g --quiet map=tempdeg1)	#get cell count for Very degraded
		cc1=`echo $c1 | rev | cut -d= -f1 | rev`	#clean cell count string Very degraded
		
		c2=$(r.univar -g --quiet map=tempdeg2)	#get cell count for Degraded
		cc2=`echo $c2 | rev | cut -d= -f1 | rev`	#clean cell count string Degraded
		
		c3=$(r.univar -g --quiet map=tempdeg3)	#get cell count for Semi degraded
		cc3=`echo $c3 | rev | cut -d= -f1 | rev`	#clean cell count string Semi degraded

		c4=$(r.univar -g --quiet map=tempdeg4)	#get cell count for healthy
		cc4=`echo $c4 | rev | cut -d= -f1 | rev`	#clean cell count string healthy

		c5=$(r.univar -g --quiet map=tempdeg5)	#get cell count for PV
		cc5=`echo $c5 | rev | cut -d= -f1 | rev`	#clean PV
		
		
		tot=$n	#clean cell count for the whole category
		
		#dividing category for stats file
		lu=$((a/100))	#land use
		slope=$(((a/10)-(lu*10)))	#slope
		aspect=$((a-(lu*100)-(slope*10)))	#aspects
			
				
		echo "$a;$lu;$slope;$aspect;$min;$max;$VP;$cc1;$cc2;$cc3;$cc4;$cc5;$tot" >>$vlist
		
		
		r.mask -r||true
		
		dcount=$((dcount+1))
		
		
		
	done
	r.mask --overwrite raster=$landscape	
	
	#merging final maps in one big final map
	finl=$(g.list type=rast pattern=deg.*)	#getting list of final images to merge
	finl=`echo $finl | tr " " ","` 	#cleaning list of final maps
	echo "check finals map $finl"
	#read ok
	r.patch input=$finl output=final_$antype #actual merging of degradation maps for single categories
	
	
	#exporting final map
	
	r.out.gdal input=final_$antype output=$foldout2/final_$antype".tif" format=GTiff
		
	g.remove -f type=rast pattern=deg.*,temp*
		
		
fi

### END OF DEG CLASSIFICATION WITH METHOD 1



