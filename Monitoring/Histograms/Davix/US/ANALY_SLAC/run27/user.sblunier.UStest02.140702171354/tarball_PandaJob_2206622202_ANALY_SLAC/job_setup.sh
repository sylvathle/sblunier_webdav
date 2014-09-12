#!/bin/bash
# job_setup.sh 02 Jul 2014 15:20:22

export VO_ATLAS_SW_DIR=/cvmfs/atlas.cern.ch/repo/sw
if [ -f $VO_ATLAS_SW_DIR/local/setup.sh ]; then
  source $VO_ATLAS_SW_DIR/local/setup.sh
fi

export FRONTIER_ID="[2206622202]";
export CMSSW_VERSION=$FRONTIER_ID;
export RUCIO_APPID="prun";
export RUCIO_ACCOUNT="pilot";
source /afs/slac.stanford.edu/package/xrootd/atlasutils/setup.sh;
export X509_USER_PROXY=/nfs/slac/g/grid/osg/u/osgatlas01/.globus/osgatlas01/.globus/job/osgserv02/16434192497685279316.16372851839882915988/x509_user_proxy;
./runGen-00-00-02 -j "" --sourceURL https://aipanda011.cern.ch:25443 --rootVer 5.34.18-davix_p6a -p "./main.sh%20US%20ANALY_SLAC" -l user.sblunier.0702151354.709915.lib._004520.lib.tgz -o "{'ANALY_SLAC.root': 'user.sblunier.004520._00001.ANALY_SLAC.root'}" -r .  --usePFCTurl  --inputGUIDs "[]" 1>prun_stdout.txt 2>prun_stderr.txt

