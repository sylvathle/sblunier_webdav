#!/bin/bash
# job_setup.sh 07 Sep 2014 11:20:19

export VO_ATLAS_SW_DIR=/cvmfs/atlas.cern.ch/repo/sw
if [ -f $VO_ATLAS_SW_DIR/local/setup.sh ]; then
  source $VO_ATLAS_SW_DIR/local/setup.sh
fi

export FRONTIER_ID="[2259651502]";
export CMSSW_VERSION=$FRONTIER_ID;
export RUCIO_APPID="panda-client-0.5.21-jedi-run";
export RUCIO_ACCOUNT="pilot";
export X509_USER_PROXY=/home/atlasplt001/home_cream_951724676/cream_951724676.proxy;
./runGen-00-00-02 -j "" --sourceURL https://aipanda012.cern.ch:25443 -r . -p "./main.sh%20DE%20ANALY_DESY-HH%20nocache%20davix" -l panda.0907111348.266648.lib._4106731.113198988.lib.tgz -o "{'ANALY_DESY-HH.root': 'user.sblunier.4106731._000001.ANALY_DESY-HH.root'}" --rootVer 5.34.19-davix_p1  --usePFCTurl  --inputGUIDs "[]" 1>athena_stdout.txt 2>athena_stderr.txt

