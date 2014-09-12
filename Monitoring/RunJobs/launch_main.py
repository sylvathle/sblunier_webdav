import commands
import sys

def isBlackListed(url):
   f = open('ttreeCacheBlackList.txt','r')
   for line in f:
      if url.find(line.rstrip().replace("\t","").replace(" ","")) != -1:
         return True
   return False

f = open('listFilePerSite.txt','r')
if sys.argv[2] == 'ttreecache':
   for line in f:
      if isBlackListed(line.strip('\n')):
         continue
      s=1
      s, o = commands.getstatusoutput("./main %s %s %s" % (line.strip('\n'), sys.argv[1], sys.argv[2])) 
      print o
else:
   for line in f:
      s=1
      s, o = commands.getstatusoutput("./main %s %s %s" % (line.strip('\n'), sys.argv[1], sys.argv[2])) 
      print o
f.close()

