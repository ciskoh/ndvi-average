#!/bin/bash
set -o nounset
set +e
r.mask -r||true
set -e



# initialise time series stack
t.create --overwrite output=ndvi.time semantictype=mean title="ndvi landsat8 " description="ndvi landsat8 "

# include maps in time series stack

# create time series with date 
ndlist=$(g.list type=raster pattern=ndvi* separator=newline)
count=0

for i in $ndlist ; do
	echo "starting loop"
	a=`echo $i | cut -c5-12`
	echo $a
	year=`echo $a | cut -c1-4`
	echo $year
	month=`echo $a | cut -c5-6`
	echo $month
	day=`echo $a | cut -c7-8`
	echo $day

	str[$count]=$i" | "$year"-"$month"-"$day

	echo 

	echo $str[$count]
	#read ok

	count=$((count + 1))	
done

( IFS=$'\n'; echo "${str[*]}" ) >/tmp/list.txt # writing date to files

#registering maps in dataset
t.register input=ndvi.time file=/tmp/list.txt



