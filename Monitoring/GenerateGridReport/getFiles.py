import commands
import sys

from random import choice
from dq2.info import TiersOfATLAS
from dq2.clientapi.DQ2 import DQ2


dq2 = DQ2()
#sites = map(lambda x: x[0], filter(lambda x: x[1] == 'rucio://atlas-rucio.cern.ch:/grid/atlas' and x[0].endswith('DATADISK'), map(lambda x: (x, TiersOfATLAS.getLocalCatalog(x)), TiersOfATLAS.getAllDestinationSites()))) # Black magic
#site = choice(sites)
#site = 'IN2P3-LAPP_DATADISK'
pattern = []
pattern.append('mc12_8TeV*NTUP_COMMON*')
pattern.append('mc12_8TeV*NTUP_HSG2*')
pattern.append('mc12_8TeV*NTUP_SMWZ*')
pattern.append('mc12_8TeV*NTUP_TOP*')
outputFile = open('listFilePerSite.txt','a')
maxfiletested = 1 
site = sys.argv[1] 
print site
outputFile.write(site)
outputFile.write('\n')
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
      outputFile.write('empty\n')
      continue
   dsn = choice(l)
   files = dq2.listFilesInDataset(dsn)

   c = []
   #if files == ():
      #continue
      #outputFile.write(site)
      #outputFile.write('\n\n')
   if files[0] != ():
      guid = choice(files[0].keys())
      c = 'https://rucio-lb-prod.cern.ch/redirect/%s/%s?rse=%s' % (files[0][guid]['scope'], files[0][guid]['lfn'], site)
      print c
      outputFile.write(c)
      outputFile.write('\n')
   else:
      outputFile.write('empty\n')
      
