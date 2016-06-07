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

#Degradation evaluation mode 3: First images are merged with AVERAGE, then Degradation is calculated based on VP 


r.mask -r||true	

sermode=3		#for calc type
		
if [ "$sermode" = "3" ]; then #if for detrmining which type of evaluation should be done


	#obtain list of categories and images
	lsv=$(r.stats -n input=$landscape) #list of all categories in landscape map	
	nlist=$(g.list type=rast pattern=ndvi* separator=space) #list of ndvi images	


	#merging of NDVI images with AVERAGE
	
	nlist2=`echo $nlist | tr " " ","`	#adding commas between list of NDVI images
	r.series --overwrite input=$nlist2 output=averagendvi method=average	#Merging all the maps in NDVI

	#starting cyle for variance analysis
	
	dcount=0
	for a in $lsv; do	#cycle through landscape categories
		
				
		
		echo "
		***************************************************
		starting cycle 
		for analysis of degradation with method 3

		working on category $a
		*****************************************************" 
		r.mask --overwrite --verbose raster=$landscape maskcats=$a	#mask for present category
		x=`r.univar -g --quiet map=MASK`
		echo " mask is $x

all ok?"
#read ok
		VP=${genvp[$dcount]} 	 								# value of VP for present category
		min=${arraymin[$dcount]} 								# value of min for present category
		max=${arraymax[$dcount]}
 		

		#to check VP accuracy
		r.mapcalc --overwrite "tempVP = averagendvi>$VP" # getting part above VP
		r.null map=tempVP setnull=0          # deleting 0
		aVP=`r.univar -g map=tempVP | cut -d= -f2`
		set -- $aVP
		avp=$(echo $1)                         # cellcount of above VP
		bVP=`r.univar -g map=MASK | cut -d= -f2`
		set -- $bVP
		bvp=$(echo $1)                         # cellcount this category

		perc=$((bvp/avp))

	
		
		echo "min is $min, max is $max, VP is $VP, avp is $avp, bvp is $bvp, perc is $perc"
		#read ok
		
				
		#reducing highest values at 90th quantile, cutting minimum value to higher minimum	
		r.mapcalc "temp.$a = float(if(averagendvi>$VP ,$VP ,averagendvi ))" --overwrite		# reducing hihgest values to VP
#		r.mapcalc "temp = float(if(temp2<$min, $min, temp2))" --overwrite			# reducing lowest values to higher min	

		echo "check temp.$a"
		#read ok
		#rescaling image to VP
		r.rescale --overwrite input="temp.$a" output="deg.$a" to="0,100"
		
		#checking perc
		r.mapcalc --overwrite "tempVP2 = deg.$a>100" # getting part above VP
		r.null map=tempVP2 setnull=0          # deleting 0
		aVP2=`r.univar -g map=tempVP | cut -d= -f2`
		set -- $aVP2
		avp2=$(echo $1)                         # cellcount of above VP
		bVP2=`r.univar -g map=MASK | cut -d= -f2`
		set -- $bVP2
		bvp2=$(echo $1)                         # cellcount this category

		perc2=$((bvp2/avp2))
		
		echo "image rescaled for category $a, perc is $perc2. Is it all ok?"
		#read ok
		
#		#displaying map obtained
#		d.mon stop=wx0||true
#		d.mon start=wx0
#		d.rast MASK;d.rast deg.$a
		echo "image rescaled for category $a. check deg.$a!!"
		
		
		


		#dividing final map for category according to degradation classes
		r.mapcalc --overwrite file=- <<EOF
		tempdeg1 = deg.$a<25
		tempdeg2 = deg.$a<50 	
		tempdeg3 = deg.$a<75 	
		tempdeg4 = deg.$a<100 		
		tempdeg5 = deg.$a=100 	
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
		
		
		tot=$((cc1+cc2+cc3+cc4+cc5))	#clean cell count for the whole category
		
		#dividing category for stats file
		lu=$((a/100))	#land use
		slope=$(((a/10)-(lu*10)))	#slope
		aspect=$((a-(lu*100)-(slope*10)))	#aspects
			
				
		echo "$a;$lu;$slope;$aspect;$min;$max;$VP;$cc1;$cc2;$cc3;$cc4;$cc5;$tot" >>$vlist
		#read ok
		
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
	d.mon stop=wx0||true
	
	#exporting final map
	
	r.out.gdal input=final_$antype output=$foldout2/final_$antype".tif" format=GTiff
		
	g.remove -f type=rast pattern=deg.*,temp*
		
		
fi


