#!/bin/bash
# job_setup.sh 25 Aug 2014 08:56:29

export VO_ATLAS_SW_DIR=/cvmfs/atlas.cern.ch/repo/sw
if [ -f $VO_ATLAS_SW_DIR/local/setup.sh ]; then
  source $VO_ATLAS_SW_DIR/local/setup.sh
fi

export FRONTIER_ID="[2250110233]";
export CMSSW_VERSION=$FRONTIER_ID;
export RUCIO_APPID="panda-client-0.5.16-jedi-run";
export RUCIO_ACCOUNT="pilot";
export X509_USER_PROXY=/home/pilatlas008/home_crce3_679289717/crce3_679289717.proxy;
./runGen-00-00-02 -j "" --sourceURL https://aipanda011.cern.ch:25443 -r . -p "./main.sh%20IT%20ANALY_INFN-FRASCATI%20ttreecache%20xrootd" -l panda.0825084749.206437.lib._4057000.79520199.lib.tgz -o "{'ANALY_INFN-FRASCATI.root': 'user.sblunier.019907._000001.ANALY_INFN-FRASCATI.root'}" --rootVer 5.34.19-davix_p1  --usePFCTurl  --inputGUIDs "[]" 1>athena_stdout.txt 2>athena_stderr.txt

