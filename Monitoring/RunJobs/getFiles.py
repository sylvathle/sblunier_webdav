import commands
import sys

from random import choice
from dq2.info import TiersOfATLAS
from dq2.clientapi.DQ2 import DQ2


def getHeadUrl(str):
   if str=="BU_ATLAS_Tier_DATADISK":
      return "root://atlas-cm4.bu.edu"
   elif str=="CERN-PROD_DATADISK":
      return "root://atlas-xrd-eos-rucio.cern.ch"
   #elif str=="CYFRONET-LCG2_DATADISK":
   #   return "root://dpm.cyf-kr.edu.pl"
   elif str=="DESY-HH_DATADISK":
      return "root://t2-atlas-xrootd.desy.de"
   elif str=="DESY-ZN_DATADISK":
      return "root://lcg-xrd.ifh.de"
   #elif str=="FZK-LCG2_DATADISK":
   #   return "root://f01-140-115-e.gridka.de"
   elif str=="GRIF-IRFU_DATADISK":
      return "root://node12.datagrid.cea.fr"
   elif str=="GRIF-LAL_DATADISK":
      return "root://grid05.lal.in2p3.fr"
   elif str=="GRIF-LPNHE_DATADISK":
      return "root://lpnse1.in2p3.fr"
   elif str=="IN2P3-CC_DATADISK":
      return "root://ccxrdatlas.in2p3.fr"
   elif str=="IN2P3-CPPM_DATADISK":
      return "root://marsedpm.in2p3.fr"
   elif str=="IN2P3-LAPP_DATADISK":
      return "root://lapp-se01.in2p3.fr"
   elif str=="IN2P3-LPSC_DATADISK":
      return "root://lpsc-se-dpm-server.in2p3.fr"
   elif str=="INFN-FRASCATI_DATADISK":
      return "root://atlasse.lnf.infn.it"
   elif str=="INFN-NAPOLI-ATLAS_DATADISK":
      return "root://t2-dpm-01.na.infn.it"
   elif str=="INFN-ROMA1_DATADISK":
      return "root://grid-cert-03.roma1.infn.it"
   elif str=="INFN-T1_DATADISK":
      return "root://xrootd-atlas.cr.cnaf.infn.it"
   elif str=="JINR-LCG2_DATADISK":
      return "root://lcgsexrda.jinr.ru"
   elif str=="LRZ-LMU_DATADISK":
      return "root://xrootd-lrz-lmu.grid.lrz.de"
   elif str=="MPPMU_DATADISK":
      return "root://xrootd-mppmu.grid.lrz.de"
   elif str=="MWT2_DATADISK":
      return "root://fax.mwt2.org"
   elif str=="PSNC_DATADISK":
      return "root://se.reef.man.poznan.pl"
   elif str=="RAL-LCG2_DATADISK":
      return "root://atlas-xrd.gridpp.rl.ac.uk"
   elif str=="RU-PROTVINO-IHEP_DATADISK":
      return "root://vobox0004.m45.ihep.su"
   elif str=="SARA-MATRIX_DATADISK":
      return "root://fax.grid.sara.nl"
   elif str=="SFU-LCG2_DATADISK":
      return "root://bugaboo-se2.westgrid.ca"
   elif str=="SWT2_CPB_DATADISK":
      return "root://gk06.atlas-swt2.org"
   #elif str=="TAIWAN-LCG2_DATADISK":
   #   return "root://f-dpm000.grid.sinica.edu.tw"
   elif str=="UKI-LT2-QMUL_DATADISK":
      return "root://xrootd.esc.qmul.ac.uk"
   elif str=="UKI-LT2-RHUL_DATADISK":
      return "root://se2.ppgrid1.rhul.ac.uk"
   elif str=="UKI-NORTHGRID-LANCS-HEP_DATADISK":
      return "root://fal-pygrid-30.lancs.ac.uk"
   elif str=="UKI-NORTHGRID-LIV-HEP_DATADISK":
      return "root://hepgrid11.ph.liv.ac.uk"
   elif str=="UKI-NORTHGRID-MAN-HEP_DATADISK":
      return "root://bohr3226.tier2.hep.manchester.ac.uk"
   elif str=="UKI-NORTHGRID-SHEF-HEP_DATADISK":
      return "root://lcgse0.shef.ac.uk"
   elif str=="UKI-SCOTGRID-ECDF_DATADISK":
      return "root://srm.glite.ecdf.ed.ac.uk"
   elif str=="UKI-SCOTGRID-GLASGOW_DATADISK":
      return "root://svr018.gla.scotgrid.ac.uk"
   elif str=="UKI-SOUTHGRID-CAM-HEP_DATADISK":
      return "root://serv02.hep.phy.cam.ac.uk"
   elif str=="UKI-SOUTHGRID-OX-HEP_DATADISK":
      return "root://t2se01.physics.ox.ac.uk"
   elif str=="UNI-FREIBURG_DATADISK":
      return "root://sedoor1.bfg.uni-freiburg.de"
   #elif str=="UNIBE-LHEP_DATADISK":
   #   return "root://dpm.lhep.unibe.ch"
   #elif str=="IN2P3-LPC_DATADISK":
   #   return "root://clrlcgse01.in2p3.fr"
   elif str=="INFN-MILANO-ATLASC_DATADISK":
      return "root://gridftp-a1-1.mi.infn.it"
   elif str=="PRAGUELCG2_DATADISK":
      return "root://golias100.farm.particle.cz"
   elif str=="WUPPERTALPROD_DATADISK":
      return "root://up.pleiades.uni-wuppertal.de"
   elif str=="IFAE_DATADISK":
      return "root://xrootd-at2.pic.es"
   elif str=="GOEGRID_DATADISK":
      return "root://se-xrootd.goegrid.gwdg.de"
   elif str=="PIC_DATADISK":
      return "root://xrootd-at1.pic.es"
   elif str=="AUSTRALIA-ATLAS_DATADISK":
      return "root://agh3.atlas.unimelb.edu.au"
   elif str=="CA-MCGILL-CLUMEQ-T2_DATADISK":
      return "root://storm02.clumeq.mcgill.ca"
   elif str=="CA-SCINET-T2_DATADISK":
      return "root://lcg-door3.scinet.utoronto.ca"
   elif str=="TRIUMF-LCG2_DATADISK":
      return "root://xrootd.lcg.triumf.ca"
   #elif str=="CA-VICTORIA-WESTGRID-T2_DATADISK":
   #   return "root://basilisk02.westgrid.ca"
   #elif str=="CSCS-LCG2_DATADISK":
   #   return "root://atlas01.lcg.cscs.ch"
   elif str=="FZK-LCG2_DATADISK":
      return "root://atlasxrootd-kit.gridka.de"
   elif str=="PSNC_DATADISK":
      return "root://se.reef.man.poznan.pl"
   elif str=="WUPPERTALPROD_DATADISK":
      return "root://up.pleiades.uni-wuppertal.de"
   #elif str=="BEIJING-LCG2_DATADISK":
   #   return "root://dpmds07.ihep.ac.cn"
   elif str=="NIKHEF-ELPROD_DATADISK":
      return "root://tbn18.nikhef.nl"
   elif str=="AGLT2_DATADISK":
      return "root://xrootd.aglt2.org"
   elif str=="BNL-OSG2_DATADISK":
      return "root://dcdoor11.usatlas.bnl.gov"
   elif str=="NET2_DATADISK":
      return "root://atlas-cm4.bu.edu"
   elif str=="OU_OCHEP_SWT2_DATADISK":
      return "root://tier2-03.ochep.ou.edu"
   elif str=="SLACXRD_DATADISK":
      return "root://atl-prod09.slac.stanford.edu"
   else:
      return "none"


