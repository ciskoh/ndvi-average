#!/bin/bash
#set -o nounset
set +e
set -e

for x in /media/matt/MJR-gis/3-Spain/ls_analysis/input/model_variations/*.sh; do
	varpath=$x
	echo $varpath
#read ok

	. $varpath
echo "foldout is $foldout"
#read ok

	if [ "$imp" = "1" ]; then
		echo "removing all images"

		g.remove -f type=all pattern=*
		g.remove -f type=all pattern=*
		g.remove -f type=all pattern=*
		
	else
		echo "remove no images"

	fi		
	
	if [ "$shc" = "1" ]; then
		echo "removing landscape map"

		g.remove -f type=all pattern=l*,a*,s*
		g.remove -f type=all pattern=l*,a*,s*
		g.remove -f type=all pattern=l*,a*,s*
		
	else
		echo "remove no landscape map"

	fi	
	

	. /home/matt/Dropbox/github/average/avg-lms-an.sh

done
