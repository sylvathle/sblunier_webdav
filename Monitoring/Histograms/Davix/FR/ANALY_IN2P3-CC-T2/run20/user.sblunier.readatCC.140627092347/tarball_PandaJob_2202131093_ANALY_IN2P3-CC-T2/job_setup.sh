#!/bin/bash
# job_setup.sh 27 Jun 2014 07:28:27

export VO_ATLAS_SW_DIR=/cvmfs/atlas.cern.ch/repo/sw
if [ -f $VO_ATLAS_SW_DIR/local/setup.sh ]; then
  source $VO_ATLAS_SW_DIR/local/setup.sh
fi

source /afs/in2p3.fr/sftgroup/atlassl5/local/setup2_xrd.sh; xrdcp root://ccxrootdatlas.in2p3.fr:1094//pnfs/in2p3.fr/data/atlas/atlasscratchdisk/rucio/user/sblunier/80/38/user.sblunier.0627072347.973439.lib._004118.lib.tgz `pwd`/user.sblunier.0627072347.973439.lib._004118.lib.tgz

export FRONTIER_ID="[2202131093]";
export CMSSW_VERSION=$FRONTIER_ID;
export RUCIO_APPID="prun";
export RUCIO_ACCOUNT="pilot";
source /afs/in2p3.fr/sftgroup/atlassl5/local/setup2_xrd.sh;
export X509_USER_PROXY=/scratch/230879.1.long/home_crm08_701686982/crm08_701686982.proxy;
./runGen-00-00-02 -j "" --sourceURL https://aipanda012.cern.ch:25443 --rootVer 5.34.18-davix_p6a -p "./main.sh%20ANALY_IN2P3-CC-T2" -l user.sblunier.0627072347.973439.lib._004118.lib.tgz -o "{'ANALY_IN2P3-CC-T2.root': 'user.sblunier.004118._00001.ANALY_IN2P3-CC-T2.root'}" -r .  --usePFCTurl  --inputGUIDs "[]" 1>prun_stdout.txt 2>prun_stderr.txt

