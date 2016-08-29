#!/bin/bash
set -o nounset #checks the variables
set -e	#exits on error

########################################################################3
# Part of the script that calculates the Vegetation Potential depending on the method chose for VPtype
#comes after NDVI calculation 
#made in March 2016 for Grass 7 by Matteo Jucker Riva matteo.jucker@cde.unibe.ch 

# to launch use " bash /home/matt/Dropbox/github/average/avg-lms-an.sh"
###########################################################################



#Calculation of VP TYPE 1. VP is MEAN+SD, Very degraded is VP-SD



max=-100
min=-100

if [ "$VPtype" = "1" ]; then
	

	#obtain list of category values
	lsv=$(r.stats -n input=$landscape) 			# list of all categories in landscape map	
	#nlist=$(g.list type=rast pattern=ndvi* separator=space) # list of ndvi images	

	echo "this is the list of categories: $lsv
	"
		#read ok
	cicle through categories
	
	
	
#	Merging all the maps in NDVI
	nlist2=`echo $nlist | tr " " ","`
	r.series --overwrite input=$nlist2 output=averagendvi method=average
	r.mapcalc "averagendvi = int(averagendvi)" --overwrite

#	 exporting averagendvi
	r.out.gdal --overwrite input=averagendvi output=$foldout/ndvi/averagendvi.tiff format=GTiff	
	
#	loop to calculate vegetation potential for each category
	
	#obtain list of category values
	lsv=$(r.stats -n input=$landscape) #list of all categories in landscape
	
	vpcount=0
	for i in $lsv; do
		
		echo "
		***************************************************
		starting cycle 
		for VP calculations mode 1 (SD method)

		working on category $i
		count is $vpcount
		*****************************************************" 
	
		#creating mask for the specific $landscape category	
		r.mask --overwrite raster=$landscape maskcats=$i
		
		#creating statistics file for VP	
		if [[ "$vpcount" -eq "0" ]]; then 		# if for creating folder for statistics
			echo "creating stats csv files"
						
			vlist=$foldout2/deg_stats_$antype.csv 	# name of degradation stats file 
			echo "ls-code; land use; slope; aspect; min; max; VP value; Very degraded; Degraded; Semidegraded; Healthy; Vegetation Potential; Totalcellcount " >$vlist #creating stats file and column headers
		
			vlist2=$foldout2/VP-$antype-detail.csv 					# name of statistics file for detailed VP analysis
			a=`echo $nlist | tr " " "; " ` 						# list of images for column titles
			echo "category; VPvalue" >$vlist2; 					# list of images for column titles
		fi

		a=`r.univar -g -e map=averagendvi separator=comma | rev | cut -d= -f1 | rev`    #for min and max values

### New part to calculate with method 1 MEAN+SD
		
		b=`r.univar -g map=averagendvi` 			
		# getting 90th quantile from single image
		
		eval "$b"
		
		mean=$(echo "($mean+0.5)/1" | bc) 
		stddev=$(echo "($stddev+0.5)/1" | bc) 
		
		VPave=$(( mean + stddev )) 


		echo "mean is $mean; stdev is $stddev, VP is $VPave"
		# read ok			
		
		# getting minimum value
                min=`echo $a | cut -d" " -f4`       # getting new minimum value from current images
		
		# getting maximum value
		max=`echo $a | cut -d" " -f5`       # getting new minimum value from current images
			
		
		genvp[$vpcount]=$VPave		    # genVP is a general array where the median VP value for each category is stored
		
		# storing min and max values in arrays               	
		arraymin[$vpcount]=$min
		arraymax[$vpcount]=$max	
		
		#updating $foldout/statistics/VP-mode3-detail.csv 
		echo "$i;$VPave" >>$vlist2
		echo "Max is $max, Min $min and VP is $VPave"			# just verifying max and min
		#read ok	

		vpcount=$((vpcount+1))	
	done

	#creating csv file for VP data	


	echo "VP calculations finished for all categories with method 1! " >>$readme
	echo "VP values from average NDVI are: ${genvp[@]} " >>$readme
	
	g.remove -f type=rast pattern=test*
	
