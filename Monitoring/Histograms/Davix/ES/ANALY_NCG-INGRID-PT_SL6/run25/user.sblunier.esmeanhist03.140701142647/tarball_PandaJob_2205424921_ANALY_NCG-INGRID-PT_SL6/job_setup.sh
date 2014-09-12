#!/bin/bash
# job_setup.sh 01 Jul 2014 12:47:00

export VO_ATLAS_SW_DIR=/cvmfs/atlas.cern.ch/repo/sw
if [ -f $VO_ATLAS_SW_DIR/local/setup.sh ]; then
  source $VO_ATLAS_SW_DIR/local/setup.sh
fi

export X509_USER_PROXY=/home/atlas/atlasplt024/home_cream_654625080/cream_654625080.proxy; lcg-gt --nobdii --setype srmv2 "srm://srm01.ncg.ingrid.pt:8444/srm/managerv2?SFN=/atlasscratchdisk/rucio/user/sblunier/f9/73/user.sblunier.0701122647.712745.lib._004324.lib.tgz" file

export FRONTIER_ID="[2205424921]";
export CMSSW_VERSION=$FRONTIER_ID;
export RUCIO_APPID="prun";
export RUCIO_ACCOUNT="pilot";
source /cvmfs/atlas.cern.ch/repo/sw/local/setup.sh;
export X509_USER_PROXY=/home/atlas/atlasplt024/home_cream_654625080/cream_654625080.proxy;
./runGen-00-00-02 -j "" --sourceURL https://aipanda011.cern.ch:25443 --rootVer 5.34.18-davix_p6a -p "./main.sh%20ANALY_NCG-INGRID-PT_SL6" -l user.sblunier.0701122647.712745.lib._004324.lib.tgz -o "{'ANALY_NCG-INGRID-PT_SL6.root': 'user.sblunier.004324._00001.ANALY_NCG-INGRID-PT_SL6.root'}" -r .  --lfcHost prod-lfc-atlas.cern.ch --inputGUIDs "[]" 1>prun_stdout.txt 2>prun_stderr.txt

