#!/bin/bash

here=$PWD
echo $here

#get the proxy (this will work only if we generate it regularly)
cp /afs/cern.ch/user/s/sblunier/private/x509up_u68281 /tmp/

export ATLAS_LOCAL_ROOT_BASE=/cvmfs/atlas.cern.ch/repo/ATLASLocalRootBase
export dq2ClientVersionVal=dynamic
source $ATLAS_LOCAL_ROOT_BASE/user/atlasLocalSetup.sh
source ${ATLAS_LOCAL_ROOT_BASE}/packageSetups/atlasLocalDQ2ClientSetup.sh --dq2ClientVersion ${dq2ClientVersionVal} --skipConfirm


cp ../RunJobs/jobID.txt .

iterateur=0
xpPreviousNumber=0
xpPreviousPreviousNumber=0
while read line 
do
        if [[ $iterateur -eq 0 ]]; then
		xpPreviousPreviousNumber=$xpPreviousNumber
		xpPreviousNumber=$xpNumber
                xpNumber=$line
        elif [[ $iterateur -eq 1 ]]; then
		previousPreviousFirstJobID=$previousFirstJobID
		previousFirstJobID=$firstJobID
		firstJobID=$line
        elif [[ $iterateur -eq 2 ]]; then
		previousPreviousLastJobID=$previousLastJobID
		previousLastJobID=$lastJobID
		lastJobID=$line
        fi  
        ((iterateur=iterateur+1))
        if [[ $iterateur -eq 3 ]]; then
                iterateur=0
        fi  
done < jobID.txt

echo $xpNumber $firstJobID $lastJobID
echo $xpPreviousNumber $previousFirstJobID $previousLastJobID
echo $xpPreviousPreviousNumber $previousPreviousFirstJobID $previousPreviousLastJobID

localSetupDQ2Client --skipConfirm
cd ../Histograms/Davix
rm -rf user.sblunier*
dq2-get -t 15 user.sblunier.*mallgrid$xpNumber*root*/ && dq2-get -t 15 user.sblunier.*mallgrid$xpNumber*log*/ 
./getHist.sh
cd ../TDavix
rm -rf user.sblunier*
dq2-get -t 15 user.sblunier.*tallgrid$xpNumber*root*/ && dq2-get -t 15 user.sblunier.*tallgrid$xpNumber*log*/ 
./getHist.sh
cd ../xrootd
rm -rf user.sblunier*
dq2-get -t 15 user.sblunier.*xallgrid$xpNumber*root*/ && dq2-get -t 15 user.sblunier.*xallgrid$xpNumber*log*/ 
./getHist.sh
cd $here
./getFiles.sh
./getInfoSites.sh
