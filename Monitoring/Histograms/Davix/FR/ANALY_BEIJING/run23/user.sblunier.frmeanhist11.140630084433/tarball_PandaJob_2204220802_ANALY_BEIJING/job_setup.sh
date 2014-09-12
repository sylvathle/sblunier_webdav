#!/bin/bash
# job_setup.sh 30 Jun 2014 07:39:15

export VO_ATLAS_SW_DIR=/cvmfs/atlas.cern.ch/repo/sw
if [ -f $VO_ATLAS_SW_DIR/local/setup.sh ]; then
  source $VO_ATLAS_SW_DIR/local/setup.sh
fi

export FRONTIER_ID="[2204220802]";
export CMSSW_VERSION=$FRONTIER_ID;
export RUCIO_APPID="prun";
export RUCIO_ACCOUNT="pilot";
source /cvmfs/atlas.cern.ch/repo/sw/local/setup.sh;
export X509_USER_PROXY=/home/pilat303/home_cream_260770204/cream_260770204.proxy;
./runGen-00-00-02 -j "" --sourceURL https://aipanda012.cern.ch:25443 --rootVer 5.34.18-davix_p6a -p "./main.sh%20ANALY_BEIJING" -l user.sblunier.0630064433.324188.lib._004192.lib.tgz -o "{'ANALY_BEIJING.root': 'user.sblunier.004192._00001.ANALY_BEIJING.root'}" -r .  --lfcHost prod-lfc-atlas.cern.ch --inputGUIDs "[]" 1>prun_stdout.txt 2>prun_stderr.txt

