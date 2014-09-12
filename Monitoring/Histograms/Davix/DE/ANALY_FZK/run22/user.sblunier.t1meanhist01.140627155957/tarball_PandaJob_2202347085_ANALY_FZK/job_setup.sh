#!/bin/bash
# job_setup.sh 27 Jun 2014 14:06:27

export VO_ATLAS_SW_DIR=/cvmfs/atlas.cern.ch/repo/sw
if [ -f $VO_ATLAS_SW_DIR/local/setup.sh ]; then
  source $VO_ATLAS_SW_DIR/local/setup.sh
fi

export FRONTIER_ID="[2202347085]";
export CMSSW_VERSION=$FRONTIER_ID;
export RUCIO_APPID="prun";
export RUCIO_ACCOUNT="pilot";
export X509_USER_PROXY=/tmp/home/patlas41/home_cream_469452211/cream_469452211.proxy;
./runGen-00-00-02 -j "" --sourceURL https://aipanda012.cern.ch:25443 --rootVer 5.34.18-davix_p6a -p "./main.sh%20ANALY_FZK" -l user.sblunier.0627135957.52199.lib._004172.lib.tgz -o "{'ANALY_FZK.root': 'user.sblunier.004172._00001.ANALY_FZK.root'}" -r .  --usePFCTurl  --inputGUIDs "[]" 1>prun_stdout.txt 2>prun_stderr.txt

