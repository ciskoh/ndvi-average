#!/bin/bash
set -o nounset #checks the variables
set -e	#exits on error

##################################################################################3

#	Script to analyse data points after NDVI Variance analysis

######################################################################33333

#	Importing point file
v.in.ogr input=$fpsource output=fp type=points

