#!/bin/bash

cd ../Clouds
for cloud in $(ls)
do
	cd $cloud/
	pwd	
	rm listFilePerSite.txt
	while read site
	do
		python ../../GenerateGridReport/getFiles.py $site
	done < Datadisk.txt
	cd ..
done
cd ..
