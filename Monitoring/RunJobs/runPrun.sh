#!/bin/bash

#cd fro acrontab
here=/afs/cern.ch/user/s/sblunier/private/davix/WebDAVMonitor/RunJobs
cd $here
export dq2ClientVersionVal=dynamic
export pandaClientVersionVal=dynamic
export ATLAS_LOCAL_ROOT_BASE=/cvmfs/atlas.cern.ch/repo/ATLASLocalRootBase
#echo $ATLAS_LOCAL_ROOT_BASE
source $ATLAS_LOCAL_ROOT_BASE/user/atlasLocalSetup.sh
localSetupPandaClient --noAthenaCheck
source ${ATLAS_LOCAL_ROOT_BASE}/packageSetups/atlasLocalPandaClientSetup.sh --pandaClientVersion ${pandaClientVersionVal} --noAthenaCheck
source ${ATLAS_LOCAL_ROOT_BASE}/packageSetups/atlasLocalDQ2ClientSetup.sh --dq2ClientVersion ${dq2ClientVersionVal} --skipConfirm


if [ "$1" == "" ]
then
   echo argument 1 cloud to test
   echo argument 2 for allgrid__number__
   echo argument 3 for ttreecache
   echo argument 4 for protocol 
   exit 1
fi

here=$PWD
if [[ "$3" == "ttreecache" ]]; then
	jobFolderEnd="tallgrid"$2
	jobIDs=tjobIDs.txt
else
	jobFolderEnd="mallgrid"$2
	jobIDs=mjobIDs.txt
fi

if [[ "$4" == "xrootd" ]]; then
	jobFolderEnd="xallgrid"$2
	jobIDs=xjobIDs.txt
fi

#jobFolderEnd="niark"$2

echo $jobFolderEnd >> lastJobVersion.txt
rootVersion="5.34.19-davix_p1"
rootConfig="x86_64-slc6-gcc48-opt"

cp $X509_USER_PROXY .
proxy=$X509_USER_PROXY
proxy=${proxy#/tmp/}

function prunCommand {
	echo user.sblunier.$jobFolderEnd.$1.$2
	echo prun --outDS user.sblunier.$jobFolderEnd.$1.$2 --rootVer=$rootVersion --cmtConfig=$rootConfig  --extFile=$proxy --outputs=$2.root --bexec "make" --exec "./main.sh $1 $2 $3 $4" --site="$2">>prun.txt
	prun --outDS user.sblunier.$jobFolderEnd.$1.$2 --rootVer=$rootVersion --cmtConfig=$rootConfig  --extFile=$proxy --outputs=$2.root --bexec "make" --exec "./main.sh $2 $3 $4" --site="$2"
}

firstjobID=-1
lastjobID=-1
jobID=0

echo $jobIDs

if [ "$1" == "all" ]
then
	shopt -s dotglob
	for d in `find ../Clouds/* -prune -type d`
	do 
		echo "******************************************************************************************"
		cloud=${d#../Clouds/}
		echo "$cloud"
		while read line
		do
			cp $d/Datadisk.txt .
			echo $line
			out=$(prunCommand $cloud $line $3 $4 2>&1)
			echo $out>>prun.txt
			echo $out
			jobID=`expr match "$out" '.*\([0-9].....[0-9]\)'`
			if [[ "$jobID" == "" ]];then
				continue
			fi
			echo $jobIDs
			echo $jobID>>$jobIDs
			#((jobID=jobID+1))
			if [[ $firstjobID -eq -1 ]]; then
				firstjobID=$jobID
			fi
			lastjobID=$jobID
		done < $d/Analy.txt
	done 
else
	while read line
	do
		echo $line
		out=$(prunCommand $1 ../Clouds/$line $3 $4 2>&1)
		echo $out>>prun.txt
		jobID=`expr match "$out" '.*\([0-9].....[0-9]\)'`
		echo $jobID
		#((jobID=jobID+1))
		if [[ $firstjobID -eq -1 ]]; then
			firstjobID=$jobID
		fi
		lastjobID=$jobID
	done < $1/Analy.txt
fi

echo $firstjobID
echo $lastjobID
echo $2 >> jobID.txt
echo $firstjobID>>jobID.txt
echo $lastjobID>>jobID.txt
rm $proxy
