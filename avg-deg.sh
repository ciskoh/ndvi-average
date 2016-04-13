#!/bin/bash
set -o nounset
set +e

set -e

########################################################################3
# Part of the script that analyses the variance in NDVI to evaluate degradation
#comes after Vegetation Potential calculation 
#made in March 2016 for Grass 7 by Matteo Jucker Riva matteo.jucker@cde.unibe.ch 
###########################################################################

#Degradation evaluation mode 1: CLasses of degradation are based on VP value, then images are merged with average

r.mask -r||true	

		
if [ "$sermode" = "1" ]; then #if for detrmining which type of evaluation should be done

	echo "genVP is :${genvp[@]}"
#	read ok
	
	#obtain list of category values
	lsv=$(r.stats -n input=landscape) #list of all categories in landscape map	
	nlist=$(g.list type=rast pattern=ndvi*) #list of ndvi images	ndvi201401
	dcount=0
		for a in $lsv; do	#cycle through landscape values
		

		r.mask --overwrite raster=landscape maskcats=$a	#mask for present category		
		
		echo "
		***************************************************
		starting cycle 
		for analysis of degradation with method 1

		working on category $a
		*****************************************************" 
 
		VP=${genvp[$dcount]} #value of VP for present category

		#calculating classes of degradation

		vdeg=$((VP/4)) #value for very degraded
		deg=$((VP/2))	#value for degraded
		smdeg=$((vdeg+deg)) #value for healthy
		
			#Cycle through images
			for b in $nlist; do
			
			short=${b:4:10}
			#reducing highest values at 90th quantile	
			r.mapcalc "temp = float(if($b>$VP,$VP,$b))" --overwrite
			
			#rescaling image to VP
			r.rescale --overwrite input=temp output="deg.$a.$short" to="0,100"
			echo "image $b rescaled for category $a. Is it all ok?"
			
			
			done

		#merging single images in one
		
		clist=$(g.list type=rast pattern=deg.$a*) #list of all categories in landscape map
		clist2=`echo $clist | tr " " "," ` #formatting variable for r.patch (adding commas)		
		
		
		echo "images resulting from variance analysis are: $clist2"
		#read ok
		
		r.series input=$clist2 output=fin.$a method=average		#actual merging of degradation maps from single images
		
		#calculating values for deg_stats_$antype.csv
		
		#dividing final map for category according to degradation classes
		r.mapcalc file=- <<EOF
		tempdeg1 = fin.$a<25
		tempdeg2 = fin.$a<50 	
		tempdeg3 = fin.$a<75 	
		tempdeg4 = fin.$a<100 		
		tempdeg5 = fin.$a=100 	
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
			
				
		echo "$a;$lu;$slope;$aspect;$VP;$cc1;$cc2;$cc3;$cc4;$cc5;$tot" >>$vlist
		
		

		dcount=$((dcount+1))	
		
		g.remove -f type=rast pattern=temp*,deg*.20*
		done
	r.mask -r 
	
	#merging final maps in one big final map
	finl=$(g.list type=rast pattern=fin.*)	#getting list of final images to merge
	finl=`echo $finl | tr " " ","` 	#cleaning list of final maps
	echo "check finals map $finl"
	#read ok
	r.patch input=$finl output=final_$antype #actual merging of degradation maps for single categories

	
	#exporting final map
	r.out.gdal input=final_$antype output=$foldout2/final_$antype".tif" format=GTiff

fi


####################################### END OF METHOD 1 ####################################################################################################

#Degradation evaluation mode 2: CLasses of degradation are based on VP value, then images are merged with MEDIAN


r.mask -r||true	

		
if [ "$sermode" = "2" ]; then #if for detrmining which type of evaluation should be done

	echo "genVP is :${genvp[@]}"
