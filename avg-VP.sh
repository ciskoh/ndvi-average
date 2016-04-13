#!/bin/bash
set -o nounset #checks the variables
set -e	#exits on error

########################################################################3
# Part of the script that calculates the Vegetation Potential depending on the method chose for VPtype
#comes after NDVI calculation 
#made in March 2016 for Grass 7 by Matteo Jucker Riva matteo.jucker@cde.unibe.ch 

# to launch use " bash /home/matt/Dropbox/github/average/avg-lms-an.sh"
###########################################################################

#Calculation of VP TYPE 1. First VP for all images, than merging with average


if [ "$VPtype" = "1" ]; then
	

	#obtain list of category values
	lsv=$(r.stats -n input=landscape) #list of all categories in landscape map	
	nlist=$(g.list type=rast pattern=ndvi*) #list of ndvi images	

	echo "this is the list of categories: $lsv
	and this is the list of images: $nlist"
	#	#read ok
	#cicle through categories
	vpcount=0 #counter for categories cicle
	for i in $lsv; do
	
	
		echo "
		***************************************************
		starting cycle 
		for VP calculations mode 1

		working on category $i
		*****************************************************" 
	
		#creating mask for the specific landscape category	
		r.mask --overwrite raster=landscape maskcats=$i

		#creating statistics file for VP	
		if [[ "$vpcount" -eq "0" ]]; then #if for creating folder for statistics
		
			vlist=$foldout2/deg_stats_$antype.csv #name of degradation stats file 
			echo "ls-code; land use; slope; aspect; VP value; Very degraded; Degraded; Semidegraded; Healthy; Vegetation Potential; TotalCellCount " >$vlist #creating stats file and column headers
		
			vlist2=$foldout2/VP-$antype-detail.csv #name of statistics file for detailed VP analysis
			a=`echo $nlist | tr " " "; " ` #list of images for column titles
			echo "category;$a; average" >$vlist2; #list of images for column titles
		fi

				#cicle to calculate VP for each image
		

		icount=0
		for g in $nlist; do #cicling through images
			echo "working on category $i and image $g"
			##read ok
			a=`r.univar -g -e map=$g separator=comma | rev | cut -d= -f1 | rev` #getting 90th quantile from single image
			VP=`echo $a | rev | cut -d" " -f1 | rev` #actual value of 90th quantile
							
			arrayVP[$icount]=$VP #array for storing single image VP VALUES
			icount=$((icount+1));
		done

		echo "icount is $icount vp values for category $i are:${arrayVP[@]}" 
		##read ok

		#calculation of VP for present category
		total=0 #to avoid onboud variable	
		#calculate the length of the array
		
		for var in "${arrayVP[@]}"; do #cicle through array values
			total=$(($total + $var)) #sum of values in array
			echo "total is $total"
		done
		
		VPave=$(($total/($icount))) #this is the average value of VP for the present category

		genvp[$vpcount]=$VPave #genVP is a general array where the average VP value for each category is stored
		
		#storing each single image VP value in $foldout/statistics/VP-detail.csv
		a=`echo ${arrayVP[@]} | tr " " ";" ` #adding semicolon to array so it can be stored in the csv file
		echo "$i;$a;$VPave" >>$vlist2 #writing values in newline in $vlist2
		
		vpcount=$((vpcount+1))
	done;
	
	echo "VP calculations finished for all categories with method 1" >>$readme
	echo "VP AVERAGE values are: ${genvp[@]}" >>$readme
	##read ok
	r.mask -r #removing mask
	#UPDATING $foldout2/deg_stats_$antype.csv
	#TODO: update table per column (or do it at the end of degradation.sh)
fi




#######################		FINISHED VP CALCULATION MODE 1 	###########################################################################################
		 	
