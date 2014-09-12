#!/bin/bash
# job_setup.sh 20 Jun 2014 14:34:21

export VO_ATLAS_SW_DIR=/cvmfs/atlas.cern.ch/repo/sw
if [ -f $VO_ATLAS_SW_DIR/local/setup.sh ]; then
  source $VO_ATLAS_SW_DIR/local/setup.sh
fi

export X509_USER_PROXY=/mnt/data/scratch/lcg/pilatl08/home_cream_199066882/cream_199066882.proxy; lcg-gt --nobdii --setype srmv2 "srm://se03.esc.qmul.ac.uk:8444/srm/managerv2?SFN=/atlas/atlasscratchdisk/rucio/user/sblunier/1a/81/user.sblunier.0620142745.495851.lib._003978.lib.tgz" file

export FRONTIER_ID="[2197038828]";
export CMSSW_VERSION=$FRONTIER_ID;
export RUCIO_APPID="prun";
export RUCIO_ACCOUNT="pilot";
source /cvmfs/atlas.cern.ch/repo/sw/local/setup.sh;
export X509_USER_PROXY=/mnt/data/scratch/lcg/pilatl08/home_cream_199066882/cream_199066882.proxy;
./runGen-00-00-02 -j "" --sourceURL https://aipanda012.cern.ch:25443 --rootVer 5.34.18-davix_p6a -p "./main.sh%20ANALY_QMUL_SL6" -l user.sblunier.0620142745.495851.lib._003978.lib.tgz -o "{'ANALY_QMUL_SL6.root': 'user.sblunier.003978._00001.ANALY_QMUL_SL6.root'}" -r .  --lfcHost prod-lfc-atlas.cern.ch --inputGUIDs "[]" 1>prun_stdout.txt 2>prun_stderr.txt

