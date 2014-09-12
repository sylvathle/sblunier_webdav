#!/bin/bash

here=$PWD
proxy=$X509_USER_PROXY
proxy=${proxy#/tmp/}
cp /afs/cern.ch/user/s/sblunier/private/x509up_u68281 /tmp/

rm Datadisk.txt
rm listFilePerSite.txt
rm mjobIDs.txt tjobIDs.txt xjobIDs.txt
rm *.root

iterateur=0
while read line 
do
        if [[ $iterateur -eq 0 ]]; then
                newXp=$line
        elif [[ $iterateur -eq 1 ]]; then
                firstJobID=$line
        elif [[ $iterateur -eq 2 ]]; then
                lastJobID=$line
        fi  
        ((iterateur=iterateur+1))
        if [[ $iterateur -eq 3 ]]; then
                iterateur=0
        fi  
done < jobID.txt

((newXp=newXp+1))
./runPrun.sh all $newXp "nocache" "davix"
./runPrun.sh all $newXp "ttreecache" "davix"
./runPrun.sh all $newXp "ttreecache" "xrootd"
