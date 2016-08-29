#!/bin/bash
#set -o nounset
#set +e
#set -e

#main counter

count=0

declare -x -a randarr=()
declare -a outlist
##Run lms


	varpath=/media/matt/MJR-gis/6-Creete/ls_analysis/input/stability.sh
	echo $varpath
#read ok

	. $varpath

foldorig=$foldout

foldout=$foldorig"/complete"
stab2=/media/matt/MJR-gis/6-Creete/ls_analysis/stab2  # second folder to store results

echo "foldout is $foldout"
read ok

 ###TEMPchanign script setting to avoid importing images

#imp=0
#shc=0
##END TEMP

#	. /home/matt/Dropbox/github/average/avg-lms-an.sh

## storing result of script
#g.rename raster=final_2,complete

#cp $foldout/results_2/final_2.tif $stab2/res_"$count"_img-complete.tif 

# starting process to eliminate images

nlist=($(g.list type=rast pattern=ndvi* separator=space)) #list of ndvi images as array
imgnum=${#nlist[@]}
echo "imgnum is $imgnum"

declare -a d=()
## defining how many number of images to delete based on total number of images
i=1
while [ "$i" -le "9" ]; do
	c=$(( i * 10 ))
	
	
	a=$( echo "($imgnum/100*$c)" | bc -l )
	b=${a%.*}             # d is the array with number of images to eliminate
	echo "a is $a"
   	d=( "${d[@]}" "$b" )
	echo "$i %"
	echo "${d[@]}"
	let i++
done
echo "${d[@]}"
read ok
# chanign script setting to avoid importing images

imp=0
shc=0

max=30  # max number of iterations
#general loop


# checking for excluded images
outlist=($(g.list type=raster pattern="out-*" separator=space))
echo "outlist is ${outlist[@]}"
read ok

for x in  ${outlist[@]}; 
do

	newname=${x:4:100}

	echo "oldname is $x, newname is $newname"
	#read ok
	g.rename raster=$x,$newname
done

outlist=($(g.list type=raster pattern="out-*" separator=space))
echo " images named out: ${outlist[@]}"
#read ok


#removing final images
fimg=$(g.list type=raster pattern=finalimg* separator=comma)
echo "this are the images to remove: $fimg"
#read ok
for count in "${d[@]}"; do
######TEMPORARY
	count=${d[8]}
######TEMPORARY
	echo " removing $count images"
	read ok
	unset randarr[@]
	bigc=1
	while [ "$bigc" -le "40" ]; do
		
		
		# checking for excluded images
		outlist=($(g.list type=raster pattern="out-*" separator=space))
		for x in "${outlist[@]}"; do
			newname=${x:4:100}

			echo "oldname is $x, newname is $newname"
			#read ok
			g.rename raster=$x,$newname
		done
		outlist=($(g.list type=raster pattern="out-*" separator=space))
		
		
		# restoring all images as "ndvi...."

			
		foldout=$foldorig/img_$count"run_"$bigc
		echo "count is $count, output folder is $foldout "
	
		echo " restarting cycle with $count images less and this is the $bigc th run"
		#read ok

		
		# loop to remove images for next analysis
		num=1
		rand2=23
		
#		
		
		while [ "$num" -le "$count" ]; do
			
			nlist=($(g.list type=rast pattern=ndvi* separator=space)) #list of ndvi images as array	
			imgnum=${#nlist[@]}
			a=$((imgnum-1))
			rand=$( shuf -i0-$a -n1 ) # random number
			#preventing same image to come around			
			if [ $count -eq 1 ];then			
				while [ ${randarr[@]} =~ "$rand" ]; do 
				 	echo "OOOOOOLLLLLLLDDDD" 
					rand=$( shuf -i0-$a -n1 ) # random number 
				done
			randarr+=($rand)
			fi
			
			echo "random number is $rand, total number of images is $imgnum, image selected is ${nlist[$rand]}"
			
			old=${nlist[$rand]} # image selected
			new="out-${nlist[$rand]}"  # new name of selcted image
			echo "renaming image $old to $new, tot number of images available is $imgnum"		
#			read ok
			g.rename raster=$old,$new     # renaming nvi images
			num=$((num+1))
		done
#		writing array to file

		outlist=($(g.list type=rast pattern=out* separator=space))

		echo "this are the $count images renamed: ${outlist[@]}"
		#read ok
	
		. /home/matt/Dropbox/github/average/avg-lms-an.sh
	
		#renaming final output for archive
		
		lastimg=finalimg"$count"run"$bigc"
		g.rename --overwrite raster=final_2,$lastimg
		

		cp $foldout/results_2/final_2.tif $stab2/img_"$count"_run-"$bigc".tif 
		## calculating Root Mean Square Error
		echo "calculating root mean square error"
		#read ok
		# difference between complete map and this map

		r.mapcalc "diff = $lastimg-complete" --overwrite
		r.univar -g --overwrite map=diff output=/tmp/diffstat.sh separator=newline #statistics for diff image
		
		. /tmp/diffstat.sh # statistics as variables

		
		RMSE=$(echo "sqrt($sum^2/$n)" | bc -l ) # root mean square error

		echo "sum of differences is $sum, number of pixels is $n, difference between maps in RMSE is $RMSE "
# 		read ok

		rmsear[$bigc]=$RMSE

		if [ "$bigc" -gt 2 ];then
		
	#		Standard error on RMSE (sum of RMSE over ) MINIMUM OF THREE RMSE

			# summing RMSE
			t=1
			sumprev=0
			while [ "$t" -lt "$bigc" ]; do
				thisval=${rmsear[$t]}
				sumprev=$(echo "scale=4;($sumprev + $thisval )" | bc -l ) # this is the sum of RMSE for previous images
				t=$((t+1))
			done

			# SEM without the last
			prevrun=$((bigc-1))
			prevSEM=$( echo "scale=4;($sumprev/sqrt($prevrun))" | bc -l )
			pasts=${rmsear[@]}
			echo "VALUES OF SEM WITHOUT THE LAST RUN:

			the RMSE are $pasts
			sum is $sumprev, n is $prevrun, SEM is $prevSEM"
#			read ok	
		
			#SEM with the last run
			tsum=$(echo "scale=4;($sumprev)+${rmsear[$bigc]}" | bc -l )
			tSEM=$( echo "scale=4;($tsum/sqrt($bigc))" | bc -l )     # new SEM

			echo "values of SEM with the last Run:
			sum is $tsum, n is $bigc, SEM is $tSEM"
#			read ok
		

			# differences in SEM
			dsem=$( echo "scale=4;($tSEM-$prevSEM)" | bc -l )
			reldsem=$( echo "scale=4;(($dsem/$prevSEM)*100)" | bc -l ) # difference in SEM compared to Last SEM
						
			if [ $(echo "scale=4; $reldsem < 0 " | bc -l) -eq 1 ]; then
				reldsem=$( echo "scale=4; (0-$reldsem)" | bc -l )
			
			fi
			
			echo "this is the difference between SEMs:

			previous SEM was $prevSEM; this SEM is $tSEM, difference is $dsem, which is $reldsem %"
#			read ok
		

			# testing if it make sense to do another run
			if [ $(echo "scale=4; $reldsem < 5 " | bc -l) -eq 1 ]; then
				bigc=40

				echo " NOT doing another run"
				#read ok
			else
				
				echo "I have to do another run!!!"
			fi		
		

		fi # end of Standard Error IF
	bigc=$((bigc+1))
	echo "${rmsear[@]}" >$stab2/imgsub-"$count".csv
	
		

	done # End of calculation with this set of images

count=$((count+1))	
	
	
	
	
done # end of calculations subtracting images

		

	

	

	
	


