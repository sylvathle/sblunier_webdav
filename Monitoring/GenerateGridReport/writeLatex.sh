#!/bin/bash


here=$PWD
rootVersion=5.34.19-davix_p1-x86_64-slc6-gcc48-opt

export rootVersionVal=dynamic
export ATLAS_LOCAL_ROOT_BASE=/cvmfs/atlas.cern.ch/repo/ATLASLocalRootBase
source $ATLAS_LOCAL_ROOT_BASE/user/atlasLocalSetup.sh
source ${ATLAS_LOCAL_ROOT_BASE}/packageSetups/atlasLocalROOTSetup.sh --rootVersion ${rootVersionVal} --skipConfirm $rootVersion

proxy=$X509_USER_PROXY
proxy=${proxy#/tmp/}

cp /afs/cern.ch/user/s/sblunier/private/$proxy /tmp/

cp ../../Clouds/mjobIDs.txt beautifulsoup4-4.3.2/
cp ../../Clouds/tjobIDs.txt beautifulsoup4-4.3.2/
cp ../../Clouds/xjobIDs.txt beautifulsoup4-4.3.2/


./testFile.sh all
./fileRate.sh all
rm Report/jobStatus.tex
./getJobsStatus.sh nocache
./getJobsStatus.sh ttreecache
./getJobsStatus.sh xrootd

now=$(date +"%y%m%d_%R")
now_www=$(date +"%y_%m_%d")

cd Report
make clean
make
cp report.pdf Saved/$now.all.WebDAV_StatusGrid.pdf
latex2html report.tex
cd /afs/cern.ch/user/s/sblunier/www/webdavGridStatus
rm -rf $now_www
mkdir $now_www
cp $here/Report/report/* $now_www/
rm -rf ../www/today/*
cp $here/Report/report/* $now_www/
cp $here/Report/report/* /afs/cern.ch/user/s/sblunier/www/today/
cd ..
fs setacl . webserver:afs read
afind . webDirectoryRoot -t d -e "fs setacl -dir {} -acl webserver:afs read"
