#!/bin/bash
# job_setup.sh 25 Aug 2014 08:56:33

export VO_ATLAS_SW_DIR=/cvmfs/atlas.cern.ch/repo/sw
if [ -f $VO_ATLAS_SW_DIR/local/setup.sh ]; then
  source $VO_ATLAS_SW_DIR/local/setup.sh
fi

source /cvmfs/atlas.cern.ch/repo/sw/local/xrootdsetup.sh; xrdcp root://serv02.hep.phy.cam.ac.uk//dpm/hep.phy.cam.ac.uk/home/atlas/atlasscratchdisk/rucio/panda/b7/fb/panda.0825085146.796155.lib._4057022.79520741.lib.tgz `pwd`/panda.0825085146.796155.lib._4057022.79520741.lib.tgz

export FRONTIER_ID="[2250111557]";
export CMSSW_VERSION=$FRONTIER_ID;
export RUCIO_APPID="panda-client-0.5.16-jedi-run";
export RUCIO_ACCOUNT="pilot";
source /cvmfs/atlas.cern.ch/repo/sw/local/setup.sh;
export X509_USER_PROXY=/home/pltatl16/home_cream_709766076/cream_709766076.proxy;
./runGen-00-00-02 -j "" --sourceURL https://aipanda011.cern.ch:25443 -r . -p "./main.sh%20UK%20ANALY_CAM_SL6%20ttreecache%20xrootd" -l panda.0825085146.796155.lib._4057022.79520741.lib.tgz -o "{'ANALY_CAM_SL6.root': 'user.sblunier.019945._000001.ANALY_CAM_SL6.root'}" --rootVer 5.34.19-davix_p1  --lfcHost prod-lfc-atlas.cern.ch --inputGUIDs "[]" 1>athena_stdout.txt 2>athena_stderr.txt

