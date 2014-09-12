#!/bin/bash
# job_setup.sh 01 Jul 2014 15:23:02

export VO_ATLAS_SW_DIR=/cvmfs/atlas.cern.ch/repo/sw
if [ -f $VO_ATLAS_SW_DIR/local/setup.sh ]; then
  source $VO_ATLAS_SW_DIR/local/setup.sh
fi

export FRONTIER_ID="[2205419208]";
export CMSSW_VERSION=$FRONTIER_ID;
export RUCIO_APPID="prun";
export RUCIO_ACCOUNT="pilot";
source /cvmfs/atlas.cern.ch/repo/sw/local/setup.sh;
export X509_USER_PROXY=/home/atpilot011/home_cream_196062296/cream_196062296.proxy;
./runGen-00-00-02 -j "" --sourceURL https://aipanda011.cern.ch:25443 --rootVer 5.34.18-davix_p6a -p "./main.sh%20ANALY_PIC_SL6" -l user.sblunier.0701122250.856479.lib._004312.lib.tgz -o "{'ANALY_PIC_SL6.root': 'user.sblunier.004312._00001.ANALY_PIC_SL6.root'}" -r .  --lfcHost prod-lfc-atlas.cern.ch --inputGUIDs "[]" 1>prun_stdout.txt 2>prun_stderr.txt

