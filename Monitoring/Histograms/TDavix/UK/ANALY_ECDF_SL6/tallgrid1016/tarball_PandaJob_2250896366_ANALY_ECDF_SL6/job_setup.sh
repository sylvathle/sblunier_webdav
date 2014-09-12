#!/bin/bash
# job_setup.sh 26 Aug 2014 06:19:39

export VO_ATLAS_SW_DIR=/cvmfs/atlas.cern.ch/repo/sw
if [ -f $VO_ATLAS_SW_DIR/local/setup.sh ]; then
  source $VO_ATLAS_SW_DIR/local/setup.sh
fi

source /cvmfs/atlas.cern.ch/repo/sw/local/xrootdsetup.sh; xrdcp root://srm.glite.ecdf.ed.ac.uk//dpm/ecdf.ed.ac.uk/home/atlas/atlasscratchdisk/rucio/panda/17/fd/panda.0826060707.504679.lib._4060900.81934619.lib.tgz `pwd`/panda.0826060707.504679.lib._4060900.81934619.lib.tgz

export FRONTIER_ID="[2250896366]";
export CMSSW_VERSION=$FRONTIER_ID;
export RUCIO_APPID="panda-client-0.5.16-jedi-run";
export RUCIO_ACCOUNT="pilot";
source /cvmfs/atlas.cern.ch/repo/sw/local/setup.sh;
export X509_USER_PROXY=/mnt/gridpp/poolhomes/vo_pilotatlas/pilotatlas07/home_crce6_450561718/crce6_450561718.proxy;
./runGen-00-00-02 -j "" --sourceURL https://aipanda011.cern.ch:25443 -r . -p "./main.sh%20UK%20ANALY_ECDF_SL6%20ttreecache%20davix" -l panda.0826060707.504679.lib._4060900.81934619.lib.tgz -o "{'ANALY_ECDF_SL6.root': 'user.sblunier.020375._000001.ANALY_ECDF_SL6.root'}" --rootVer 5.34.19-davix_p1  --lfcHost prod-lfc-atlas.cern.ch --inputGUIDs "[]" 1>athena_stdout.txt 2>athena_stderr.txt

