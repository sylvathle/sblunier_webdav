#!/bin/bash

"exec" "python" "-u" "$0" "$@"

"""
Build job

Usage:

source $SITEROOT/setup.sh
source $T_DISTREL/AtlasRelease/*/cmt/setup.sh -tag_add=???
buildJob.py -i [sources] -o [libraries] 

[sources]   : an archive which contains source files.
              each file path must be relative to $CMTHOME 
[libraries] : an archive which will contain compiled libraries.
              each file path is relative to $CMTHOME.
              absolute paths in InstallArea are changed to relative paths
              except for externals.

Procedure:

* create a tmp dir for 'cmt broadcast'
* expand sources
* make a list of packages
* create requirements in the tmp dir
* do 'cmt broadcast' in the tmp dir
* change absolute paths in InstallArea to be relative
* archive

"""

import os
import re
import sys
import time
import getopt
import commands

# error code
EC_MissingArg  = 10
EC_CMTFailed   = 20
EC_NoTarball   = 30

print "--- start ---"
print time.ctime()

debugFlag = False
sourceURL = 'https://gridui01.usatlas.bnl.gov:25443'

# command-line parameters
opts, args = getopt.getopt(sys.argv[1:], "i:o:u:",
                           ["pilotpars","debug","oldPrefix=","newPrefix=",
                            "directIn","sourceURL=","lfcHost=","envvarFile=",
			    "useFileStager","accessmode=","copytool="])
for o, a in opts:
    if o == "-i":
        sources = a
    if o == "-o":
        libraries = a
    if o == "--debug":
        debugFlag = True
    if o == "--sourceURL":
        sourceURL = a

# dump parameter
try:
    print sources
    print libraries
    print debugFlag
    print sourceURL
except:
    sys.exit(EC_MissingArg)

# save current dir
currentDir = os.getcwd()

print "Running in",currentDir

print "--- wget ---"
print time.ctime()

# FIXME : get input file and then delete it
output = commands.getoutput('wget -h')
#print output
wgetCommand = 'wget'
for line in output.split('\n'):
    if re.search('--no-check-certificate',line) != None:
        wgetCommand = 'wget --no-check-certificate'
        break
print wgetCommand
print commands.getoutput('%s %s/cache/%s' % (wgetCommand,sourceURL,sources))
if not os.path.exists(sources):
    print "wget did not work, try curl"
    cmd = 'curl --insecure -sS -o %s %s/cache/%s' % (sources,sourceURL,sources)
    print cmd
    print commands.getoutput(cmd)

if not os.path.exists(sources):
    print 'ERROR: unable to fetch source tarball from web'
    sys.exit(EC_NoTarball)

# goto work dir
workDir = currentDir + '/workDir'
print commands.getoutput('rm -rf %s' % workDir)
os.makedirs(workDir)
print "Goto workDir",workDir
os.chdir(workDir)

# crate tmpdir
tmpDir = commands.getoutput('uuidgen 2>/dev/null') + '/cmt'
print "Making tmpDir",tmpDir
os.makedirs(tmpDir)

print "--- expand source ---"
print time.ctime()

# expand sources
if sources.startswith('/'):
    out = commands.getoutput('tar xvfzm %s' % sources)
else:
    out = commands.getoutput('tar xvfzm %s/%s' % (currentDir,sources))
print out

# check if groupArea exists
groupFile = re.sub('^sources','groupArea',sources)
groupFile = re.sub('\.gz$','',groupFile)
useGroupArea = False
if os.path.exists("%s/%s" % (workDir,groupFile)):
    useGroupArea = True
    # make groupArea
    groupAreaDir = currentDir + '/personal/groupArea'
    commands.getoutput('rm -rf %s' % groupAreaDir)
    os.makedirs(groupAreaDir)
    # goto groupArea
    print "Goto groupAreaDir",groupAreaDir
    os.chdir(groupAreaDir)
    # expand groupArea
    print commands.getoutput('tar xvfm %s/%s' % (workDir,groupFile))
    # make symlink to InstallArea
    os.symlink('%s/InstallArea' % workDir, 'InstallArea')
    # back to workDir
    os.chdir(workDir)

# list packages
packages=[]
for line in out.splitlines():
    name = line.split()[-1]
    if name.endswith('/cmt/') and not '__panda_rootCoreWorkDir' in name:
        # remove /cmt/
        name = re.sub('/cmt/$','',name)
        packages.append(name)

