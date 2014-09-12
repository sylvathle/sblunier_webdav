#!/bin/bash
# job_setup.sh 23 Jun 2014 13:52:50

export VO_ATLAS_SW_DIR=/cvmfs/atlas.cern.ch/repo/sw
if [ -f $VO_ATLAS_SW_DIR/local/setup.sh ]; then
  source $VO_ATLAS_SW_DIR/local/setup.sh
fi

export FRONTIER_ID="[2199268681]";
export CMSSW_VERSION=$FRONTIER_ID;
export RUCIO_APPID="prun";
export RUCIO_ACCOUNT="pilot";
source /cvmfs/atlas.cern.ch/repo/sw/local/setup.sh;
export X509_USER_PROXY=/home/atpilot011/home_cream_183562606/cream_183562606.proxy;
./runGen-00-00-02 -j "" --sourceURL https://aipanda011.cern.ch:25443 --rootVer 5.34.18-davix_p6a -p "./main.sh%20ANALY_IFAE" -l user.sblunier.0623134700.197121.lib._004026.lib.tgz -o "{'ANALY_IFAE.root': 'user.sblunier.004026._00001.ANALY_IFAE.root'}" -r .  --lfcHost prod-lfc-atlas.cern.ch --inputGUIDs "[]" 1>prun_stdout.txt 2>prun_stderr.txt