fi
	
#### END of calculation with method 1

########################################################################################################



#Calculation of VP TYPE 2. First all images are combined with AVERAGE value, then VP is calculated. VD is q10

if [ "$VPtype" -gt "1" ]; then
	

	#obtain list of category values
	lsv=$(r.stats -n input=$landscape) 			# list of all categories in landscape map	
#REmoved because using ndviaverage (pre-prepared)	
	nlist=$(g.list type=rast pattern=ndvi* separator=space) # list of ndvi images	

	echo "this is the list of categories: $lsv
	and this is the list of images: $nlist"
	#	#read ok
	#cicle through categories
	
	
	#Merging all the maps in NDVI
	nlist2=`echo $nlist | tr " " ","`
	r.series --overwrite input=$nlist2 output=averagendvi method=average
	r.mapcalc "averagendvi = int(averagendvi)" --overwrite
		
	#loop to calculate vegetation potential for each category
	
	#obtain list of category values
	lsv=$(r.stats -n input=$landscape) #list of all categories in landscape
	vpcount=0
	for i in $lsv; do
		
		echo "
		***************************************************
		starting cycle 
		for VP calculations mode 2 or more (VP90)

		working on category $i
		count is $vpcount
		*****************************************************" 
	
		#creating mask for the specific $landscape category	
		r.mask --overwrite raster=$landscape maskcats=$i
		
		#creating statistics file for VP	
		if [[ "$vpcount" -eq "0" ]]; then 		# if for creating folder for statistics
			echo "creating stats csv files"
						
			vlist=$foldout2/deg_stats_$antype.csv 	# name of degradation stats file 
			echo "ls-code; land use; slope; aspect; min; max; VP value; q10; Very degraded; Degraded; Semidegraded; Healthy; Vegetation Potential; Totalcellcount " >$vlist #creating stats file and column headers
		
			vlist2=$foldout2/VP-$antype-detail.csv 					# name of statistics file for detailed VP analysis
			#a=`echo $nlist | tr " " "; " ` 						# list of images for column titles
			echo "category; VPvalue" >$vlist2; 					# list of images for column titles
		fi

		a=`r.univar -g -e map=averagendvi separator=comma | rev | cut -d= -f1 | rev`    #for min and max values

		b=$(r.quantile --quiet input=averagendvi percentiles=90) 			# getting 90th quantile from single image
		VPave=`echo $b | rev | cut -d":" -f1 | rev` 					# actual value of 90th quantile
		
		#getting minimum value
			
                min=`echo $a | cut -d" " -f4`           					# getting new minimum value from current images
		
		#getting maximum value
		max=`echo $a | cut -d" " -f5`           					# getting new minimum value from current images
			
		# New minimum value for Very degraded boundary
		c=$(r.quantile --quiet input=averagendvi percentiles=10)
		q10=`echo $c | rev | cut -d":" -f1 | rev` 
		VDval[$vpcount]=$q10


		genvp[$vpcount]=$VPave								# genVP is a general array where the median VP value for each category is stored
		
		# storing min and max values in arrays               	
		arraymin[$vpcount]=$min
		arraymax[$vpcount]=$max	
		
		#updating $foldout/statistics/VP-mode3-detail.csv 
		echo "$i;$VPave" >>$vlist2
		echo "Max is $max, Min $min, q10 is $q10 and VP is $VPave"			# just verifying max and min
#		read ok	

		vpcount=$((vpcount+1))	
	done

	#creating csv file for VP data	


	echo "VP calculations finished for all categories with method 3! " >>$readme
	echo "VP values from average NDVI are: ${genvp[@]} " >>$readme

	g.remove -f type=rast pattern=test*
	
fi

# exporting averagendvi
	r.out.gdal --overwrite input=averagendvi output=$foldout/ndvi/averagendvi.tiff format=GTiff	

echo "==============================================================================================

END OF VP CALCULATION 
=============================================================================================="

	
