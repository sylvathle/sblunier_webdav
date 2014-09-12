#!/bin/bash

# $1 = cloud
# $2 = numExperiment


var=$PWD

while read cloud
do
	for inode in $(find ./user.sblunier.*$cloud.*root* -maxdepth 1 -type d)
	do
		cd $var
		#echo $inode
		placeFile=$(find $inode/*.root -type f)
		nameFile=`expr match "$placeFile" '.*\(.*ANALY.*\)'`
		echo $inode
		nameLastFolder=`expr match "$inode" '.*\(xallgrid[0-9][0-9][0-9][0-9]\.\)'`
		nameLastFolder=${nameLastFolder%.}
		echo $nameLastFolder
		if [ "$nameFile" == "" ];
		then
			echo File does not exists
		else
			nameFolder=${nameFile%.root}
			#echo $nameFolder
			cd $var/$cloud/$nameFolder
			if [ ! -e $nameLastFolder ]; then
				mkdir $nameLastFolder
			fi
			cd $var
			logFolder=$(find ./user.sblunier.$nameLastFolder.$cloud.$nameFolder.log.* -maxdepth 1 -type d)
			cp $var/$logFolder/* $var/$cloud/$nameFolder/$nameLastFolder/
			cp $var/$placeFile $var/$cloud/$nameFolder/$nameLastFolder/$nameFile
		fi
	done
done < clouds.txt

cd $var
#rm -rf user.sblunier.*
