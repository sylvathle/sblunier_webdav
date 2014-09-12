#!/bin/bash

# $1 = cloud
# $2 = numExperiment


var=$PWD

if [ "$1" == "all" ]
then
	find * -prune -type d | while read d;
	do
		echo $d
		cd $d
		#cd $var
		find * -prune -type d | while read d1;
		do
			echo $PWD
			cp $d1/$2/*.root $var/
		done
	done
else
	#cd $var
	cd $1
	find * -prune -type d | while read d1;
	do
		cp $var/$1/$d1/$2/*.root $var/
	done
fi
cd $var