#	read ok
	
	#obtain list of category values
	lsv=$(r.stats -n input=landscape) #list of all categories in landscape map	
	nlist=$(g.list type=rast pattern=ndvi*) #list of ndvi images	ndvi201401
	dcount=0
		for a in $lsv; do	#cycle through landscape values
		

		r.mask --overwrite raster=landscape maskcats=$a	#mask for present category		
		
		echo "
		***************************************************
		starting cycle 
		for analysis of degradation with method 2

		working on category $a
		*****************************************************" 
 
		VP=${genvp[$dcount]} #value of VP for present category

		#calculating classes of degradation

		vdeg=$((VP/4)) #value for very degraded
		deg=$((VP/2))	#value for degraded
		smdeg=$((vdeg+deg)) #value for healthy
		
			#Cycle through images
			for b in $nlist; do
			
			short=${b:4:10}
			#reducing highest values at 90th quantile	
			r.mapcalc "temp = float(if($b>$VP,$VP,$b))" --overwrite
			
			#rescaling image to VP
			r.rescale --overwrite input=temp output="deg.$a.$short" to="0,100"
			echo "image $b rescaled for category $a. Is it all ok?"
			
			
			done

		#merging single images in one
		
		clist=$(g.list type=rast pattern=deg.$a*) #list of all categories in landscape map
		clist2=`echo $clist | tr " " "," ` #formatting variable for r.patch (adding commas)		
		
		
		echo "images resulting from variance analysis are: $clist2"
		#read ok
		
		r.series input=$clist2 output=fin.$a method=median #actual merging of degradation maps from single images
		
		#calculating values for deg_stats_$antype.csv
		
		#dividing final map for category according to degradation classes
		r.mapcalc file=- <<EOF
		tempdeg1 = fin.$a<25
		tempdeg2 = fin.$a<50 	
		tempdeg3 = fin.$a<75 	
		tempdeg4 = fin.$a<100 		
		tempdeg5 = fin.$a=100 	
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
			
				
		echo "$a;$lu;$slope;$aspect;$VP;$cc1;$cc2;$cc3;$cc4;$cc5;$tot" >>$vlist
		
		

		dcount=$((dcount+1))	
		
		g.remove -f type=rast pattern=temp*,deg*.20*
		done
	r.mask -r 
	
	#merging final maps in one big final map
	finl=$(g.list type=rast pattern=fin.*)	#getting list of final images to merge
	finl=`echo $finl | tr " " ","` 	#cleaning list of final maps
	echo "check finals map $finl"
	#read ok
	r.patch input=$finl output=final_$antype #actual merging of degradation maps for single categories


	#exporting final map
	r.out.gdal input=final_$antype output=$foldout2/final_$antype".tif" format=GTiff

fi



r.mask -r||true	


############################################### End of Variance analysis Method 2 ##################################################################3


#Degradation evaluation mode 3: First images are merged with AVERAGE, then Degradation is calculated based on VP 


r.mask -r||true	

		
if [ "$sermode" = "3" ]; then #if for detrmining which type of evaluation should be done


	#obtain list of categories and images
	lsv=$(r.stats -n input=landscape) #list of all categories in landscape map	
	nlist=$(g.list type=rast pattern=ndvi* separator=space) #list of ndvi images	


	#merging of NDVI images with AVERAGE
	
	nlist2=`echo $nlist | tr " " ","`	#adding commas between list of NDVI images
	r.series --overwrite input=$nlist2 output=averagendvi method=average	#Merging all the maps in NDVI

	#starting cyle for variance analysis
	
	dcount=0
	for a in $lsv; do	#cycle through landscape categories
		r.mask --overwrite raster=landscape maskcats=$a	#mask for present category		
		
		echo "
		***************************************************
		starting cycle 
		for analysis of degradation with method 3

		working on category $a
		*****************************************************" 
		
		VP=${genvp[$dcount]} #value of VP for present category

		#reducing highest values at 90th quantile	
		r.mapcalc "temp = float(if(averagendvi>$VP,$VP,averagendvi))" --overwrite
			
		#rescaling image to VP
		r.rescale --overwrite input=temp output="deg.$a" to="0,100"
		echo "image rescaled for category $a. Is it all ok?"
	
		#dividing final map for category according to degradation classes
		r.mapcalc file=- <<EOF
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
			
				
		echo "$a;$lu;$slope;$aspect;$VP;$cc1;$cc2;$cc3;$cc4;$cc5;$tot" >>$vlist

		g.remove -f type=rast pattern=temp*
	done

	#merging final maps in one big final map
	finl=$(g.list type=rast pattern=deg.*)	#getting list of final images to merge
	finl=`echo $finl | tr " " ","` 	#cleaning list of final maps
	echo "check finals map $finl"
	#read ok
	r.patch input=$finl output=final_$antype #actual merging of degradation maps for single categories
	
	#exporting final map
	r.out.gdal input=final_$antype output=$foldout2/final_$antype".tif" format=GTiff
		
	
		
		

		dcount=$((dcount+1))	
		
		g.remove -f type=rast pattern=temp*,deg.*


fi


