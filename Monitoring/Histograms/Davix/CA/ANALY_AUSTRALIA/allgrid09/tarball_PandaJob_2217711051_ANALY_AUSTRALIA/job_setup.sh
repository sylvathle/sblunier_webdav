#!/bin/bash
# job_setup.sh 15 Jul 2014 06:50:52

export VO_ATLAS_SW_DIR=/cvmfs/atlas.cern.ch/repo/sw
if [ -f $VO_ATLAS_SW_DIR/local/setup.sh ]; then
  source $VO_ATLAS_SW_DIR/local/setup.sh
fi

export FRONTIER_ID="[2217711051]";
export CMSSW_VERSION=$FRONTIER_ID;
export RUCIO_APPID="prun";
export RUCIO_ACCOUNT="pilot";
export X509_USER_PROXY=/home/pilatl17/home_cream_822811897/cream_822811897.proxy;
./runGen-00-00-02 -j "" --sourceURL https://aipanda011.cern.ch:25443 --rootVer 5.34.18-davix_p6a -p "./main.sh%20CA%20ANALY_AUSTRALIA" -l user.sblunier.0715064332.242797.lib._005723.lib.tgz -o "{'ANALY_AUSTRALIA.root': 'user.sblunier.005723._00001.ANALY_AUSTRALIA.root'}" -r .  --oldPrefix "srm://agh3.atlas.unimelb.edu.au(:8446/srm/managerv2?SFN=)*" --newPrefix rfio:// --lfcHost prod-lfc-atlas.cern.ch --inputGUIDs "[]" 1>prun_stdout.txt 2>prun_stderr.txt