#Calculation of VP TYPE 2. First VP for all images, than merging with MEDIAN
		
		
if [ "$VPtype" = "2" ]; then
	

	#obtain list of category values
	lsv=$(r.stats -n input=landscape) #list of all categories in landscape map	
	nlist=$(g.list type=rast pattern=ndvi*) #list of ndvi images	

	echo "this is the list of categories: $lsv
	and this is the list of images: $nlist"
	#	#read ok
	#cicle through categories
	vpcount=0 #counter for categories cicle
	for i in $lsv; do
	
	
		echo "
		***************************************************
		starting cycle 
		for VP calculations mode 2

		working on category $i
		*****************************************************" 
	
		#creating mask for the specific landscape category	
		r.mask --overwrite raster=landscape maskcats=$i

		#creating statistics file for VP	
		if [[ "$vpcount" -eq "0" ]]; then #if for creating folder for statistics
		
			vlist=$foldout2/deg_stats_$antype.csv #name of degradation stats file 
			echo "ls-code; land use; slope; aspect; VP value; Very degraded; Degraded; Semidegraded; Healthy; Vegetation Potential; Totalcellcount " >$vlist #creating stats file and column headers
		
			vlist2=$foldout2/VP-$antype-detail.csv #name of statistics file for detailed VP analysis
			a=`echo $nlist | tr " " "; " ` #list of images for column titles
			echo "category;$a; median" >$vlist2; #list of images for column titles
		fi

		

		#cicle to calculate VP for each image
		

		icount=0
		for g in $nlist; do #cicling through images
			echo "working on category $i and image $g"
			##read ok
			a=`r.univar -g -e map=$g separator=comma | rev | cut -d= -f1 | rev` #getting 90th quantile from single image
			VP=`echo $a | rev | cut -d" " -f1 | rev` #actual value of 90th quantile
							
			arrayVP[$icount]=$VP #array for storing single image VP VALUES
			icount=$((icount+1));
		done

		echo "icount is $icount vp values for category $i are:${arrayVP[@]}" 
		##read ok

		#calculation of VP for present category with MEDIAN
		total=0 #to avoid onboud variable	
		max=${arrayVP[0]} #variable for max value
		min=${arrayVP[0]} #variable for min value
		
		#foldout Loop for  finding min and max values
		for var in "${arrayVP[@]}";do
			if [[ "$var" -gt "$max" ]]; then #checks if new value is greater than max
				max=$var #update max
			fi
			
			if [[ "$var" -lt "$min" ]]; then #checks if min is the lower value
				min=$var #updates min value if needed
			fi
		done	#end of loop for finding max and min values
		
		VPave=$((((max-min)/2)+min))	 #this is the MEDIAN value of VP for the present category
		echo "max is $max, min is $min, Median is $VPave"
		##read ok
		genvp[$vpcount]=$VPave #genVP is a general array where the median VP value for each category is stored
		
		#storing each single image VP value in $foldout/statistics/VP-detail.csv
		a=`echo ${arrayVP[@]} | tr " " ";" ` #adding semicolon to array so it can be stored in the csv file
		echo "$i;$a;$VPave" >>$vlist2 #writing values in newline in $vlist2
		
		vpcount=$((vpcount+1))
	done;
	
	echo "${genvp[2]}"
	#read ok
	echo "
		VP calculations finished for all categories with method 2!" >>$readme
	echo "VP MEDIAN values are: ${genvp[@]}" >>$readme
	
	echo "${genvp[@]}" >/tmp/genvp.txt
	
	##read ok
	#UPDATING $foldout/statistics/deg_stats_$antype.csv
	#TODO: update table per column (or do it at the end of degradation.sh)
	r.mask -r #removing mask

fi


#################################END of vp CALCULATION WITH MODE 2 #########################################################################################


#Calculation of VP TYPE 3. First all images are combined with AVERAGE value, then VP is calculated

if [ "$VPtype" = "3" ]; then
	

	#obtain list of category values
	lsv=$(r.stats -n input=landscape) #list of all categories in landscape map	
	nlist=$(g.list type=rast pattern=ndvi* separator=space) #list of ndvi images	

	echo "this is the list of categories: $lsv
	and this is the list of images: $nlist"
	#	#read ok
	#cicle through categories
	vpcount=0 #counter for categories cicle
	
	#Merging all the maps in NDVI
	nlist2=`echo $nlist | tr " " ","`
	r.series --overwrite input=$nlist2 output=averagendvi method=average
	r.mapcalc "averagendvi = int(averagendvi)" --overwrite
	#getting quantile values from average-ndvi
	r.stats.quantile --overwrite base=averagendvi cover=landscape quantiles=10 bins=995 output=test1,test2,test3,test4,test5,test6,test7,test8,test9
	
	#loop to calculate vegetation potential for each category
	
	#obtain list of category values
	lsv=$(r.stats -n input=landscape) #list of all categories in landscape
	vpcount=0
	for i in $lsv; do
		
		echo "
		***************************************************
		starting cycle 
		for VP calculations mode 3

		working on category $i
		count is $vpcount
		*****************************************************" 
	
		#creating mask for the specific landscape category	
		r.mask --overwrite raster=landscape maskcats=$i
		
		#creating statistics file for VP	
		if [[ "$vpcount" -eq "0" ]]; then #if for creating folder for statistics
			echo "creating stats csv files"
						
			vlist=$foldout2/deg_stats_$antype.csv #name of degradation stats file 
			echo "ls-code; land use; slope; aspect; VP value; Very degraded; Degraded; Semidegraded; Healthy; Vegetation Potential; Totalcellcount " >$vlist #creating stats file and column headers
		
			vlist2=$foldout2/VP-$antype-detail.csv #name of statistics file for detailed VP analysis
			a=`echo $nlist | tr " " "; " ` #list of images for column titles
			echo "category; VPvalue" >$vlist2; #list of images for column titles
		fi



		a=`r.univar -g -e map=averagendvi separator=comma | rev | cut -d= -f1 | rev` #getting 90th quantile from single image
		VPave=`echo $a | rev | cut -d" " -f1 | rev` #actual value of 90th quantile

		
		genvp[$vpcount]=$VPave #genVP is a general array where the median VP value for each category is stored
	
		#updating $foldout/statistics/VP-mode3-detail.csv 
		echo "$i;$VPave" >>$vlist2
	vpcount=$((vpcount+1))	
	done

	#creating csv file for VP data	


	echo "VP calculations finished for all categories with method 3! " >>$readme
	echo "VP values from average NDVI are: ${genvp[@]} " >>$readme

	g.remove -f type=rast pattern=aver*
	
fi
	