dq2 = DQ2()
#sites = map(lambda x: x[0], filter(lambda x: x[1] == 'rucio://atlas-rucio.cern.ch:/grid/atlas' and x[0].endswith('DATADISK'), map(lambda x: (x, TiersOfATLAS.getLocalCatalog(x)), TiersOfATLAS.getAllDestinationSites()))) # Black magic
#site = choice(sites)
#site = 'IN2P3-LAPP_DATADISK'
listDatadisk = 'Datadisk.txt'
pattern = []
pattern.append('mc12_8TeV*NTUP_COMMON*')
pattern.append('mc12_8TeV*NTUP_HSG2*')
pattern.append('mc12_8TeV*NTUP_SMWZ*')
pattern.append('mc12_8TeV*NTUP_TOP*')
#listSites = open('../../InfoSites/ListRucioSites.txt','r')
listSites = open(listDatadisk,'r')
outputFile = open('listFilePerSite.txt','w')
maxfiletested = 1 
for line in listSites:
   site = line.rstrip() 
   print site
   s=1
   it =0
   while s!=0 and it < maxfiletested:
      it+=1
      l = dq2.listDatasetsByNameInSite(site, name=pattern[0], complete=1)
      iter = 1
      while l == () and iter < len(pattern):
         l = dq2.listDatasetsByNameInSite(site, name=pattern[iter], complete=1)
         iter+=1
      if iter == len(pattern) and l==():
         it = maxfiletested
         continue
      dsn = choice(l)
      files = dq2.listFilesInDataset(dsn)

      c = []
      if files == ():
         continue
      if files[0] != ():
         guid = choice(files[0].keys())
         if (sys.argv[1]=='davix'):
            c = 'https://rucio-lb-prod.cern.ch/redirect/%s/%s?rse=%s' % (files[0][guid]['scope'], files[0][guid]['lfn'], site)
         elif sys.argv[1]=='xrootd':
            headUrl = getHeadUrl(site)
            sitecut = site[:-9]
            if headUrl=='none':
               c=''
            else:
               c = '%s=%s//atlas/rucio/%s:%s' % (sitecut, headUrl, files[0][guid]['scope'], files[0][guid]['lfn'])
         print c
         if c!='':
            outputFile.write(c)
            outputFile.write('\n')
