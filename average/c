[1mdiff --git a/avg-VP.sh b/avg-VP.sh[m
[1mindex a16966d..6aeedb4 100644[m
[1m--- a/avg-VP.sh[m
[1m+++ b/avg-VP.sh[m
[36m@@ -10,10 +10,115 @@[m [mset -e	#exits on error[m
 # to launch use " bash /home/matt/Dropbox/github/average/avg-lms-an.sh"[m
 ###########################################################################[m
 [m
[31m-#Calculation of VP TYPE 1. First VP for all images, than merging with average[m
[32m+[m[32m#Calculation of VP TYPE 1. VP is MEAN+SD, Very degraded is VP-SD[m
[32m+[m
[32m+[m
 max=-100[m
 min=-100[m
 [m
[32m+[m[32mif [ "$VPtype" = "1" ]; then[m
[32m+[m[41m	[m
[32m+[m
[32m+[m	[32m#obtain list of category values[m
[32m+[m	[32mlsv=$(r.stats -n input=$landscape) 			# list of all categories in landscape map[m[41m	[m
[32m+[m	[32mnlist=$(g.list type=rast pattern=ndvi* separator=space) # list of ndvi images[m[41m	[m
[32m+[m
[32m+[m	[32mecho "this is the list of categories: $lsv[m
[32m+[m	[32mand this is the list of images: $nlist"[m
[32m+[m	[32m#	#read ok[m
[32m+[m	[32m#cicle through categories[m
[32m+[m[41m	[m
[32m+[m[41m	[m
[32m+[m	[32m#Merging all the maps in NDVI[m
[32m+[m	[32mnlist2=`echo $nlist | tr " " ","`[m
[32m+[m	[32mr.series --overwrite input=$nlist2 output=averagendvi method=average[m
[32m+[m	[32mr.mapcalc "averagendvi = int(averagendvi)" --overwrite[m
[32m+[m[41m		[m
[32m+[m	[32m#loop to calculate vegetation potential for each category[m
[32m+[m[41m	[m
[32m+[m	[32m#obtain list of category values[m
[32m+[m	[32mlsv=$(r.stats -n input=$landscape) #list of all categories in landscape[m
[32m+[m[41m	[m
[32m+[m	[32mvpcount=0[m
[32m+[m	[32mfor i in $lsv; do[m
[32m+[m[41m		[m
[32m+[m		[32mecho "[m
[32m+[m		[32m***************************************************[m
[32m+[m		[32mstarting cycle[m[41m [m
[32m+[m		[32mfor VP calculations mode 1 (SD method)[m
[32m+[m
[32m+[m		[32mworking on category $i[m
[32m+[m		[32mcount is $vpcount[m
[32m+[m		[32m*****************************************************"[m[41m [m
[32m+[m[41m	[m
[32m+[m		[32m#creating mask for the specific $landscape category[m[41m	[m
[32m+[m		[32mr.mask --overwrite raster=$landscape maskcats=$i[m
[32m+[m[41m		[m
[32m+[m		[32m#creating statistics file for VP[m[41m	[m
[32m+[m		[32mif [[ "$vpcount" -eq "0" ]]; then 		# if for creating folder for statistics[m
[32m+[m			[32mecho "creating stats csv files"[m
[32m+[m[41m						[m
[32m+[m			[32mvlist=$foldout2/deg_stats_$antype.csv 	# name of degradation stats file[m[41m [m
[32m+[m			[32mecho "ls-code; land use; slope; aspect; min; max; VP value; Very degraded; Degraded; Semidegraded; Healthy; Vegetation Potential; Totalcellcount " >$vlist #creating stats file and column headers[m
[32m+[m[41m		[m
[32m+[m			[32mvlist2=$foldout2/VP-$antype-detail.csv 					# name of statistics file for detailed VP analysis[m
[32m+[m			[32ma=`echo $nlist | tr " " "; " ` 						# list of images for column titles[m
[32m+[m			[32mecho "category; VPvalue" >$vlist2; 					# list of images for column titles[m
[32m+[m		[32mfi[m
[32m+[m
[32m+[m		[32ma=`r.univar -g -e map=averagendvi separator=comma | rev | cut -d= -f1 | rev`    #for min and max values[m
[32m+[m
[32m+[m[32m### New part to calculate with method 1 MEAN+SD[m
[32m+[m[41m		[m
[32m+[m		[32mb=`r.univar -g map=averagendvi`[m[41m 			[m
[32m+[m		[32m# getting 90th quantile from single image[m
[32m+[m[41m		[m
[32m+[m		[32meval "$b"[m
[32m+[m[41m		[m
[32m+[m		[32mmean=$(echo "($mean+0.5)/1" | bc)[m[41m [m
[32m+[m		[32mstddev=$(echo "($stddev+0.5)/1" | bc)[m[41m [m
[32m+[m[41m		[m
[32m+[m		[32mVPave=$(( mean + stddev ))[m[41m [m
[32m+[m
[32m+[m
[32m+[m		[32mecho "mean is $mean; stdev is $stddev, VP is $VPave"[m
[32m+[m		[32m# read ok[m[41m			[m
[32m+[m[41m		[m
[32m+[m		[32m# getting minimum value[m
[32m+[m[32m                min=`echo $a | cut -d" " -f4`       # getting new minimum value from current images[m
[32m+[m[41m		[m
[32m+[m		[32m# getting maximum value[m
[32m+[m		[32mmax=`echo $a | cut -d" " -f5`       # getting new minimum value from current images[m
[32m+[m[41m			[m
[32m+[m[41m		[m
[32m+[m		[32mgenvp[$vpcount]=$VPave		    # genVP is a general array where the median VP value for each category is stored[m
[32m+[m[41m		[m
[32m+[m		[32m# storing min and max values in arrays[m[41m               	[m
[32m+[m		[32marraymin[$vpcount]=$min[m
[32m+[m		[32marraymax[$vpcount]=$max[m[41m	[m
[32m+[m[41m		[m
[32m+[m		[32m#updating $foldout/statistics/VP-mode3-detail.csv[m[41m [m
[32m+[m		[32mecho "$i;$VPave" >>$vlist2[m
[32m+[m		[32mecho "Max is $max, Min $min and VP is $VPave"			# just verifying max and min[m
[32m+[m		[32m#read ok[m[41m	[m
[32m+[m
[32m+[m		[32mvpcount=$((vpcount+1))[m[41m	[m
[32m+[m	[32mdone[m
[32m+[m
[32m+[m	[32m#creating csv file for VP data[m[41m	[m
[32m+[m
[32m+[m
[32m+[m	[32mecho "VP calculations finished for all categories with method 3! " >>$readme[m
[32m+[m	[32mecho "VP values from average NDVI are: ${genvp[@]} " >>$readme[m
[32m+[m[41m	[m
[32m+[m	[32mg.remove -f type=rast pattern=test*[m
[32m+[m[41m	[m
[32m+[m[32mfi[m
[32m+[m[41m	[m
[32m+[m[32m#### END of calculation with method 1[m
[32m+[m
[32m+[m[32m########################################################################################################[m
[32m+[m
 #Calculation of VP TYPE 3. First all images are combined with AVERAGE value, then VP is calculated[m
 [m
 if [ "$VPtype" = "3" ]; then[m
[1mdiff --git a/avg-VP.sh~ b/avg-VP.sh~[m
[1mindex a8a8c8e..6aeedb4 100644[m
[1m--- a/avg-VP.sh~[m
[1m+++ b/avg-VP.sh~[m
[36m@@ -10,10 +10,115 @@[m [mset -e	#exits on error[m
 # to launch use " bash /home/matt/Dropbox/github/average/avg-lms-an.sh"[m
 ###########################################################################[m
 [m
[31m-#Calculation of VP TYPE 1. First VP for all images, than merging with average[m
[32m+[m[32m#Calculation of VP TYPE 1. VP is MEAN+SD, Very degraded is VP-SD[m
[32m+[m
[32m+[m
 max=-100[m
 min=-100[m
 [m
[32m+[m[32mif [ "$VPtype" = "1" ]; then[m
[32m+[m[41m	[m
[32m+[m
[32m+[m	[32m#obtain list of category values[m
[32m+[m	[32mlsv=$(r.stats -n input=$landscape) 			# list of all categories in landscape map[m[41m	[m
[32m+[m	[32mnlist=$(g.list type=rast pattern=ndvi* separator=space) # list of ndvi images[m[41m	[m
[32m+[m
[32m+[m	[32mecho "this is the list of categories: $lsv[m
[32m+[m	[32mand this is the list of images: $nlist"[m
[32m+[m	[32m#	#read ok[m
[32m+[m	[32m#cicle through categories[m
[32m+[m[41m	[m
[32m+[m[41m	[m
[32m+[m	[32m#Merging all the maps in NDVI[m
[32m+[m	[32mnlist2=`echo $nlist | tr " " ","`[m
[32m+[m	[32mr.series --overwrite input=$nlist2 output=averagendvi method=average[m
[32m+[m	[32mr.mapcalc "averagendvi = int(averagendvi)" --overwrite[m
[32m+[m[41m		[m
[32m+[m	[32m#loop to calculate vegetation potential for each category[m
[32m+[m[41m	[m
[32m+[m	[32m#obtain list of category values[m
[32m+[m	[32mlsv=$(r.stats -n input=$landscape) #list of all categories in landscape[m
[32m+[m[41m	[m
[32m+[m	[32mvpcount=0[m
[32m+[m	[32mfor i in $lsv; do[m
[32m+[m[41m		[m
[32m+[m		[32mecho "[m
[32m+[m		[32m***************************************************[m
[32m+[m		[32mstarting cycle[m[41m [m
[32m+[m		[32mfor VP calculations mode 1 (SD method)[m
[32m+[m
[32m+[m		[32mworking on category $i[m
[32m+[m		[32mcount is $vpcount[m
[32m+[m		[32m*****************************************************"[m[41m [m
[32m+[m[41m	[m
[32m+[m		[32m#creating mask for the specific $landscape category[m[41m	[m
[32m+[m		[32mr.mask --overwrite raster=$landscape maskcats=$i[m
[32m+[m[41m		[m
[32m+[m		[32m#creating statistics file for VP[m[41m	[m
[32m+[m		[32mif [[ "$vpcount" -eq "0" ]]; then 		# if for creating folder for statistics[m
[32m+[m			[32mecho "creating stats csv files"[m
[32m+[m[41m						[m
[32m+[m			[32mvlist=$foldout2/deg_stats_$antype.csv 	# name of degradation stats file[m[41m [m
[32m+[m			[32mecho "ls-code; land use; slope; aspect; min; max; VP value; Very degraded; Degraded; Semidegraded; Healthy; Vegetation Potential; Totalcellcount " >$vlist #creating stats file and column headers[m
[32m+[m[41m		[m
[32m+[m			[32mvlist2=$foldout2/VP-$antype-detail.csv 					# name of statistics file for detailed VP analysis[m
[32m+[m			[32ma=`echo $nlist | tr " " "; " ` 						# list of images for column titles[m
[32m+[m			[32mecho "category; VPvalue" >$vlist2; 					# list of images for column titles[m
[32m+[m		[32mfi[m
[32m+[m
[32m+[m		[32ma=`r.univar -g -e map=averagendvi separator=comma | rev | cut -d= -f1 | rev`    #for min and max values[m
[32m+[m
[32m+[m[32m### New part to calculate with method 1 MEAN+SD[m
[32m+[m[41m		[m
[32m+[m		[32mb=`r.univar -g map=averagendvi`[m[41m 			[m
[32m+[m		[32m# getting 90th quantile from single image[m
[32m+[m[41m		[m
[32m+[m		[32meval "$b"[m
[32m+[m[41m		[m
[32m+[m		[32mmean=$(echo "($mean+0.5)/1" | bc)[m[41m [m
[32m+[m		[32mstddev=$(echo "($stddev+0.5)/1" | bc)[m[41m [m
[32m+[m[41m		[m
[32m+[m		[32mVPave=$(( mean + stddev ))[m[41m [m
[32m+[m
[32m+[m
[32m+[m		[32mecho "mean is $mean; stdev is $stddev, VP is $VPave"[m
[32m+[m		[32m# read ok[m[41m			[m
[32m+[m[41m		[m
[32m+[m		[32m# getting minimum value[m
[32m+[m[32m                min=`echo $a | cut -d" " -f4`       # getting new minimum value from current images[m
[32m+[m[41m		[m
[32m+[m		[32m# getting maximum value[m
[32m+[m		[32mmax=`echo $a | cut -d" " -f5`       # getting new minimum value from current images[m
[32m+[m[41m			[m
[32m+[m[41m		[m
[32m+[m		[32mgenvp[$vpcount]=$VPave		    # genVP is a general array where the median VP value for each category is stored[m
[32m+[m[41m		[m
[32m+[m		[32m# storing min and max values in arrays[m[41m               	[m
[32m+[m		[32marraymin[$vpcount]=$min[m
[32m+[m		[32marraymax[$vpcount]=$max[m[41m	[m
[32m+[m[41m		[m
[32m+[m		[32m#updating $foldout/statistics/VP-mode3-detail.csv[m[41m [m
[32m+[m		[32mecho "$i;$VPave" >>$vlist2[m
[32m+[m		[32mecho "Max is $max, Min $min and VP is $VPave"			# just verifying max and min[m
[32m+[m		[32m#read ok[m[41m	[m
[32m+[m
[32m+[m		[32mvpcount=$((vpcount+1))[m[41m	[m
[32m+[m	[32mdone[m
[32m+[m
[32m+[m	[32m#creating csv file for VP data[m[41m	[m
[32m+[m
[32m+[m
[32m+[m	[32mecho "VP calculations finished for all categories with method 3! " >>$readme[m
[32m+[m	[32mecho "VP values from average NDVI are: ${genvp[@]} " >>$readme[m
[32m+[m[41m	[m
[32m+[m	[32mg.remove -f type=rast pattern=test*[m
[32m+[m[41m	[m
[32m+[m[32mfi[m
[32m+[m[41m	[m
[32m+[m[32m#### END of calculation with method 1[m
[32m+[m
[32m+[m[32m########################################################################################################[m
[32m+[m
 #Calculation of VP TYPE 3. First all images are combined with AVERAGE value, then VP is calculated[m
 [m
 if [ "$VPtype" = "3" ]; then[m
[36m@@ -87,7 +192,7 @@[m [mif [ "$VPtype" = "3" ]; then[m
 		#updating $foldout/statistics/VP-mode3-detail.csv [m
 		echo "$i;$VPave" >>$vlist2[m
 		echo "Max is $max, Min $min and VP is $VPave"			# just verifying max and min[m
[31m-		read ok	[m
[32m+[m		[32m#read ok[m[41m	[m
 [m
 		vpcount=$((vpcount+1))	[m
 	done[m
[1mdiff --git a/avg-deg.sh b/avg-deg.sh[m
[1mindex 60794e4..21135d4 100644[m
[1m--- a/avg-deg.sh[m
[1m+++ b/avg-deg.sh[m
[36m@@ -15,14 +15,13 @@[m [mg.remove -f type=rast pattern=fin*,deg*,temp*[m
 #made in March 2016 for Grass 7 by Matteo Jucker Riva matteo.jucker@cde.unibe.ch [m
 ###########################################################################[m
 [m
[31m-#Degradation evaluation mode 3: First images are merged with AVERAGE, then Degradation is calculated based on VP [m
[32m+[m[32m# Degradation evaluation mode 1: Classes are mean-SD, mean, mean+SD[m
 [m
 [m
 r.mask -r||true	[m
 [m
[31m-sermode=3		#for calc type[m
 		[m
[31m-if [ "$sermode" = "3" ]; then #if for detrmining which type of evaluation should be done[m
[32m+[m[32mif [ "$VPtype" = "1" ]; then #if for determining which type of evaluation should be done[m
 [m
 [m
 	#obtain list of categories and images[m
[36m@@ -38,6 +37,7 @@[m [mif [ "$sermode" = "3" ]; then #if for detrmining which type of evaluation should[m
 	#starting cyle for variance analysis[m
 	[m
 	dcount=0[m
[32m+[m	[32mecho "dcount is $dcount"[m
 	for a in $lsv; do	#cycle through landscape categories[m
 		[m
 				[m
[36m@@ -45,70 +45,180 @@[m [mif [ "$sermode" = "3" ]; then #if for detrmining which type of evaluation should[m
 		echo "[m
 		***************************************************[m
 		starting cycle [m
[31m-		for analysis of degradation with method 3[m
[32m+[m		[32mfor analysis of degradation with method 1 ( mean + SD )[m
 [m
 		working on category $a[m
 		*****************************************************" [m
 		r.mask --overwrite --verbose raster=$landscape maskcats=$a	#mask for present category[m
[31m-		x=`r.univar -g --quiet map=MASK`[m
[32m+[m			[32mx=`r.univar -g --quiet map=MASK`[m
 		echo " mask is $x[m
 [m
 all ok?"[m
[31m-#read ok[m
[32m+[m
[32m+[m[41m		[m
[32m+[m		[32m### New part to calculate with method 1 MEAN+SD[m
[32m+[m[41m		[m
 		VP=${genvp[$dcount]} 	 								# value of VP for present category[m
 		min=${arraymin[$dcount]} 								# value of min for present category[m
 		max=${arraymax[$dcount]}[m
  		[m
[32m+[m		[32m# Calculating boundaries of categories according to method 1[m
[32m+[m[41m		[m
[32m+[m		[32mb=`r.univar -g map=averagendvi`[m[41m 			[m
[32m+[m		[32m# getting 90th quantile from single image[m
[32m+[m[41m		[m
[32m+[m		[32meval "$b"[m
[32m+[m[41m		[m
[32m+[m		[32mmean=$(echo "($mean+0.5)/1" | bc)[m[41m [m
[32m+[m		[32mstddev=$(echo "($stddev+0.5)/1" | bc)[m[41m [m
[32m+[m[41m		[m
[32m+[m		[32mb1=$(( mean - stddev ))   # boundary 1 ( VD / Deg )[m
[32m+[m		[32mb2=$mean              # boundary 2 ( Deg / Healthy )[m
[32m+[m		[32mb3=$(( mean + stddev ))   # boundary 3 ( Healthy / VP )[m
[32m+[m[41m				[m
[32m+[m		[32mecho "min is $min, max is $max, VP is $VP, boundaries are $b1, $b2, $b3"[m
[32m+[m[41m		[m
[32m+[m[32m# writing rules to file /tmp/rules.txt[m
 [m
[31m-		#to check VP accuracy[m
[31m-		r.mapcalc --overwrite "tempVP = averagendvi>$VP" # getting part above VP[m
[31m-		r.null map=tempVP setnull=0          # deleting 0[m
[31m-		aVP=`r.univar -g map=tempVP | cut -d= -f2`[m
[31m-		set -- $aVP[m
[31m-		avp=$(echo $1)                         # cellcount of above VP[m
[31m-		bVP=`r.univar -g map=MASK | cut -d= -f2`[m
[31m-		set -- $bVP[m
[31m-		bvp=$(echo $1)                         # cellcount this category[m
[32m+[m[32mecho "$min thru $b1 = 1" >/tmp/rules.txt[m
[32m+[m[32mecho "$b1 thru $b2 = 2" >>/tmp/rules.txt[m
[32m+[m[32mecho "$b2 thru $b3 = 3" >>/tmp/rules.txt[m
[32m+[m[32mecho "$b3 thru $max = 4" >>/tmp/rules.txt[m
[32m+[m[41m		[m
[32m+[m[32m                echo "do map"[m[41m	[m
[32m+[m[41m		[m
[32m+[m		[32mr.reclass input=averagendvi output=deg.$a rules=/tmp/rules.txt[m
[32m+[m		[32mecho "map deg.$a is complete"[m
[32m+[m[41m		[m
[32m+[m		[32m#dividing final map for category according to degradation classes[m
[32m+[m		[32mr.mapcalc --overwrite file=- <<EOF[m
[32m+[m		[32mtempdeg1 = deg.$a=1[m
[32m+[m		[32mtempdeg2 = deg.$a=2[m[41m 	[m
[32m+[m		[32mtempdeg3 = deg.$a=3[m[41m 	[m
[32m+[m		[32mtempdeg4 = deg.$a=4[m[41m 		[m
[32m+[m		[32mtempdeg5 = deg.$a=5[m[41m 	[m
[32m+[m[32mEOF[m
 [m
[31m-		perc=$((bvp/avp))[m
[32m+[m		[32m#getting cell count for each category of degradation[m
[32m+[m		[32mc1=$(r.univar -g --quiet map=tempdeg1)	#get cell count for Very degraded[m
[32m+[m		[32mcc1=`echo $c1 | rev | cut -d= -f1 | rev`	#clean cell count string Very degraded[m
[32m+[m[41m		[m
[32m+[m		[32mc2=$(r.univar -g --quiet map=tempdeg2)	#get cell count for Degraded[m
[32m+[m		[32mcc2=`echo $c2 | rev | cut -d= -f1 | rev`	#clean cell count string Degraded[m
[32m+[m[41m		[m
[32m+[m		[32mc3=$(r.univar -g --quiet map=tempdeg3)	#get cell count for Semi degraded[m
[32m+[m		[32mcc3=`echo $c3 | rev | cut -d= -f1 | rev`	#clean cell count string Semi degraded[m
 [m
[31m-	[m
[32m+[m		[32mc4=$(r.univar -g --quiet map=tempdeg4)	#get cell count for healthy[m
[32m+[m		[32mcc4=`echo $c4 | rev | cut -d= -f1 | rev`	#clean cell count string healthy[m
[32m+[m
[32m+[m		[32mc5=$(r.univar -g --quiet map=tempdeg5)	#get cell count for PV[m
[32m+[m		[32mcc5=`echo $c5 | rev | cut -d= -f1 | rev`	#clean PV[m
 		[m
[31m-		echo "min is $min, max is $max, VP is $VP, avp is $avp, bvp is $bvp, perc is $perc"[m
[31m-		#read ok[m
 		[m
[32m+[m		[32mtot=$n	#clean cell count for the whole category[m
[32m+[m[41m		[m
[32m+[m		[32m#dividing category for stats file[m
[32m+[m		[32mlu=$((a/100))	#land use[m
[32m+[m		[32mslope=$(((a/10)-(lu*10)))	#slope[m
[32m+[m		[32maspect=$((a-(lu*100)-(slope*10)))	#aspects[m
[32m+[m[41m			[m
 				[m
[31m-		#reducing highest values at 90th quantile, cutting minimum value to higher minimum	[m
[31m-		r.mapcalc "temp.$a = float(if(averagendvi>$VP ,$VP ,averagendvi ))" --overwrite		# reducing hihgest values to VP[m
[31m-#		r.mapcalc "temp = float(if(temp2<$min, $min, temp2))" --overwrite			# reducing lowest values to higher min	[m
[32m+[m		[32mecho "$a;$lu;$slope;$aspect;$min;$max;$VP;$cc1;$cc2;$cc3;$cc4;$cc5;$tot" >>$vlist[m
[32m+[m[41m		[m
[32m+[m[41m		[m
[32m+[m		[32mr.mask -r||true[m
[32m+[m[41m		[m
[32m+[m		[32mdcount=$((dcount+1))[m
[32m+[m[41m		[m
[32m+[m[41m		[m
[32m+[m[41m		[m
[32m+[m	[32mdone[m
[32m+[m	[32mr.mask --overwrite raster=$landscape[m[41m	[m
[32m+[m[41m	[m
[32m+[m	[32m#merging final maps in one big final map[m
[32m+[m	[32mfinl=$(g.list type=rast pattern=deg.*)	#getting list of final images to merge[m
[32m+[m	[32mfinl=`echo $finl | tr " " ","` 	#cleaning list of final maps[m
[32m+[m	[32mecho "check finals map $finl"[m
[32m+[m	[32m#read ok[m
[32m+[m	[32mr.patch input=$finl output=final_$antype #actual merging of degradation maps for single categories[m
[32m+[m[41m	[m
[32m+[m[41m	[m
[32m+[m	[32m#exporting final map[m
[32m+[m[41m	[m
[32m+[m	[32mr.out.gdal input=final_$antype output=$foldout2/final_$antype".tif" format=GTiff[m
[32m+[m[41m		[m
[32m+[m	[32mg.remove -f type=rast pattern=deg.*,temp*[m
[32m+[m[41m		[m
[32m+[m[41m		[m
[32m+[m[32mfi[m
[32m+[m
[32m+[m[32m### END OF DEG CLASSIFICATION WITH METHOD 1[m
[32m+[m
[32m+[m
[32m+[m[32m# Degradation evaluation mode 3: First images are merged with AVERAGE, then Degradation is calculated based on VP[m[41m [m
[32m+[m
[32m+[m
[32m+[m[32mr.mask -r||true[m[41m	[m
 [m
[31m-		echo "check temp.$a"[m
[31m-		#read ok[m
[31m-		#rescaling image to VP[m
[31m-		r.rescale --overwrite input="temp.$a" output="deg.$a" to="0,100"[m
[31m-		[m
[31m-		#checking perc[m
[31m-		r.mapcalc --overwrite "tempVP2 = deg.$a>100" # getting part above VP[m
[31m-		r.null map=tempVP2 setnull=0          # deleting 0[m
[31m-		aVP2=`r.univar -g map=tempVP | cut -d= -f2`[m
[31m-		set -- $aVP2[m
[31m-		avp2=$(echo $1)                         # cellcount of above VP[m
[31m-		bVP2=`r.univar -g map=MASK | cut -d= -f2`[m
[31m-		set -- $bVP2[m
[31m-		bvp2=$(echo $1)                         # cellcount this category[m
[31m-[m
[31m-		perc2=$((bvp2/avp2))[m
[31m-		[m
[31m-		echo "image rescaled for category $a, perc is $perc2. Is it all ok?"[m
[31m-		#read ok[m
 		[m
[31m-#		#displaying map obtained[m
[31m-#		d.mon stop=wx0||true[m
[31m-#		d.mon start=wx0[m
[31m-#		d.rast MASK;d.rast deg.$a[m
[31m-		echo "image rescaled for category $a. check deg.$a!!"[m
[32m+[m[32mif [ "$VPtype" = "3" ]; then #if for detrmining which type of evaluation should be done[m
[32m+[m
[32m+[m
[32m+[m	[32m#obtain list of categories and images[m
[32m+[m	[32mlsv=$(r.stats -n input=$landscape) #list of all categories in landscape map[m[41m	[m
[32m+[m	[32mnlist=$(g.list type=rast pattern=ndvi* separator=space) #list of ndvi images[m[41m	[m
[32m+[m
[32m+[m
[32m+[m	[32m#merging of NDVI images with AVERAGE[m
[32m+[m[41m	[m
[32m+[m	[32mnlist2=`echo $nlist | tr " " ","`	#adding commas between list of NDVI images[m
[32m+[m	[32mr.series --overwrite input=$nlist2 output=averagendvi method=average	#Merging all the maps in NDVI[m
[32m+[m
[32m+[m	[32m#starting cyle for variance analysis[m
[32m+[m[41m	[m
[32m+[m	[32mdcount=0[m
[32m+[m	[32mecho "dcount is $dcount"[m
[32m+[m	[32mfor a in $lsv; do	#cycle through landscape categories[m
 		[m
[32m+[m[41m				[m
 		[m
[32m+[m		[32mecho "[m
[32m+[m		[32m***************************************************[m
[32m+[m		[32mstarting cycle[m[41m [m
[32m+[m		[32mfor analysis of degradation with method 3[m
[32m+[m
[32m+[m		[32mworking on category $a[m
[32m+[m		[32m*****************************************************"[m[41m [m
[32m+[m		[32mr.mask --overwrite --verbose raster=$landscape maskcats=$a	#mask for present category[m
[32m+[m		[32mx=`r.univar -g --quiet map=MASK`[m
[32m+[m		[32mecho " mask is $x[m
[32m+[m
[32m+[m[32mall ok?"[m
[32m+[m[32m#read ok[m
[32m+[m		[32mVP=${genvp[$dcount]}		# value of VP for present category[m
[32m+[m		[32mmin=${arraymin[$dcount]}	# value of min for present category[m
[32m+[m		[32mmax=${arraymax[$dcount]}[m
[32m+[m
[32m+[m		[32mVP=$(echo "($VP+0.5)/1" | bc)[m
[32m+[m
[32m+[m		[32mb1=$(echo "($VP*0.25)/1" | bc )    # boundary 1 ( VD / Deg )[m
[32m+[m		[32mb2=$(echo "($VP*0.5)/1" | bc)    # boundary 2 ( Deg / Semidegraded )[m
[32m+[m		[32mb3=$(echo "($b2 + $b1)/1" | bc)   # boundary 3 ( Semidegraded / Healthy )[m
[32m+[m[41m				[m
[32m+[m		[32mecho "min is $min, max is $max, VP is $VP, b3 is $b3"[m
[32m+[m		[32m#read ok[m
[32m+[m		[32mecho "$min thru $b1 = 1" >/tmp/rules.txt[m
[32m+[m		[32mecho "$b1 thru $b2 = 2" >>/tmp/rules.txt[m
[32m+[m		[32mecho "$b2 thru $b3 = 3" >>/tmp/rules.txt[m
[32m+[m		[32mecho "$b3 thru $VP = 4" >>/tmp/rules.txt[m
[32m+[m		[32mecho "$VP thru $max = 5" >>/tmp/rules.txt[m
[32m+[m
[32m+[m
[32m+[m		[32mr.reclass input=averagendvi output=deg.$a rules=/tmp/rules.txt[m
[32m+[m[41m				[m
[32m+[m		[32mecho "min is $min, max is $max, VP is $VP"[m
[32m+[m		[32m#read ok[m
 		[m
 [m
 [m
[1mdiff --git a/avg-deg.sh~ b/avg-deg.sh~[m
[1mindex 693ba1f..ce010ef 100644[m
[1m--- a/avg-deg.sh~[m
[1m+++ b/avg-deg.sh~[m
[36m@@ -15,14 +15,13 @@[m [mg.remove -f type=rast pattern=fin*,deg*,temp*[m
 #made in March 2016 for Grass 7 by Matteo Jucker Riva matteo.jucker@cde.unibe.ch [m
 ###########################################################################[m
 [m
[31m-#Degradation evaluation mode 3: First images are merged with AVERAGE, then Degradation is calculated based on VP [m
[32m+[m[32m# Degradation evaluation mode 1: Classes are mean-SD, mean, mean+SD[m
 [m
 [m
 r.mask -r||true	[m
 [m
[31m-sermode=3		#for calc type[m
 		[m
[31m-if [ "$sermode" = "3" ]; then #if for detrmining which type of evaluation should be done[m
[32m+[m[32mif [ "$VPtype" = "1" ]; then #if for determining which type of evaluation should be done[m
 [m
 [m
 	#obtain list of categories and images[m
[36m@@ -38,6 +37,7 @@[m [mif [ "$sermode" = "3" ]; then #if for detrmining which type of evaluation should[m
 	#starting cyle for variance analysis[m
 	[m
 	dcount=0[m
[32m+[m	[32mecho "dcount is $dcount"[m
 	for a in $lsv; do	#cycle through landscape categories[m
 		[m
 				[m
[36m@@ -45,70 +45,180 @@[m [mif [ "$sermode" = "3" ]; then #if for detrmining which type of evaluation should[m
 		echo "[m
 		***************************************************[m
 		starting cycle [m
[31m-		for analysis of degradation with method 3[m
[32m+[m		[32mfor analysis of degradation with method 1 ( mean + SD )[m
 [m
 		working on category $a[m
 		*****************************************************" [m
 		r.mask --overwrite --verbose raster=$landscape maskcats=$a	#mask for present category[m
[31m-		x=`r.univar -g --quiet map=MASK`[m
[32m+[m			[32mx=`r.univar -g --quiet map=MASK`[m
 		echo " mask is $x[m
 [m
 all ok?"[m
[31m-#read ok[m
[32m+[m
[32m+[m[41m		[m
[32m+[m		[32m### New part to calculate with method 1 MEAN+SD[m
[32m+[m[41m		[m
 		VP=${genvp[$dcount]} 	 								# value of VP for present category[m
 		min=${arraymin[$dcount]} 								# value of min for present category[m
 		max=${arraymax[$dcount]}[m
  		[m
[32m+[m		[32m# Calculating boundaries of categories according to method 1[m
[32m+[m[41m		[m
[32m+[m		[32mb=`r.univar -g map=averagendvi@avg-jul2016`[m[41m 			[m
[32m+[m		[32m# getting 90th quantile from single image[m
[32m+[m[41m		[m
[32m+[m		[32meval "$b"[m
[32m+[m[41m		[m
[32m+[m		[32mmean=$(echo "($mean+0.5)/1" | bc)[m[41m [m
[32m+[m		[32mstddev=$(echo "($stddev+0.5)/1" | bc)[m[41m [m
[32m+[m[41m		[m
[32m+[m		[32mb1=$(( mean - stddev ))   # boundary 1 ( VD / Deg )[m
[32m+[m		[32mb2=$mean              # boundary 2 ( Deg / Healthy )[m
[32m+[m		[32mb3=$(( mean + stddev ))   # boundary 3 ( Healthy / VP )[m
[32m+[m[41m				[m
[32m+[m		[32mecho "min is $min, max is $max, VP is $VP, boundaries are $b1, $b2, $b3"[m
[32m+[m[41m		[m
[32m+[m[32m# writing rules to file /tmp/rules.txt[m
 [m
[31m-		#to check VP accuracy[m
[31m-		r.mapcalc --overwrite "tempVP = averagendvi>$VP" # getting part above VP[m
[31m-		r.null map=tempVP setnull=0          # deleting 0[m
[31m-		aVP=`r.univar -g map=tempVP | cut -d= -f2`[m
[31m-		set -- $aVP[m
[31m-		avp=$(echo $1)                         # cellcount of above VP[m
[31m-		bVP=`r.univar -g map=MASK | cut -d= -f2`[m
[31m-		set -- $bVP[m
[31m-		bvp=$(echo $1)                         # cellcount this category[m
[32m+[m[32mecho "$min thru $b1 = 1" >/tmp/rules.txt[m
[32m+[m[32mecho "$b1 thru $b2 = 2" >>/tmp/rules.txt[m
[32m+[m[32mecho "$b2 thru $b3 = 3" >>/tmp/rules.txt[m
[32m+[m[32mecho "$b3 thru $max = 4" >>/tmp/rules.txt[m
[32m+[m[41m		[m
[32m+[m[32m                echo "do map"[m[41m	[m
[32m+[m[41m		[m
[32m+[m		[32mr.reclass input=averagendvi output=deg.$a rules=/tmp/rules.txt[m
[32m+[m		[32mecho "map deg.$a is complete"[m
[32m+[m[41m		[m
[32m+[m		[32m#dividing final map for category according to degradation classes[m
[32m+[m		[32mr.mapcalc --overwrite file=- <<EOF[m
[32m+[m		[32mtempdeg1 = deg.$a=1[m
[32m+[m		[32mtempdeg2 = deg.$a=2[m[41m 	[m
[32m+[m		[32mtempdeg3 = deg.$a=3[m[41m 	[m
[32m+[m		[32mtempdeg4 = deg.$a=4[m[41m 		[m
[32m+[m		[32mtempdeg5 = deg.$a=5[m[41m 	[m
[32m+[m[32mEOF[m
 [m
[31m-		perc=$((bvp/avp))[m
[32m+[m		[32m#getting cell count for each category of degradation[m
[32m+[m		[32mc1=$(r.univar -g --quiet map=tempdeg1)	#get cell count for Very degraded[m
[32m+[m		[32mcc1=`echo $c1 | rev | cut -d= -f1 | rev`	#clean cell count string Very degraded[m
[32m+[m[41m		[m
[32m+[m		[32mc2=$(r.univar -g --quiet map=tempdeg2)	#get cell count for Degraded[m
[32m+[m		[32mcc2=`echo $c2 | rev | cut -d= -f1 | rev`	#clean cell count string Degraded[m
[32m+[m[41m		[m
[32m+[m		[32mc3=$(r.univar -g --quiet map=tempdeg3)	#get cell count for Semi degraded[m
[32m+[m		[32mcc3=`echo $c3 | rev | cut -d= -f1 | rev`	#clean cell count string Semi degraded[m
 [m
[31m-	[m
[32m+[m		[32mc4=$(r.univar -g --quiet map=tempdeg4)	#get cell count for healthy[m
[32m+[m		[32mcc4=`echo $c4 | rev | cut -d= -f1 | rev`	#clean cell count string healthy[m
[32m+[m
[32m+[m		[32mc5=$(r.univar -g --quiet map=tempdeg5)	#get cell count for PV[m
[32m+[m		[32mcc5=`echo $c5 | rev | cut -d= -f1 | rev`	#clean PV[m
 		[m
[31m-		echo "min is $min, max is $max, VP is $VP, avp is $avp, bvp is $bvp, perc is $perc"[m
[31m-		#read ok[m
 		[m
[32m+[m		[32mtot=$n	#clean cell count for the whole category[m
[32m+[m[41m		[m
[32m+[m		[32m#dividing category for stats file[m
[32m+[m		[32mlu=$((a/100))	#land use[m
[32m+[m		[32mslope=$(((a/10)-(lu*10)))	#slope[m
[32m+[m		[32maspect=$((a-(lu*100)-(slope*10)))	#aspects[m
[32m+[m[41m			[m
 				[m
[31m-		#reducing highest values at 90th quantile, cutting minimum value to higher minimum	[m
[31m-		r.mapcalc "temp.$a = float(if(averagendvi>$VP ,$VP ,averagendvi ))" --overwrite		# reducing hihgest values to VP[m
[31m-#		r.mapcalc "temp = float(if(temp2<$min, $min, temp2))" --overwrite			# reducing lowest values to higher min	[m
[31m-[m
[31m-		echo "check temp.$a"[m
[31m-		#read ok[m
[31m-		#rescaling image to VP[m
[31m-		r.rescale --overwrite input="temp.$a" output="deg.$a" to="0,100"[m
[32m+[m		[32mecho "$a;$lu;$slope;$aspect;$min;$max;$VP;$cc1;$cc2;$cc3;$cc4;$cc5;$tot" >>$vlist[m
 		[m
[31m-		#checking perc[m
[31m-		r.mapcalc --overwrite "tempVP2 = deg.$a>100" # getting part above VP[m
[31m-		r.null map=tempVP2 setnull=0          # deleting 0[m
[31m-		aVP2=`r.univar -g map=tempVP | cut -d= -f2`[m
[31m-		set -- $aVP2[m
[31m-		avp2=$(echo $1)                         # cellcount of above VP[m
[31m-		bVP2=`r.univar -g map=MASK | cut -d= -f2`[m
[31m-		set -- $bVP2[m
[31m-		bvp2=$(echo $1)                         # cellcount this category[m
[31m-[m
[31m-		perc2=$((bvp2/avp2))[m
 		[m
[31m-		echo "image rescaled for category $a, perc is $perc2. Is it all ok?"[m
[31m-		read ok[m
[32m+[m		[32mr.mask -r||true[m
[32m+[m[41m		[m
[32m+[m		[32mdcount=$((dcount+1))[m
 		[m
[31m-#		#displaying map obtained[m
[31m-#		d.mon stop=wx0||true[m
[31m-#		d.mon start=wx0[m
[31m-#		d.rast MASK;d.rast deg.$a[m
[31m-		echo "image rescaled for category $a. check deg.$a!!"[m
 		[m
 		[m
[32m+[m	[32mdone[m
[32m+[m	[32mr.mask --overwrite raster=$landscape[m[41m	[m
[32m+[m[41m	[m
[32m+[m	[32m#merging final maps in one big final map[m
[32m+[m	[32mfinl=$(g.list type=rast pattern=deg.*)	#getting list of final images to merge[m
[32m+[m	[32mfinl=`echo $finl | tr " " ","` 	#cleaning list of final maps[m
[32m+[m	[32mecho "check finals map $finl"[m
[32m+[m	[32m#read ok[m
[32m+[m	[32mr.patch input=$finl output=final_$antype #actual merging of degradation maps for single categories[m
[32m+[m[41m	[m
[32m+[m[41m	[m
[32m+[m	[32m#exporting final map[m
[32m+[m[41m	[m
[32m+[m	[32mr.out.gdal input=final_$antype output=$foldout2/final_$antype".tif" format=GTiff[m
[32m+[m[41m		[m
[32m+[m	[32mg.remove -f type=rast pattern=deg.*,temp*[m
[32m+[m[41m		[m
[32m+[m[41m		[m
[32m+[m[32mfi[m
[32m+[m
[32m+[m[32m### END OF DEG CLASSIFICATION WITH METHOD 1[m
[32m+[m
[32m+[m
[32m+[m[32m# Degradation evaluation mode 3: First images are merged with AVERAGE, then Degradation is calculated based on VP[m[41m [m
[32m+[m
[32m+[m
[32m+[m[32mr.mask -r||true[m[41m	[m
[32m+[m
[32m+[m[41m		[m
[32m+[m[32mif [ "$VPtype" = "3" ]; then #if for detrmining which type of evaluation should be done[m
[32m+[m
[32m+[m
[32m+[m	[32m#obtain list of categories and images[m
[32m+[m	[32mlsv=$(r.stats -n input=$landscape) #list of all categories in landscape map[m[41m	[m
[32m+[m	[32mnlist=$(g.list type=rast pattern=ndvi* separator=space) #list of ndvi images[m[41m	[m
[32m+[m
[32m+[m
[32m+[m	[32m#merging of NDVI images with AVERAGE[m
[32m+[m[41m	[m
[32m+[m	[32mnlist2=`echo $nlist | tr " " ","`	#adding commas between list of NDVI images[m
[32m+[m	[32mr.series --overwrite input=$nlist2 output=averagendvi method=average	#Merging all the maps in NDVI[m
[32m+[m
[32m+[m	[32m#starting cyle for variance analysis[m
[32m+[m[41m	[m
[32m+[m	[32mdcount=0[m
[32m+[m	[32mecho "dcount is $dcount"[m
[32m+[m	[32mfor a in $lsv; do	#cycle through landscape categories[m
[32m+[m[41m		[m
[32m+[m[41m				[m
[32m+[m[41m		[m
[32m+[m		[32mecho "[m
[32m+[m		[32m***************************************************[m
[32m+[m		[32mstarting cycle[m[41m [m
[32m+[m		[32mfor analysis of degradation with method 3[m
[32m+[m
[32m+[m		[32mworking on category $a[m
[32m+[m		[32m*****************************************************"[m[41m [m
[32m+[m		[32mr.mask --overwrite --verbose raster=$landscape maskcats=$a	#mask for present category[m
[32m+[m		[32mx=`r.univar -g --quiet map=MASK`[m
[32m+[m		[32mecho " mask is $x[m
[32m+[m
[32m+[m[32mall ok?"[m
[32m+[m[32m#read ok[m
[32m+[m		[32mVP=${genvp[$dcount]}		# value of VP for present category[m
[32m+[m		[32mmin=${arraymin[$dcount]}	# value of min for present category[m
[32m+[m		[32mmax=${arraymax[$dcount]}[m
[32m+[m
[32m+[m		[32mVP=$(echo "($VP+0.5)/1" | bc)[m
[32m+[m
[32m+[m		[32mb1=$(echo "($VP*0.25)/1" | bc )    # boundary 1 ( VD / Deg )[m
[32m+[m		[32mb2=$(echo "($VP*0.5)/1" | bc)    # boundary 2 ( Deg / Semidegraded )[m
[32m+[m		[32mb3=$(echo "($b2 + $b1)/1" | bc)   # boundary 3 ( Semidegraded / Healthy )[m
[32m+[m[41m				[m
[32m+[m		[32mecho "min is $min, max is $max, VP is $VP, b3 is $b3"[m
[32m+[m		[32m#read ok[m
[32m+[m		[32mecho "$min thru $b1 = 1" >/tmp/rules.txt[m
[32m+[m		[32mecho "$b1 thru $b2 = 2" >>/tmp/rules.txt[m
[32m+[m		[32mecho "$b2 thru $b3 = 3" >>/tmp/rules.txt[m
[32m+[m		[32mecho "$b3 thru $VP = 4" >>/tmp/rules.txt[m
[32m+[m		[32mecho "$VP thru $max = 5" >>/tmp/rules.txt[m
[32m+[m
[32m+[m
[32m+[m		[32mr.reclass input=averagendvi output=deg.$a rules=/tmp/rules.txt[m
[32m+[m[41m				[m
[32m+[m		[32mecho "min is $min, max is $max, VP is $VP"[m
[32m+[m		[32m#read ok[m
 		[m
 [m
 [m
[1mdiff --git a/avg-lms-an.sh b/avg-lms-an.sh[m
[1mindex cc360c1..b9c987b 100644[m
[1m--- a/avg-lms-an.sh[m
[1m+++ b/avg-lms-an.sh[m
[36m@@ -64,7 +64,7 @@[m [mThe following settings where used:[m
 [m
 $sets[m
 [m
[31m-***************************">>$readme[m
[32m+[m[32m*************************** " >>$readme[m
 [m
 [m
 [m
[36m@@ -106,7 +106,7 @@[m [mif [ "$imp" -eq "1" ];[m
 	#read ok[m
 	. $sdir/avg-ndvi.sh;[m
 	else [m
[31m-	nlist2=`cat $foldout/statistics/ndvi_list2.txt`[m
[32m+[m	[32mnlist2=$(g.list type=rast pattern=ndvi* separator=space)[m
 	echo "I will not import the images, will use those instead: $nlist2"[m
 	##read ok;[m
 fi[m
[36m@@ -115,18 +115,6 @@[m [mecho "end of image classification"[m
 [m
 [m
 [m
[31m-#########classification of ndvi variance through variance.sh[m
[31m-#r.mask -r||true[m
[31m-[m
[31m-## for state map[m
[31m-#s=a0[m
[31m-#basemap=landscape_state[m
[31m-#mkdir -p $foldout/state[m
[31m-#foldout2=$foldout/state[m
[31m-[m
[31m-[m
[31m-[m
[31m-[m
 #STEP 4: QUANTILE CALCULATIONS[m
 [m
 [m
[36m@@ -143,7 +131,7 @@[m [mfor VP calculations WITH LANDFORMS[m
 [m
 ****[m
 *************************************************" [m
[31m-antype=$VPtype"_"$sermode[m
[32m+[m[32mantype=$VPtype[m
 mkdir -p $foldout/"results_"$antype  #creating folder for storing results[m
 [m
 foldout2=$foldout/"results_"$antype	#folder for results variable[m
[36m@@ -190,13 +178,13 @@[m [mfor VP calculations NO LANDFORMS[m
 [m
 ****[m
 *************************************************" [m
[31m-antype=$VPtype"_"$sermode"_NO_LF"[m
[32m+[m[32mantype=$VPtype"_NO_LF"[m
 [m
 mkdir -p $foldout/"results_"$antype  #creating folder for storing results[m
 [m
 foldout2=$foldout/"results_"$antype	#folder for results variable[m
 [m
[31m-r.mapcalc "landscapeNOLF = int((landscape-10)/100)"[m
[32m+[m[32mr.mapcalc --overwrite "landscapeNOLF = int((landscape-10)/100)"[m
 [m
 landscape=landscapeNOLF  #map to use NO landforms[m
 [m
[1mdiff --git a/avg-lms-an.sh~ b/avg-lms-an.sh~[m
[1mindex bf1ade9..3c0a64c 100644[m
[1m--- a/avg-lms-an.sh~[m
[1m+++ b/avg-lms-an.sh~[m
[36m@@ -64,7 +64,7 @@[m [mThe following settings where used:[m
 [m
 $sets[m
 [m
[31m-***************************">>$readme[m
[32m+[m[32m*************************** " >>$readme[m
 [m
 [m
 [m
[36m@@ -106,7 +106,7 @@[m [mif [ "$imp" -eq "1" ];[m
 	#read ok[m
 	. $sdir/avg-ndvi.sh;[m
 	else [m
[31m-	nlist2=`cat $foldout/statistics/ndvi_list2.txt`[m
[32m+[m	[32mnlist2=$(g.list type=rast pattern=ndvi* separator=space)[m
 	echo "I will not import the images, will use those instead: $nlist2"[m
 	##read ok;[m
 fi[m
[36m@@ -115,18 +115,6 @@[m [mecho "end of image classification"[m
 [m
 [m
 [m
[31m-#########classification of ndvi variance through variance.sh[m
[31m-#r.mask -r||true[m
[31m-[m
[31m-## for state map[m
[31m-#s=a0[m
[31m-#basemap=landscape_state[m
[31m-#mkdir -p $foldout/state[m
[31m-#foldout2=$foldout/state[m
[31m-[m
[31m-[m
[31m-[m
[31m-[m
 #STEP 4: QUANTILE CALCULATIONS[m
 [m
 [m
[36m@@ -143,7 +131,7 @@[m [mfor VP calculations WITH LANDFORMS[m
 [m
 ****[m
 *************************************************" [m
[31m-antype=$VPtype"_"$sermode[m
[32m+[m[32mantype=$VPtype[m
 mkdir -p $foldout/"results_"$antype  #creating folder for storing results[m
 [m
 foldout2=$foldout/"results_"$antype	#folder for results variable[m
[36m@@ -190,13 +178,13 @@[m [mfor VP calculations NO LANDFORMS[m
 [m
 ****[m
 *************************************************" [m
[31m-antype=$VPtype"_"$sermode"_NO_LF"[m
[32m+[m[32mantype=$VPtype"_NO_LF"[m
 [m
 mkdir -p $foldout/"results_"$antype  #creating folder for storing results[m
 [m
 foldout2=$foldout/"results_"$antype	#folder for results variable[m
 [m
[31m-r.mapcalc "landscapeNOLF = int((landscape-10)/100"[m
[32m+[m[32mr.mapcalc "landscapeNOLF = int((landscape-10)/100)"[m
 [m
 landscape=landscapeNOLF  #map to use NO landforms[m
 [m
[1mdiff --git a/avg-ls-cat.sh b/avg-ls-cat.sh[m
[1mindex 84dbcdb..aabce50 100644[m
[1m--- a/avg-ls-cat.sh[m
[1m+++ b/avg-ls-cat.sh[m
[36m@@ -21,10 +21,10 @@[m [mg.region res=10[m
 #Import DTM[m
 [m
 echo " Importing DTM"[m
[31m-r.in.gdal --overwrite input=$DTM output=DTM[m
[32m+[m[32mr.in.gdal --overwrite --quiet input=$DTM output=DTM[m
 [m
 echo " Importing land use"[m
[31m-v.in.ogr --overwrite dsn=$LU output=LU_vec snap=1e-08[m
[32m+[m[32mv.in.ogr --overwrite --quiet dsn=$LU output=LU_vec snap=1e-07[m
 [m
 #g.list type=rast,vect[m
 echo "verify imported files"[m
[1mdiff --git a/avg-ls-cat.sh~ b/avg-ls-cat.sh~[m
[1mindex e8c91ce..84dbcdb 100644[m
[1m--- a/avg-ls-cat.sh~[m
[1m+++ b/avg-ls-cat.sh~[m
[36m@@ -213,7 +213,7 @@[m [mecho "the landscape raster is ready, code is first land use, second slope, third[m
 ##read ok[m
 [m
 echo "check if landscape is ok"[m
[31m-read ok [m
[32m+[m[32m#read ok[m[41m [m
 [m
 g.remove type=rast name=landscape_big,landscape.neigh7,landscape.neigh5,landscape.neigh3,landscape.neigh1[m
 [m
[1mdiff --git a/avg-ndvi.sh b/avg-ndvi.sh[m
[1mindex 3a79eb4..d71470d 100644[m
[1m--- a/avg-ndvi.sh[m
[1m+++ b/avg-ndvi.sh[m
[36m@@ -1,7 +1,7 @@[m
 #!/bin/bash[m
[32m+[m
 set -o nounset[m
 set +e[m
[31m-r.mask -r[m
 set -e[m
 [m
 #Script that runs through a folder with landsat images, imports them in grass and calculates ndvi for each of them. Used as subscript of ndvi yearly analysis and modifications.[m
[36m@@ -12,7 +12,7 @@[m [mset -e[m
 [m
 # 1-IMPORTING IMAGES[m
 #set adequate resolution[m
[31m-[m
[32m+[m[32mr.mask -r[m
 [m
 count=0[m
 [m
[36m@@ -72,17 +72,11 @@[m [mdo[m
 [m
 " >>$readme[m
 	fi[m
[31m-	short=$year$month[m
[31m-[m
[31m-	echo "name=$short date=$ldate image=$name" >>$readme[m
[31m-	 [m
[31m-	echo "month is $month; check output file $readme"[m
[31m-	#read ok[m
[31m-[m
[31m-	short=$year$month[m
[32m+[m[41m	[m
[32m+[m	[32mzdate=${ldate//-}[m
[32m+[m	[32mshort=$zdate[m
[32m+[m[41m       [m
 [m
[31m-	#short=${name:9:7};[m
[31m-	#echo "short is $short";[m
 	echo "short is $short"[m
 	#read ok[m
 [m
[36m@@ -125,26 +119,55 @@[m [mdo[m
 	#read ok[m
 	#athmospheric correction[m
 [m
[31m-	i.landsat.toar input=$short"_B" output=$corr"." metfile=$meta 		sensor=oli8 method=dos2[m
[32m+[m	[32mi.landsat.toar input=$short"_B" output=$corr"." metfile=$meta 	sensor=oli8 method=dos2[m
[32m+[m
[32m+[m	[32m## 2b topographic correction[m
[32m+[m[41m	[m
[32m+[m	[32m# getting sun azimuth from metadata[m
[32m+[m	[32mazim=`sed -n '/SUN_AZIMUTH/p' $meta| cut -d "=" -f2`[m
[32m+[m[41m	[m
[32m+[m	[32maz=$(echo $azim + 0 | bc)[m
[32m+[m	[32mecho "azim is $az"[m
[32m+[m[41m	[m
[32m+[m	[32m# getting sun zenith from metadata[m
[32m+[m	[32mnadir=`sed -n '/SUN_ELEVATION/p' $meta| cut -d "=" -f2`[m
[32m+[m	[32mecho "nadir is $nadir"[m
 [m
[31m-	echo "check athmospheric corrected images"[m
[32m+[m	[32mzen=$(echo 90 - $nadir | bc)[m
[32m+[m[41m	[m
[32m+[m	[32mecho " azimuth is $az, nadir is $nadir and zenith is $zen"[m
 	#read ok[m
 [m
[31m-	#3-ndvi calculation[m
[32m+[m	[32m# creating illumination modelawk 'BEGIN { printf "%.2f\n", 10/6 }'[m
[32m+[m[41m	[m
[32m+[m	[32mi.topo.corr -i --overwrite output=illumination basemap=DTM zenith=$zen azimuth=$az[m
[32m+[m	[32mecho "i.topo.corr 2 done"[m
[32m+[m[41m	[m
[32m+[m	[32m# getting list of files to correct[m[41m	[m
[32m+[m	[32mclist=$(g.list type=rast pattern=$corr"."* separator=comma)[m
[32m+[m
[32m+[m[32m        # actual correction of band 4 and 5[m
[32m+[m[32m        i.topo.corr base=illumination input=$clist output=tcor zenith=$zen method=cosine[m
[32m+[m[41m	[m
[32m+[m	[32mtlist=$(g.list type=rast pattern="tcor*" separator=comma)[m
[32m+[m	[32mecho "check topographic corrected images $tlist"[m
[32m+[m	[32m#read ok[m
[32m+[m
[32m+[m	[32m## 3-ndvi calculation[m
 	#ndvi for corrected images[m
 [m
[31m-	b4=$corr".4"[m
[31m-	b5=$corr".5"[m
[32m+[m	[32mb4="tcor.$corr.4"[m
[32m+[m	[32mb5="tcor.$corr.5"[m
 [m
 	echo "this are the rasters for ndvi: $b4 and $b5"[m
[31m-	####read ok[m
[32m+[m	[32m#read ok[m
 [m
 [m
 	#NDVI calc-string for mapcalc[m
 [m
 	r.mapcalc "corr.$short =float($num*($b5-$b4)/($b5+$b4))" --overwrite[m
 		r.mapcalc "ndvi$short =int(corr.$short)" --overwrite	#multiplying to avoid problems  with floats in bash and grass[m
[31m-	echo "verify NDVI: corr$short"[m
[32m+[m	[32mecho "verify NDVI: ndvi$short"[m
 	#read ok[m
 	#exporting NDVI[m
 [m
[36m@@ -154,7 +177,7 @@[m [mdo[m
 [m
 [m
 [m
[31m-	[m
[32m+[m	[32mg.remove -f type=rast pattern="*cor*"[m
 [m
 	echo "cycle restarting"[m
 	####read ok[m
[36m@@ -169,7 +192,7 @@[m [mecho "cycle finished!!!!![m
 deleting useless raster...."[m
 [m
 g.remove -f type=rast pattern="$short" #deleting useless rasters[m
[31m-g.remove -f type=rast pattern=corr*[m
[32m+[m
 [m
 [m
 #obtain list of all ndvi maps[m
[1mdiff --git a/avg-ndvi.sh~ b/avg-ndvi.sh~[m
[1mindex 3ca6cb8..d71470d 100644[m
[1m--- a/avg-ndvi.sh~[m
[1m+++ b/avg-ndvi.sh~[m
[36m@@ -1,7 +1,7 @@[m
 #!/bin/bash[m
[32m+[m
 set -o nounset[m
 set +e[m
[31m-r.mask -r[m
 set -e[m
 [m
 #Script that runs through a folder with landsat images, imports them in grass and calculates ndvi for each of them. Used as subscript of ndvi yearly analysis and modifications.[m
[36m@@ -12,7 +12,7 @@[m [mset -e[m
 [m
 # 1-IMPORTING IMAGES[m
 #set adequate resolution[m
[31m-[m
[32m+[m[32mr.mask -r[m
 [m
 count=0[m
 [m
[36m@@ -72,17 +72,11 @@[m [mdo[m
 [m
 " >>$readme[m
 	fi[m
[31m-	short=$year$month[m
[31m-[m
[31m-	echo "name=$short date=$ldate image=$name" >>$readme[m
[31m-	 [m
[31m-	echo "month is $month; check output file $readme"[m
[31m-	#read ok[m
[31m-[m
[31m-	short=$year$month[m
[32m+[m[41m	[m
[32m+[m	[32mzdate=${ldate//-}[m
[32m+[m	[32mshort=$zdate[m
[32m+[m[41m       [m
 [m
[31m-	#short=${name:9:7};[m
[31m-	#echo "short is $short";[m
 	echo "short is $short"[m
 	#read ok[m
 [m
[36m@@ -125,26 +119,55 @@[m [mdo[m
 	#read ok[m
 	#athmospheric correction[m
 [m
[31m-	i.landsat.toar input=$short"_B" output=$corr"." metfile=$meta 		sensor=oli8 method=dos2[m
[32m+[m	[32mi.landsat.toar input=$short"_B" output=$corr"." metfile=$meta 	sensor=oli8 method=dos2[m
[32m+[m
[32m+[m	[32m## 2b topographic correction[m
[32m+[m[41m	[m
[32m+[m	[32m# getting sun azimuth from metadata[m
[32m+[m	[32mazim=`sed -n '/SUN_AZIMUTH/p' $meta| cut -d "=" -f2`[m
[32m+[m[41m	[m
[32m+[m	[32maz=$(echo $azim + 0 | bc)[m
[32m+[m	[32mecho "azim is $az"[m
[32m+[m[41m	[m
[32m+[m	[32m# getting sun zenith from metadata[m
[32m+[m	[32mnadir=`sed -n '/SUN_ELEVATION/p' $meta| cut -d "=" -f2`[m
[32m+[m	[32mecho "nadir is $nadir"[m
 [m
[31m-	echo "check athmospheric corrected images"[m
[32m+[m	[32mzen=$(echo 90 - $nadir | bc)[m
[32m+[m[41m	[m
[32m+[m	[32mecho " azimuth is $az, nadir is $nadir and zenith is $zen"[m
 	#read ok[m
 [m
[31m-	#3-ndvi calculation[m
[32m+[m	[32m# creating illumination modelawk 'BEGIN { printf "%.2f\n", 10/6 }'[m
[32m+[m[41m	[m
[32m+[m	[32mi.topo.corr -i --overwrite output=illumination basemap=DTM zenith=$zen azimuth=$az[m
[32m+[m	[32mecho "i.topo.corr 2 done"[m
[32m+[m[41m	[m
[32m+[m	[32m# getting list of files to correct[m[41m	[m
[32m+[m	[32mclist=$(g.list type=rast pattern=$corr"."* separator=comma)[m
[32m+[m
[32m+[m[32m        # actual correction of band 4 and 5[m
[32m+[m[32m        i.topo.corr base=illumination input=$clist output=tcor zenith=$zen method=cosine[m
[32m+[m[41m	[m
[32m+[m	[32mtlist=$(g.list type=rast pattern="tcor*" separator=comma)[m
[32m+[m	[32mecho "check topographic corrected images $tlist"[m
[32m+[m	[32m#read ok[m
[32m+[m
[32m+[m	[32m## 3-ndvi calculation[m
 	#ndvi for corrected images[m
 [m
[31m-	b4=$corr".4"[m
[31m-	b5=$corr".5"[m
[32m+[m	[32mb4="tcor.$corr.4"[m
[32m+[m	[32mb5="tcor.$corr.5"[m
 [m
 	echo "this are the rasters for ndvi: $b4 and $b5"[m
[31m-	####read ok[m
[32m+[m	[32m#read ok[m
 [m
 [m
 	#NDVI calc-string for mapcalc[m
 [m
 	r.mapcalc "corr.$short =float($num*($b5-$b4)/($b5+$b4))" --overwrite[m
 		r.mapcalc "ndvi$short =int(corr.$short)" --overwrite	#multiplying to avoid problems  with floats in bash and grass[m
[31m-	echo "verify NDVI: corr$short"[m
[32m+[m	[32mecho "verify NDVI: ndvi$short"[m
 	#read ok[m
 	#exporting NDVI[m
 [m
[36m@@ -154,7 +177,7 @@[m [mdo[m
 [m
 [m
 [m
[31m-	[m
[32m+[m	[32mg.remove -f type=rast pattern="*cor*"[m
 [m
 	echo "cycle restarting"[m
 	####read ok[m
[36m@@ -169,7 +192,7 @@[m [mecho "cycle finished!!!!![m
 deleting useless raster...."[m
 [m
 g.remove -f type=rast pattern="$short" #deleting useless rasters[m
[31m-g.remove -f type=rast pattern=corr*[m
[32m+[m
 [m
 [m
 #obtain list of all ndvi maps[m
[36m@@ -179,7 +202,6 @@[m [mg.list -m type=raster pattern=ndvi* >/$foldout/statistics/ndvi_list2.txt[m
 echo "check list at /$foldout/statistics/ndvi_list.txt"[m
 ####read ok[m
 [m
[31m-nlist=$(g.list type=rast pattern=ndvi*) #list of ndvi images	[m
 [m
 #end[m
 echo "all the images from $fold have been imported into grass[m
[1mdiff --git a/phenology_avg-ndvi.sh b/phenology_avg-ndvi.sh[m
[1mnew file mode 100644[m
[1mindex 0000000..157894b[m
[1m--- /dev/null[m
[1m+++ b/phenology_avg-ndvi.sh[m
[36m@@ -0,0 +1,228 @@[m
[32m+[m[32m#!/bin/bash[m
[32m+[m
[32m+[m[32mset -o nounset[m
[32m+[m[32mset +e[m
[32m+[m[32mset -e[m
[32m+[m
[32m+[m[32m#Script that runs through a folder with landsat images, imports them in grass and calculates ndvi for each of them. Used as subscript of ndvi yearly analysis and modifications.[m
[32m+[m[32m# OPTIMIZED FOR LONG TIME SERIES CALCULATION ON 11.06.2016[m
[32m+[m[32m#requires the following variables:[m[41m [m
[32m+[m[32m#fold=folder with satellite images foldout=output[m[41m [m
[32m+[m[32m#foldout=folder with /ndvi subfolder for export[m
[32m+[m
[32m+[m[32m# 1-IMPORTING IMAGES[m
[32m+[m[32m#set adequate resolution[m
[32m+[m[32mr.mask -r[m
[32m+[m
[32m+[m[32mcount=0[m
[32m+[m
[32m+[m[32mg.region res=30[m
[32m+[m[32mecho "here is the setting from the region:"[m
[32m+[m[32mg.region -p[m
[32m+[m
[32m+[m[32m#detect name os satellite image[m
[32m+[m
[32m+[m[32mfor i in $fold/*;[m
[32m+[m[32mdo[m
[32m+[m
[32m+[m	[32m #updating the counter[m
[32m+[m
[32m+[m
[32m+[m	[32mecho "[m
[32m+[m
[32m+[m
[32m+[m	[32mthis is the $count time I do the script.....[m
[32m+[m
[32m+[m
[32m+[m	[32m"[m
[32m+[m	[32m#identify month of picture[m
[32m+[m
[32m+[m	[32mecho "i is $i"[m
[32m+[m	[32mname=${i##*/}[m
[32m+[m	[32mecho "name is $name"[m
[32m+[m	[32m###read ok[m
[32m+[m	[32ment=$(sed -n '21p' $i/$name"_MTL.txt")[m
[32m+[m	[32ment="$(echo "${ent}" | tr -d '[[:space:]]')"[m
[32m+[m
[32m+[m	[32mldate="${ent##*=}"[m
[32m+[m	[32m#ldate2=$(echo -e "${ldate}" | sed -e 's/^[[:space:]]*//')[m
[32m+[m	[32mecho "ent is $ent date is $ldate"[m
[32m+[m	[32m##read ok[m
[32m+[m	[32myear=`echo $ldate |cut -d- -f1`[m
[32m+[m	[32mecho "year is $year"[m
[32m+[m	[32m#ent2=${ldate#*-}[m
[32m+[m	[32m#echo "ent2 is $ent2"[m
[32m+[m	[32mmonth=`echo $ldate | cut -d- -f2` #month numeric value[m
[32m+[m	[32msdate=$month[m
[32m+[m[41m	[m
[32m+[m	[32m###read ok[m
[32m+[m[41m	[m
[32m+[m		[32mecho "ent is $ent, year is $year,ldate is $ldate sdate is $sdate yoyoyo"[m
[32m+[m	[32m###read ok[m
[32m+[m[41m	[m
[32m+[m
[32m+[m	[32mif [ $count -eq "0" ]; then[m
[32m+[m[41m		[m
[32m+[m[41m	[m
[32m+[m		[32mecho "[m
[32m+[m
[32m+[m[32m****************************[m
[32m+[m[41m		[m
[32m+[m		[32mThe following images are considered for the analysis:[m
[32m+[m
[32m+[m[32m" >>$readme[m
[32m+[m	[32mfi[m
[32m+[m	[32m# short=$year$month # versione originale[m
[32m+[m
[32m+[m	[32m#PARTE EXTRA[m
[32m+[m	[32mzdate=${ldate//-}[m
[32m+[m	[32mshort=$zdate[m
[32m+[m[32m        ### fine parte extra[m
[32m+[m
[32m+[m	[32mecho "name=$short date=$ldate image=$name" >>$readme[m
[32m+[m[41m	 [m
[32m+[m	[32mecho "month is $month; check output file $readme"[m
[32m+[m	[32m##read ok[m
[32m+[m
[32m+[m	[32m# short=$year$month # versione originale[m
[32m+[m
[32m+[m	[32m#short=${name:9:7};[m
[32m+[m	[32m#echo "short is $short";[m
[32m+[m	[32mecho "short is $short"[m
[32m+[m	[32m#read ok[m
[32m+[m
[32m+[m	[32m#subloop to import all bands of the image[m
[32m+[m
[32m+[m	[32mfor b in $i/*; do[m
[32m+[m		[32mecho $b[m
[32m+[m		[32m##read ok[m
[32m+[m		[32mtemp=`echo $b | rev| cut -d/ -f1 |rev`[m
[32m+[m		[32mecho "temp is $temp"[m
[32m+[m		[32m##read ok[m
[32m+[m		[32mif [[ $temp = *.TIF ]];then[m
[32m+[m			[32mecho "$temp is a TIF"[m
[32m+[m			[32m##read ok[m
[32m+[m			[32mband=${b##*/}[m
[32m+[m			[32mecho $band[m
[32m+[m			[32m##read ok[m
[32m+[m			[32msband=${band:21:4}[m
[32m+[m			[32msband=${sband//./}[m
[32m+[m
[32m+[m			[32m#import bands for image[m[41m [m
[32m+[m
[32m+[m			[32mecho "importing band $sband"[m
[32m+[m			[32mr.in.gdal -o --overwrite input=$b output=$short$sband;[m
[32m+[m		[32mfi;[m
[32m+[m[41m	[m
[32m+[m	[32mdone[m[41m [m
[32m+[m
[32m+[m	[32mecho "check imported bands of image $name"[m
[32m+[m	[32m#####read ok[m
[32m+[m
[32m+[m	[32m# 2-ATHMOSPHERIC CORRECTION[m
[32m+[m
[32m+[m	[32m#name of metadata file[m
[32m+[m	[32mmeta=$i"/"$name"_MTL.txt"[m
[32m+[m[41m	[m
[32m+[m	[32m#name of corrected picture[m
[32m+[m	[32mcorr="corr_"$short[m
[32m+[m	[32mecho "meta is $meta; corr is $corr"[m
[32m+[m	[32m##read ok[m
[32m+[m	[32m#athmospheric correction[m
[32m+[m
[32m+[m	[32mi.landsat.toar input=$short"_B" output=$corr"." metfile=$meta 	sensor=oli8 method=dos2[m
[32m+[m
[32m+[m	[32m## 2b topographic correction[m
[32m+[m[41m	[m
[32m+[m	[32m# getting sun azimuth from metadata[m
[32m+[m	[32mazim=`sed -n '/SUN_AZIMUTH/p' $meta| cut -d "=" -f2`[m
[32m+[m[41m	[m
[32m+[m	[32maz=$(echo $azim + 0 | bc)[m
[32m+[m	[32mecho "azim is $az"[m
[32m+[m[41m	[m
[32m+[m	[32m# getting sun zenith from metadata[m
[32m+[m	[32mnadir=`sed -n '/SUN_ELEVATION/p' $meta| cut -d "=" -f2`[m
[32m+[m	[32mecho "nadir is $nadir"[m
[32m+[m
[32m+[m	[32mzen=$(echo 90 - $nadir | bc)[m
[32m+[m[41m	[m
[32m+[m	[32mecho " azimuth is $az, nadir is $nadir and zenith is $zen"[m
[32m+[m	[32m##read ok[m
[32m+[m
[32m+[m	[32m# creating illumination modelawk 'BEGIN { printf "%.2f\n", 10/6 }'[m
[32m+[m[41m	[m
[32m+[m	[32mi.topo.corr -i --overwrite output=illumination basemap=DTM zenith=$zen azimuth=$az[m
[32m+[m	[32mecho "i.topo.corr 2 done"[m
[32m+[m[41m	[m
[32m+[m	[32m# getting list of files to correct[m[41m	[m
[32m+[m	[32mclist=$(g.list type=rast pattern=$corr"."* separator=comma)[m
[32m+[m
[32m+[m[32m        # actual correction of band 4 and 5[m
[32m+[m[32m        i.topo.corr base=illumination input=$clist output=tcor zenith=$zen method=cosine[m
[32m+[m[41m	[m
[32m+[m	[32mtlist=$(g.list type=rast pattern="tcor*" separator=comma)[m
[32m+[m	[32mecho "check topographic corrected images $tlist"[m
[32m+[m	[32m##read ok[m
[32m+[m
[32m+[m	[32m## 3-ndvi calculation[m
[32m+[m	[32m#ndvi for corrected images[m
[32m+[m
[32m+[m	[32mb4="tcor.$corr.4"[m
[32m+[m	[32mb5="tcor.$corr.5"[m
[32m+[m
[32m+[m	[32mecho "this are the rasters for ndvi: $b4 and $b5"[m
[32m+[m	[32m##read ok[m
[32m+[m
[32m+[m
[32m+[m	[32m#NDVI calc-string for mapcalc[m
[32m+[m
[32m+[m	[32mr.mapcalc "corr.$short =float($num*($b5-$b4)/($b5+$b4))" --overwrite[m
[32m+[m		[32mr.mapcalc "ndvi$short =int(corr.$short)" --overwrite	#multiplying to avoid problems  with floats in bash and grass[m
[32m+[m	[32mecho "verify NDVI: ndvi$short"[m
[32m+[m	[32m#read ok[m
[32m+[m	[32m#exporting NDVI[m
[32m+[m
[32m+[m	[32mr.out.gdal -c -f input=ndvi$short type=Float64 output=$foldout/ndvi/ndvi_$short".tif"[m
[32m+[m
[32m+[m	[32mecho "check exported ndvi at $foldout/ndvi"[m
[32m+[m
[32m+[m
[32m+[m
[32m+[m	[32mg.remove -f type=rast pattern="*cor*"[m
[32m+[m
[32m+[m	[32mecho "cycle restarting"[m
[32m+[m	[32m#####read ok[m
[32m+[m[32mcount=$((count+1));[m
[32m+[m[32mdone[m
[32m+[m
[32m+[m[32m#deleting useless raster[m
[32m+[m[32mecho "cycle finished!!!!![m
[32m+[m
[32m+[m
[32m+[m
[32m+[m[32mdeleting useless raster...."[m
[32m+[m
[32m+[m[32mg.remove -f type=rast pattern="$short" #deleting useless rasters[m
[32m+[m
[32m+[m
[32m+[m
[32m+[m[32m#obtain list of all ndvi maps[m
[32m+[m[32mg.list -m type=raster pattern=ndvi* separator=comma >/$foldout/statistics/ndvi_list.txt[m
[32m+[m[32mg.list -m type=raster pattern=ndvi* >/$foldout/statistics/ndvi_list2.txt[m
[32m+[m
[32m+[m[32mecho "check list at /$foldout/statistics/ndvi_list.txt"[m
[32m+[m[32m#####read ok[m
[32m+[m
[32m+[m
[32m+[m[32m#end[m
[32m+[m[32mecho "all the images from $fold have been imported into grass[m
[32m+[m
[32m+[m[32m##################################################################[m
[32m+[m
[32m+[m[32mEND OF NDVI.SH[m
[32m+[m
[32m+[m[32mRETURNING TO LMS-AN.SH[m
[32m+[m
[32m+[m[32m#################################################################"[m
[32m+[m
[32m+[m
[1mdiff --git a/phenology_avg-ndvi.sh~ b/phenology_avg-ndvi.sh~[m
[1mnew file mode 100644[m
[1mindex 0000000..59795d3[m
[1m--- /dev/null[m
[1m+++ b/phenology_avg-ndvi.sh~[m
[36m@@ -0,0 +1,228 @@[m
[32m+[m[32m#!/bin/bash[m
[32m+[m
[32m+[m[32mset -o nounset[m
[32m+[m[32mset +e[m
[32m+[m[32mset -e[m
[32m+[m
[32m+[m[32m#Script that runs through a folder with landsat images, imports them in grass and calculates ndvi for each of them. Used as subscript of ndvi yearly analysis and modifications.[m
[32m+[m
[32m+[m[32m#requires the following variables:[m[41m [m
[32m+[m[32m#fold=folder with satellite images foldout=output[m[41m [m
[32m+[m[32m#foldout=folder with /ndvi subfolder for export[m
[32m+[m
[32m+[m[32m# 1-IMPORTING IMAGES[m
[32m+[m[32m#set adequate resolution[m
[32m+[m[32mr.mask -r[m
[32m+[m
[32m+[m[32mcount=0[m
[32m+[m
[32m+[m[32mg.region res=30[m
[32m+[m[32mecho "here is the setting from the region:"[m
[32m+[m[32mg.region -p[m
[32m+[m
[32m+[m[32m#detect name os satellite image[m
[32m+[m
[32m+[m[32mfor i in $fold/*;[m
[32m+[m[32mdo[m
[32m+[m
[32m+[m	[32m #updating the counter[m
[32m+[m
[32m+[m
[32m+[m	[32mecho "[m
[32m+[m
[32m+[m
[32m+[m	[32mthis is the $count time I do the script.....[m
[32m+[m
[32m+[m
[32m+[m	[32m"[m
[32m+[m	[32m#identify month of picture[m
[32m+[m
[32m+[m	[32mecho "i is $i"[m
[32m+[m	[32mname=${i##*/}[m
[32m+[m	[32mecho "name is $name"[m
[32m+[m	[32m###read ok[m
[32m+[m	[32ment=$(sed -n '21p' $i/$name"_MTL.txt")[m
[32m+[m	[32ment="$(echo "${ent}" | tr -d '[[:space:]]')"[m
[32m+[m
[32m+[m	[32mldate="${ent##*=}"[m
[32m+[m	[32m#ldate2=$(echo -e "${ldate}" | sed -e 's/^[[:space:]]*//')[m
[32m+[m	[32mecho "ent is $ent date is $ldate"[m
[32m+[m	[32m##read ok[m
[32m+[m	[32myear=`echo $ldate |cut -d- -f1`[m
[32m+[m	[32mecho "year is $year"[m
[32m+[m	[32m#ent2=${ldate#*-}[m
[32m+[m	[32m#echo "ent2 is $ent2"[m
[32m+[m	[32mmonth=`echo $ldate | cut -d- -f2` #month numeric value[m
[32m+[m	[32msdate=$month[m
[32m+[m[41m	[m
[32m+[m	[32m###read ok[m
[32m+[m[41m	[m
[32m+[m		[32mecho "ent is $ent, year is $year,ldate is $ldate sdate is $sdate yoyoyo"[m
[32m+[m	[32m###read ok[m
[32m+[m[41m	[m
[32m+[m
[32m+[m	[32mif [ $count -eq "0" ]; then[m
[32m+[m[41m		[m
[32m+[m[41m	[m
[32m+[m		[32mecho "[m
[32m+[m
[32m+[m[32m****************************[m
[32m+[m[41m		[m
[32m+[m		[32mThe following images are considered for the analysis:[m
[32m+[m
[32m+[m[32m" >>$readme[m
[32m+[m	[32mfi[m
[32m+[m	[32m# short=$year$month # versione originale[m
[32m+[m
[32m+[m	[32m#PARTE EXTRA[m
[32m+[m	[32mzdate=${ldate//-}[m
[32m+[m	[32mshort=$zdate[m
[32m+[m[32m        ### fine parte extra[m
[32m+[m
[32m+[m	[32mecho "name=$short date=$ldate image=$name" >>$readme[m
[32m+[m[41m	 [m
[32m+[m	[32mecho "month is $month; check output file $readme"[m
[32m+[m	[32m##read ok[m
[32m+[m
[32m+[m	[32m# short=$year$month # versione originale[m
[32m+[m
[32m+[m	[32m#short=${name:9:7};[m
[32m+[m	[32m#echo "short is $short";[m
[32m+[m	[32mecho "short is $short"[m
[32m+[m	[32m#read ok[m
[32m+[m
[32m+[m	[32m#subloop to import all bands of the image[m
[32m+[m
[32m+[m	[32mfor b in $i/*; do[m
[32m+[m		[32mecho $b[m
[32m+[m		[32m##read ok[m
[32m+[m		[32mtemp=`echo $b | rev| cut -d/ -f1 |rev`[m
[32m+[m		[32mecho "temp is $temp"[m
[32m+[m		[32m##read ok[m
[32m+[m		[32mif [[ $temp = *.TIF ]];then[m
[32m+[m			[32mecho "$temp is a TIF"[m
[32m+[m			[32m##read ok[m
[32m+[m			[32mband=${b##*/}[m
[32m+[m			[32mecho $band[m
[32m+[m			[32m##read ok[m
[32m+[m			[32msband=${band:21:4}[m
[32m+[m			[32msband=${sband//./}[m
[32m+[m
[32m+[m			[32m#import bands for image[m[41m [m
[32m+[m
[32m+[m			[32mecho "importing band $sband"[m
[32m+[m			[32mr.in.gdal -o --overwrite input=$b output=$short$sband;[m
[32m+[m		[32mfi;[m
[32m+[m[41m	[m
[32m+[m	[32mdone[m[41m [m
[32m+[m
[32m+[m	[32mecho "check imported bands of image $name"[m
[32m+[m	[32m#####read ok[m
[32m+[m
[32m+[m	[32m# 2-ATHMOSPHERIC CORRECTION[m
[32m+[m
[32m+[m	[32m#name of metadata file[m
[32m+[m	[32mmeta=$i"/"$name"_MTL.txt"[m
[32m+[m[41m	[m
[32m+[m	[32m#name of corrected picture[m
[32m+[m	[32mcorr="corr_"$short[m
[32m+[m	[32mecho "meta is $meta; corr is $corr"[m
[32m+[m	[32m##read ok[m
[32m+[m	[32m#athmospheric correction[m
[32m+[m
[32m+[m	[32mi.landsat.toar input=$short"_B" output=$corr"." metfile=$meta 	sensor=oli8 method=dos2[m
[32m+[m
[32m+[m	[32m## 2b topographic correction[m
[32m+[m[41m	[m
[32m+[m	[32m# getting sun azimuth from metadata[m
[32m+[m	[32mazim=`sed -n '/SUN_AZIMUTH/p' $meta| cut -d "=" -f2`[m
[32m+[m[41m	[m
[32m+[m	[32maz=$(echo $azim + 0 | bc)[m
[32m+[m	[32mecho "azim is $az"[m
[32m+[m[41m	[m
[32m+[m	[32m# getting sun zenith from metadata[m
[32m+[m	[32mnadir=`sed -n '/SUN_ELEVATION/p' $meta| cut -d "=" -f2`[m
[32m+[m	[32mecho "nadir is $nadir"[m
[32m+[m
[32m+[m	[32mzen=$(echo 90 - $nadir | bc)[m
[32m+[m[41m	[m
[32m+[m	[32mecho " azimuth is $az, nadir is $nadir and zenith is $zen"[m
[32m+[m	[32m##read ok[m
[32m+[m
[32m+[m	[32m# creating illumination modelawk 'BEGIN { printf "%.2f\n", 10/6 }'[m
[32m+[m[41m	[m
[32m+[m	[32mi.topo.corr -i --overwrite output=illumination basemap=DTM zenith=$zen azimuth=$az[m
[32m+[m	[32mecho "i.topo.corr 2 done"[m
[32m+[m[41m	[m
[32m+[m	[32m# getting list of files to correct[m[41m	[m
[32m+[m	[32mclist=$(g.list type=rast pattern=$corr"."* separator=comma)[m
[32m+[m
[32m+[m[32m        # actual correction of band 4 and 5[m
[32m+[m[32m        i.topo.corr base=illumination input=$clist output=tcor zenith=$zen method=cosine[m
[32m+[m[41m	[m
[32m+[m	[32mtlist=$(g.list type=rast pattern="tcor*" separator=comma)[m
[32m+[m	[32mecho "check topographic corrected images $tlist"[m
[32m+[m	[32m##read ok[m
[32m+[m
[32m+[m	[32m## 3-ndvi calculation[m
[32m+[m	[32m#ndvi for corrected images[m
[32m+[m
[32m+[m	[32mb4="tcor.$corr.4"[m
[32m+[m	[32mb5="tcor.$corr.5"[m
[32m+[m
[32m+[m	[32mecho "this are the rasters for ndvi: $b4 and $b5"[m
[32m+[m	[32m##read ok[m
[32m+[m
[32m+[m
[32m+[m	[32m#NDVI calc-string for mapcalc[m
[32m+[m
[32m+[m	[32mr.mapcalc "corr.$short =float($num*($b5-$b4)/($b5+$b4))" --overwrite[m
[32m+[m		[32mr.mapcalc "ndvi$short =int(corr.$short)" --overwrite	#multiplying to avoid problems  with floats in bash and grass[m
[32m+[m	[32mecho "verify NDVI: ndvi$short"[m
[32m+[m	[32m#read ok[m
[32m+[m	[32m#exporting NDVI[m
[32m+[m
[32m+[m	[32mr.out.gdal -c -f input=ndvi$short type=Float64 output=$foldout/ndvi/ndvi_$short".tif"[m
[32m+[m
[32m+[m	[32mecho "check exported ndvi at $foldout/ndvi"[m
[32m+[m
[32m+[m
[32m+[m
[32m+[m	[32mg.remove -f type=rast pattern="*cor*"[m
[32m+[m
[32m+[m	[32mecho "cycle restarting"[m
[32m+[m	[32m#####read ok[m
[32m+[m[32mcount=$((count+1));[m
[32m+[m[32mdone[m
[32m+[m
[32m+[m[32m#deleting useless raster[m
[32m+[m[32mecho "cycle finished!!!!![m
[32m+[m
[32m+[m
[32m+[m
[32m+[m[32mdeleting useless raster...."[m
[32m+[m
[32m+[m[32mg.remove -f type=rast pattern="$short" #deleting useless rasters[m
[32m+[m
[32m+[m
[32m+[m
[32m+[m[32m#obtain list of all ndvi maps[m
[32m+[m[32mg.list -m type=raster pattern=ndvi* separator=comma >/$foldout/statistics/ndvi_list.txt[m
[32m+[m[32mg.list -m type=raster pattern=ndvi* >/$foldout/statistics/ndvi_list2.txt[m
[32m+[m
[32m+[m[32mecho "check list at /$foldout/statistics/ndvi_list.txt"[m
[32m+[m[32m#####read ok[m
[32m+[m
[32m+[m
[32m+[m[32m#end[m
[32m+[m[32mecho "all the images from $fold have been imported into grass[m
[32m+[m
[32m+[m[32m##################################################################[m
[32m+[m
[32m+[m[32mEND OF NDVI.SH[m
[32m+[m
[32m+[m[32mRETURNING TO LMS-AN.SH[m
[32m+[m
[32m+[m[32m#################################################################"[m
[32m+[m
[32m+[m