# create requirements
oFile = open(tmpDir+'/requirements','w')
oFile.write('use AtlasPolicy AtlasPolicy-*\n')
useVersionDir = False
# append user packages
for pak in packages:
    # version directory
    vmat = re.search('-\d+-\d+-\d+$',pak)
    if vmat:
	useVersionDir = True 
        mat = re.search('^(.+)/([^/]+)/([^/]+)$',pak)
        if mat:
            oFile.write('use %s %s %s\n' % (mat.group(2),mat.group(3),mat.group(1)))
        else:
            mat = re.search('^(.+)/([^/]+)$',pak)
            if mat:
                oFile.write('use %s %s\n' % (mat.group(1),mat.group(2)))
            else:
		oFile.write('use %s\n' % pak)
    else:                                
        mat = re.search('^(.+)/([^/]+)$',pak)
        if mat:
            oFile.write('use %s %s-* %s\n' % (mat.group(2),mat.group(2),mat.group(1)))
        else:
            oFile.write('use %s\n' % pak)
oFile.close()

# OS release
print "--- /etc/redhat-release ---"
tmp = commands.getoutput('cat /etc/redhat-release')
print tmp
match = re.search('(\d+\.\d+[\d\.]*)\s+\([^\)]+\)',tmp)
osRelease = ''
if match != None:
    osRelease = match.group(1)
print "Release -> %s" % osRelease
# processor
print "--- uname -p ---"
processor = commands.getoutput('uname -p')
print processor
# cmt config
print "--- CMTCONFIG ---"
cmtConfig = commands.getoutput('echo $CMTCONFIG')
print cmtConfig
# compiler
print "--- gcc ---"
tmp = commands.getoutput('gcc -v')
print tmp
match = re.search('gcc version (\d+\.\d+[^\s]+)',tmp.split('\n')[-1])
gccVer = ''
if match != None:
    gccVer = match.group(1)
print "gcc -> %s" % gccVer
# check if g++32 is available
print "--- g++32 ---"
s32,o32 = commands.getstatusoutput('which g++32')
print s32
print o32
# make alias of gcc323 for SLC4
gccAlias = ''
if s32 == 0 and osRelease != '' and osRelease >= '4.0':
    # when CMTCONFIG has slc3-gcc323
    if cmtConfig.find('slc3-gcc323') != -1:
        # unset alias when gcc ver is unknown or already has 3.2.3
        if not gccVer in ['','3.2.3']:
            # 64bit or not
            if processor == 'x86_64':
                gccAlias = 'echo "%s -m32 \$*" > g++;' % o32
            else:
                gccAlias = 'echo "%s \$*" > g++;' % o32
            gccAlias += 'chmod +x g++; export PATH=%s/%s:$PATH;' % (workDir,tmpDir)
print "--- gcc alias ---"
print "      ->  %s" % gccAlias
                
print "--- compile ---"
print time.ctime()

if not useGroupArea:
    # append workdir to CMTPATH
    env = 'CMTPATH=%s:$CMTPATH' % os.getcwd()
else:
    # append workdir+groupArea to CMTPATH
    env = 'CMTPATH=%s:%s:$CMTPATH' % (os.getcwd(),groupAreaDir)
# use short basename 
symLinkRel = ''
try:
    # get tmp dir name
    tmpDirName = ''
    if os.environ.has_key('EDG_TMP'):
        tmpDirName = os.environ['EDG_TMP']
    elif os.environ.has_key('OSG_WN_TMP'):
        tmpDirName = os.environ['OSG_WN_TMP']
    else:
        tmpDirName = '/tmp'
    # make symlink
    if os.environ.has_key('SITEROOT'):
        # use /tmp if it is too long. 10 is the length of tmp filename
        if len(tmpDirName)+10 > len(os.environ['SITEROOT']):
            print "INFO : use /tmp since %s is too long" % tmpDirName
            tmpDirName = '/tmp'
        # make tmp file first
        import tempfile
        tmpFD,tmpPathName = tempfile.mkstemp(dir=tmpDirName)
        os.close(tmpFD)
        # change tmp file to symlink
        tmpS,tmpO = commands.getstatusoutput('ln -fs %s %s' % (os.environ['SITEROOT'],tmpPathName))
        if tmpS != 0:
            print tmpO
            print "WARNING : cannot make symlink %s %s" % (os.environ['SITEROOT'],tmpPathName)
            # remove
            os.remove(tmpPathName)
        else:
            # compare length
            if len(tmpPathName) < len(os.environ['SITEROOT']):
                shortCMTPATH = os.environ['CMTPATH'].replace(os.environ['SITEROOT'],tmpPathName)
                # set path name
                symLinkRel = tmpPathName
            else:
                print "WARNING : %s is shorter than %s" % (os.environ['SITEROOT'],tmpPathName)
                # remove
                os.remove(tmpPathName)
except:
    errType,errValue,errTraceBack = sys.exc_info()
    print 'WARNING : failed to make short CMTPATH due to %s - %s' % (errType,errValue)
                
# construct command
com  = ''
if symLinkRel != '':
    com += 'export SITEROOT=%s;export CMTPATH=%s;' % (symLinkRel,shortCMTPATH)
    if os.environ.has_key('CMTPROJECTPATH') and os.environ['SITEROOT'] == os.environ['CMTPROJECTPATH']:
	com += 'export CMTPROJECTPATH=%s;' % symLinkRel
