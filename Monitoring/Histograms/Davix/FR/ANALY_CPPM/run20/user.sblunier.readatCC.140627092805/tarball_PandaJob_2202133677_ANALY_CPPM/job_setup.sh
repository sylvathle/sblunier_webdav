#!/bin/bash
# job_setup.sh 27 Jun 2014 07:37:10

export VO_ATLAS_SW_DIR=/cvmfs/atlas.cern.ch/repo/sw/
if [ -f $VO_ATLAS_SW_DIR/local/setup.sh ]; then
  source $VO_ATLAS_SW_DIR/local/setup.sh
fi

export FRONTIER_ID="[2202133677]";
export CMSSW_VERSION=$FRONTIER_ID;
export RUCIO_APPID="prun";
export RUCIO_ACCOUNT="pilot";
source /cvmfs/atlas.cern.ch/repo/sw//local/setup.sh;
export X509_USER_PROXY=/home/atlpilot/home_cream_580949957/cream_580949957.proxy;
./runGen-00-00-02 -j "" --sourceURL https://aipanda012.cern.ch:25443 --rootVer 5.34.18-davix_p6a -p "./main.sh%20ANALY_CPPM" -l user.sblunier.0627072805.234779.lib._004134.lib.tgz -o "{'ANALY_CPPM.root': 'user.sblunier.004134._00001.ANALY_CPPM.root'}" -r .  --lfcHost prod-lfc-atlas.cern.ch --inputGUIDs "[]" 1>prun_stdout.txt 2>prun_stderr.txt

