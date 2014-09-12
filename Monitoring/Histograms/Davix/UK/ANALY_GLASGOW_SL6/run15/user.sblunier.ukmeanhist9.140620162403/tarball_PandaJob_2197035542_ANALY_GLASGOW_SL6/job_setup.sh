#!/bin/bash
# job_setup.sh 20 Jun 2014 14:30:24

export VO_ATLAS_SW_DIR=/cvmfs/atlas.cern.ch/repo/sw
if [ -f $VO_ATLAS_SW_DIR/local/setup.sh ]; then
  source $VO_ATLAS_SW_DIR/local/setup.sh
fi

export FRONTIER_ID="[2197035542]";
export CMSSW_VERSION=$FRONTIER_ID;
export RUCIO_APPID="prun";
export RUCIO_ACCOUNT="pilot";
export X509_USER_PROXY=/home/pilatlas023/home_crm10_081779801/crm10_081779801.proxy;
./runGen-00-00-02 -j "" --sourceURL https://aipanda012.cern.ch:25443 --rootVer 5.34.18-davix_p6a -p "./main.sh%20ANALY_GLASGOW_SL6" -l user.sblunier.0620142403.252076.lib._003966.lib.tgz -o "{'ANALY_GLASGOW_SL6.root': 'user.sblunier.003966._00001.ANALY_GLASGOW_SL6.root'}" -r .  --usePFCTurl  --inputGUIDs "[]" 1>prun_stdout.txt 2>prun_stderr.txt