com += 'export %s;' % env
com += 'cmt config;'
com += 'source ./setup.sh;'
if gccAlias != '':
    com += gccAlias
if useVersionDir:
    com += 'export CMTSTRUCTURINGSTYLE=with_version_directory;'
com += 'export TestArea=%s;' % workDir
comConf = com
com += 'env; cmt br cmt config;'
com += 'cmt br make'
comConf += 'cmt br "rm -rf ../genConf";'
comConf += 'cmt br make'

# do cmt under tmp dir
print "cmt:", com
os.chdir(tmpDir)
if not debugFlag:
    status,out = commands.getstatusoutput(com)
    print out
    # look for error since cmt doesn't set error code when make failed
    if status == 0:
        try:
            for line in out.split('\n')[-3:]:
                if line.startswith('make') and re.search('Error \d+$',line) != None:
                    status = 1
                    print "ERROR: make failed. set status=%d" % status
                    break
        except:
            pass
else:
    status = os.system(com)    
if status:
    print "ERROR: CMT failed : %d" % status
    sys.exit(EC_CMTFailed)

# copy so for genConf
print
print "==== copy so"
# sleep for touch
time.sleep(120)
for pak in packages:
    try:
        # look for so
        srcSoDir = '%s/%s/%s' % (workDir,pak,cmtConfig)
        dstSoDir = '%s/InstallArea/%s/lib' % (workDir,cmtConfig)
        srcSoFiles = os.listdir(srcSoDir)
        for srcSoFile in srcSoFiles:
            if srcSoFile.endswith('.so') or srcSoFile.endswith('.dsomap'):
                # remove symlink
                com = "rm -fv %s/%s" % (dstSoDir,srcSoFile)
                print com
                print commands.getoutput(com)
                # copy so
                com = "cp -v %s/%s %s" % (srcSoDir,srcSoFile,dstSoDir) 
                print com
                print commands.getoutput(com)
                # update timestamp to prevent creating symlink again
                com = "touch %s/%s" % (dstSoDir,srcSoFile) 
                print com
                print commands.getoutput(com)
    except:
        type, value, traceBack = sys.exc_info()
        print "ERROR: in copy so : %s %s" % (type,value)

# check lib dir before
com = 'ls -l %s/InstallArea/%s/lib' % (workDir,cmtConfig)
print "==== %s" % com
print commands.getoutput(com)

# run make again for genConf
print "==== run genConf again"
print comConf
print commands.getoutput(comConf)

# check lib dir after
com = 'ls -l %s/InstallArea/%s/lib' % (workDir,cmtConfig)
print "==== %s" % com
print commands.getoutput(com)

# go back to work dir
os.chdir(workDir)

# change absolute paths in InstallArea to relative paths
fullPathList = []
def reLink(dir,dirPrefix):
    try:
        # get files
        flist=os.listdir(dir)
        dirPrefix = dirPrefix+'/..'
        # save the current dir
        curDir = os.getcwd()
        os.chdir(dir)
        for item in flist:
            # if symbolic link
            if os.path.islink(item):
                # change full path to relative path
                fullPath = os.readlink(item)
                # check if it is already processed, to avoid an infinite loop
                if fullPath in fullPathList:
                    continue
                fullPathList.append(fullPath)
                # remove special characters from comparison string
                sString=re.sub('[\+]','.',workDir)
                # replace
                relPath = re.sub('^%s/' % sString, '', fullPath)
                if relPath != fullPath:
                    # re-link
                    os.remove(item)
                    os.symlink('%s/%s' % (dirPrefix,relPath), item)
            # if directory
            if os.path.isdir(item):
                reLink(item,dirPrefix)
        # back to the previous dir
        os.chdir(curDir)
    except:
        type, value, traceBack = sys.exc_info()
        print "ERROR: in reLink(%s) : %s %s" % (curDir,type,value)

# execute reLink()
for item in os.listdir('.'):
    if os.path.isdir(item):
        reLink(item,'.')

# remove tmp dir
commands.getoutput('rm -rf %s' % re.sub('/cmt$','',tmpDir))

print "--- archive libraries ---"
print time.ctime()

# archive
if libraries.startswith('/'):
    commands.getoutput('tar cvfz %s *' % libraries)
else:
    commands.getoutput('tar cvfz %s/%s *' % (currentDir,libraries))

# go back to current dir
os.chdir(currentDir)

# remove workdir
if not debugFlag:
    commands.getoutput('rm -rf %s' % workDir)
    # remove groupArea
    if useGroupArea:
        commands.getoutput('rm -rf %s' % groupAreaDir)

# remove symlink for rel
if symLinkRel != '':
    commands.getoutput('rm -rf %s' % symLinkRel)

print "--- finished ---"
print time.ctime()

# return
sys.exit(0)
