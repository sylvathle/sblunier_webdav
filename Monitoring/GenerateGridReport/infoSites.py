import commands
import sys

from dq2.info import TiersOfATLAS

outputFile = open('infoSites.txt','a')

site=sys.argv[1]
if site=="SWT2_CPB_DATADISK":
	outputFile.write(site)
	outputFile.write('\n')
	outputFile.write('unknown\n')
	outputFile.write('unknown\n')
	exit()
srm = TiersOfATLAS.getSiteProperty(site, 'srm')
endpoint = "/".join(":".join(srm.split(':')[2:5]).split('/')[:3])
s, o = commands.getstatusoutput('srmping -debug=True -2 -retry_num=1 %s' % endpoint)
outputFile.write(site)
outputFile.write('\n')
foundType=0
foundversion=0
if s == 0:
    for line in o.split('\n'):
        if line.find('backend_type') > -1:
            outputFile.write(line.replace('backend_type:','',1))
            outputFile.write('\n')
            foundType=1
        if line.find('backend_version') > -1:
            outputFile.write(line.strip('backend_version:'))
            outputFile.write('\n')
            foundversion=1
if foundType==0:
    outputFile.write('unknown\n')
if foundversion==0:
    outputFile.write('unknown\n')
