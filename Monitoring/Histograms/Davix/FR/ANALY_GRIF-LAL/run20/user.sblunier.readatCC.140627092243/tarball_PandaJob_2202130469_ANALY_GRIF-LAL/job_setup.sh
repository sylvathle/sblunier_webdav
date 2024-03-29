#!/bin/bash
# job_setup.sh 27 Jun 2014 07:36:22

export VO_ATLAS_SW_DIR=/cvmfs/atlas.cern.ch/repo/sw
if [ -f $VO_ATLAS_SW_DIR/local/setup.sh ]; then
  source $VO_ATLAS_SW_DIR/local/setup.sh
fi

export FRONTIER_ID="[2202130469]";
export CMSSW_VERSION=$FRONTIER_ID;
export RUCIO_APPID="prun";
export RUCIO_ACCOUNT="pilot";
source /cvmfs/atlas.cern.ch/repo/sw/local/setup.sh;
export X509_USER_PROXY=/grid_mnt/vohome/atlas/atlpilot000/home_cream_668076540/cream_668076540.proxy;
./runGen-00-00-02 -j "" --sourceURL https://aipanda012.cern.ch:25443 --rootVer 5.34.18-davix_p6a -p "./main.sh%20ANALY_GRIF-LAL" -l user.sblunier.0627072243.750015.lib._004114.lib.tgz -o "{'ANALY_GRIF-LAL.root': 'user.sblunier.004114._00001.ANALY_GRIF-LAL.root'}" -r .  --lfcHost prod-lfc-atlas.cern.ch --inputGUIDs "[]" 1>prun_stdout.txt 2>prun_stderr.txt

