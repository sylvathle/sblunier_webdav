#!/bin/bash
# job_setup.sh 23 Jun 2014 21:38:15

export VO_ATLAS_SW_DIR=/cvmfs/atlas.cern.ch/repo/sw
if [ -f $VO_ATLAS_SW_DIR/local/setup.sh ]; then
  source $VO_ATLAS_SW_DIR/local/setup.sh
fi

export X509_USER_PROXY=/home/atlas/atlasplt024/home_cream_094533388/cream_094533388.proxy; lcg-gt --nobdii --setype srmv2 "srm://srm01.ncg.ingrid.pt:8444/srm/managerv2?SFN=/atlasscratchdisk/rucio/user/sblunier/62/b9/user.sblunier.0623144454.448580.lib._004078.lib.tgz" file

export FRONTIER_ID="[2199305932]";
export CMSSW_VERSION=$FRONTIER_ID;
export RUCIO_APPID="prun";
export RUCIO_ACCOUNT="pilot";
source /cvmfs/atlas.cern.ch/repo/sw/local/setup.sh;
export X509_USER_PROXY=/home/atlas/atlasplt024/home_cream_094533388/cream_094533388.proxy;
./runGen-00-00-02 -j "" --sourceURL https://aipanda012.cern.ch:25443 --rootVer 5.34.18-davix_p6a -p "./main.sh%20ANALY_NCG-INGRID-PT_SL6" -l user.sblunier.0623144454.448580.lib._004078.lib.tgz -o "{'ANALY_NCG-INGRID-PT_SL6.root': 'user.sblunier.004078._00001.ANALY_NCG-INGRID-PT_SL6.root'}" -r .  --lfcHost prod-lfc-atlas.cern.ch --inputGUIDs "[]" 1>prun_stdout.txt 2>prun_stderr.txt

