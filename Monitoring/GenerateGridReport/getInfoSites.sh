#!/bin/bash

rm infoSites.txt
for cloud in $(ls ../Clouds)
do
	#cloud="CA"
	while read site
	do
		echo $site
		python infoSites.py $site
	done < ../Clouds/$cloud/Datadisk.txt
done
