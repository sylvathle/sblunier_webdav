from bs4 import BeautifulSoup
import re
import urllib2
import sys

url = 'http://bigpanda.cern.ch/task/?jeditaskid=%s' % sys.argv[1]
#url = 'http://panda.cern.ch/server/pandamon/query?job=*&jobsetID=%s' % sys.argv[1]
url = url+'&display_limit=200'
page = urllib2.urlopen(url)
soup = BeautifulSoup(page)
#print soup
tables=soup.find_all('table')
statusTable=tables[1] 
#print statusTable
#subTable1=statusTable.find_all('table')
#print subTable1
tr=tables[1].find_all('tr')
#print tr
td=tr[2].find_all('td')
prerun=td[5].get_text() 
prerun=prerun.replace(" ","")
running=td[8].get_text()
running=prerun.replace(" ","")
holding=td[9].get_text()
holding=holding.replace(" ","")
finished=td[11].get_text()
finished=finished.replace(" ","")
failed=td[12].get_text()
failed=failed.replace(" ","")
cancelled=td[13].get_text()
cancelled=cancelled.replace(" ","")

machin1=tables[0].find_all('tr')
machin2=machin1[2].find_all('td')
done=machin2[5].get_text()
done=done.replace(" ","")
#print done


if finished=='2' or done=='done':
	echo='finished'
elif finished=='1' and failed=='1':
	echo='failed'
elif failed=='1' and cancelled=='1':
	echo='cancelled'
else:
	echo='notfinished'

if prerun!='1':
	prerun=''
if running!='end' or running!='1' or 'running'!='2':
	running=''
if holding!='1' or holding!='2':
	holding = ''
if finished=='2':
	finished='\color{green}'+finished
else:
	finished = ''
if failed=='1' or failed=='2':
	failed='\color{red}'+failed
else:
	failed = ''
if cancelled=='1' or cancelled=='2':
	cancelled='\color{yellow}'+cancelled
else:
	cancelled = ''

#print echo
#print 'done = _%s_ ' % done

if done=='running' or done=='registeredpending':
   siteTr=tables[7].find_all('tr')
   site=siteTr[24].get_text()
   done='running'
elif done=='failed' or done=='done':
   siteTr=tables[7].find_all('tr')
   site=siteTr[25].get_text()
elif done=='registeredready':
   siteTr=tables[6].find_all('tr')
   site=siteTr[24].get_text()
   done='running'
else:
   siteTr=tables[6].find_all('tr')
   site=siteTr[11].get_text()
site=site.replace("site","")
site=site.replace(" ","")
site=site.replace("_","\_")

#print site

if done=='running':
   lat='\color{yellow}'+done
elif done=='failed':
   lat='\color{red}'+done
elif done=='done':
   lat='\color{green}'+done

site='\color{black}'+site
#print lat
#if done!='done':
latexOutput = open('../Report/jobStatus.tex', 'a')
latexOutput.write('\t\hline')
latexOutput.write('\n')
latexOutput.write('\t%s & %s \\\\\n' % (site,lat))
#   latexOutput.write('\t%s:  %s\\\\\n' % (site,lat))

print done
