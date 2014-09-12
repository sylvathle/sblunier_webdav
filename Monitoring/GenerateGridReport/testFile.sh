#! /bin/bash

if [ "$1" == "" ]
then
   echo argument 1 = cloud or all '(ex: DE)'
   exit 1
fi

function getSiteParams {
	iterator=0
	foundSite=0
	while read line
	do
		if [ $iterator == 3 ];
		then
			iterator=0
			foundSite=0 
		fi
		if [ "$line" == $1 ];
		then
			foundSite=1 
		fi
		if [ $foundSite == 1 ];
		then
			if [ $iterator == 1 ];
			then
				typeStorage=$line
			fi
			if [ $iterator == 2 ];
			then
				storageVersion=$line
			fi
			
		fi
		((iterator=iterator+1))
	done < infoSites.txt
}


function RedList {
	isInRedList=0
	while read list
	do
		if [ "$list" == $1 ];
		then
			isInRedList=1 
		fi
	done < redList.txt
}

#proxy=$X509_USER_PROXY
#proxy=${proxy#/tmp/}
#cp $X509_USER_PROXY .
cd testDavix
make
cd ..


http200="HTTP/1.1 200 OK"
ithttp200=0
http400="HTTP/1.1 400 Bad Request"
ithttp400=0
http403a="HTTP/1.1 403 Storage area ATLASDATADISK-FS doesn't support https protocol"
ithttp403a=0
http403b="HTTP/1.1 403 Forbidden"
ithttp403b=0
http404="HTTP/1.1 404 Not Found"
ithttp404=0
http500="HTTP/1.1 500 Internal Server Error"
ithttp500=0
httpFailConnect="curl: (7) couldn't connect to host"
ithttpFailConnect=0
#httpFailConnect="curl: (7)"
httpsslError="curl: (35) SSL connect error"
httptimeout1="Operation timed out"
httptimeout2="connect() timed out"
ithttpsslError=0
totalDatadisks=0
successDatadisks=0
itHasNotWebDAV=0
itHasNoFile=0
davixSuccess=0
ithttptimeout=0
#httpsslError="curl: (35)"
rm Report/testFile.tex

if [[ $1 == 'all'  ]]; then
	for cloud in $(ls ../Clouds)
	do
		iterlistfile=0
		#cloud="DE"
		echo '\subsection{'$cloud$'}\n'>>Report/testFile.tex
		while read line  
		do   
			((iterlistfile=iterlistfile+1))
	        	if [[ $iterlistfile == 1 ]]; then 
				datadisk=$line
				continue		
			elif [[ $iterlistfile == 2 ]]; then
				iterlistfile=0
			fi
			
			((totalDatadisks=totalDatadisks+1))
			datadiskforlatex=${datadisk//_/\\_}
		 	result=0
			now=$(date +"%d/%m/%y at %T")
			RedList $datadisk
			if [[ $isInRedList == 1 ]]; then
				((itHasNotWebDAV=itHasNotWebDAV+1))
				curlOutput="WebDAV not enabled"
				mainOutPut="Davix not tested"
				result=0
				curlColor='red'
			elif [[ $line == "empty" ]]; then	
				echo $line
				file='No file found on this datadisk'
				((itHasNoFile=itHasNoFile+1))
				curlOutput='No file could be tested'
				mainOutPut='No file could be tested'
				color='red'
				curlColor='red'
			else
				test1=$(curl -LI -m 30 --capath /etc/grid-security/certificates/ --cacert $X509_USER_PROXY --cert $X509_USER_PROXY $line 2>&1)
				file=`expr match "$line" '\(.*?\)'`
				size=${#file}-1
				file=${file:0:$size}
				if [[ $test1 =~ "$http200"  ]]; then
					result=1
					((ithttp200=ithttp200+1))
					curlOutput=$'good'
					curlColor='green'
				elif [[ $test1 =~ "$http400"  ]]; then
					((ithttp400=ithttp400+1))
					curlOutput="$http400"
					curlColor='red'
				elif [[ $test1 =~ "$http403a"  ]]; then
					((ithttp403a=ithttp403a+1))
					curlOutput="$http403a"
					curlColor='red'
				elif [[ $test1 =~ "$http403b"  ]]; then
					((ithttp403b=ithttp403b+1))
					curlOutput="$http403b"
					curlColor='red'
				elif [[ $test1 =~ "$http404"  ]]; then
					((ithttp404=ithttp404+1))
					curlOutput="$http404"
					curlColor='red'
				elif [[ $test1 =~ "$http500"  ]]; then
					((ithttp500=ithttp500+1))
					curlOutput="$http500"
					curlColor='red'
				elif [[ $test1 =~ "$httpFailConnect"  ]]; then
					((ithttpFailConnect=ithttpFailConnect+1))
					curlOutput="$httpFailConnect"
					curlColor='red'
				elif [[ $test1 =~ "$httpsslError"  ]]; then
					((ithttpsslError=ithttpsslError+1))
					curlOutput="$httpsslError"
					curlColor='red'
				elif [[ $test1 =~ "$httptimeout1" ]]; then
					((ithttptimeout=ithttptimeout+1))
					curlOutput="$httptimeout1"
					curlColor='red'
				elif [[ $test1 =~ "$httptimeout2"  ]]; then
					((ithttptimeout=ithttptimeout+1))
					curlOutput="$httptimeout2"
					curlColor='red'
				else
					curlOutput="New curl error that has to be identified">>Report/testFile.tex
					curlColor='red'
				fi
		
				echo $line
				if [[ $result == 1 ]]; then
					test2=$(./testDavix/main $line)	
					if [ $? -eq 0 ]; then
						mainOutPut="Davix test Ok"
						((davixSuccess=davixSuccess+1))
					else
						mainOutPut="Davix test Failed"
						result=0
					fi
					echo $test2
				else
					mainOutPut="Davix not tested"
					result=0
				fi
			fi	
		
	
	
			#fill the report
			if [[ $result == 1 ]]; then
				color='green'
				((successDatadisks=successDatadisks+1))
			else
				color='red'	
			fi
	
			getSiteParams $datadisk
			echo '\rule{\textwidth}{1pt}'$'\\\\\n'>>Report/testFile.tex
			echo '\textcolor{'$color'}{\normalsize{'$datadiskforlatex$'}}\\\\\n'>>Report/testFile.tex
			echo 'Storage:' $typeStorage', version: '$storageVersion$'\\\\\n'>>Report/testFile.tex
			echo $'File tested:\\\\'>>Report/testFile.tex 
			echo '\footnotesize{'${file//_/\\_}$'}\\\\\n'>>Report/testFile.tex
			echo 'date: '$now$'\\\\\n'>>Report/testFile.tex
			echo 'curl output: ' '\textcolor{'$curlColor'}{'$curlOutput$'}\\\\\n'>>Report/testFile.tex
			echo 'davix result: ' '\textcolor{'$color'}{'$mainOutPut$'}\\\\\n'>>Report/testFile.tex
			#echo '-----------------------------------------------------------'
		done < ../Clouds/$cloud/listFilePerSite.txt 
	done
else
	iterlistfile=0
	cloud=$1
	echo '\subsection{'$cloud$'}\n'>>Report/testFile.tex
	while read line  
	do   
		((iterlistfile=iterlistfile+1))
	       	if [[ $iterlistfile == 1 ]]; then 
			datadisk=$line
			continue		
		elif [[ $iterlistfile == 2 ]]; then
			iterlistfile=0
		fi
		
		((totalDatadisks=totalDatadisks+1))
		datadiskforlatex=${datadisk//_/\\_}
	 	result=0
		now=$(date +"%d/%m/%y at %T")
		#test1=$(curl -LI --capath /etc/grid-security/certificates/ --cacert $X509_USER_PROXY --cert $X509_USER_PROXY $line 2>&1)
		RedList $datadisk
		if [[ $isInRedList == 1 ]]; then
			((itHasNotWebDAV=itHasNotWebDAV+1))
			curlOutput="WebDAV not enabled"
			mainOutPut="Davix not tested"
			result=0
			curlColor='red'
		elif [[ $line == "empty" ]]; then	
			echo $line
			file='No file found on this datadisk'
			((itHasNoFile=itHasNoFile+1))
			curlOutput='No file could be tested'
			mainOutPut='No file could be tested'
			color='red'
			curlColor='red'
		else
			test1=$(curl -LI -m 30 --capath /etc/grid-security/certificates/ --cacert $X509_USER_PROXY --cert $X509_USER_PROXY $line 2>&1)
			file=`expr match "$line" '\(.*?\)'`
			size=${#file}-1
			file=${file:0:$size}
			if [[ $test1 =~ "$http200"  ]]; then
				result=1
				((ithttp200=ithttp200+1))
				curlOutput=$'good'
				curlColor='green'
			elif [[ $test1 =~ "$http400"  ]]; then
				((ithttp400=ithttp400+1))
				curlOutput="$http400"
				curlColor='red'
			elif [[ $test1 =~ "$http403a"  ]]; then
				((ithttp403a=ithttp403a+1))
				curlOutput="$http403a"
				curlColor='red'
			elif [[ $test1 =~ "$http403b"  ]]; then
				((ithttp403b=ithttp403b+1))
				curlOutput="$http403b"
				curlColor='red'
			elif [[ $test1 =~ "$http404"  ]]; then
				((ithttp404=ithttp404+1))
				curlOutput="$http404"
				curlColor='red'
			elif [[ $test1 =~ "$http500"  ]]; then
				((ithttp500=ithttp500+1))
				curlOutput="$http500"
				curlColor='red'
			elif [[ $test1 =~ "$httpFailConnect"  ]]; then
				((ithttpFailConnect=ithttpFailConnect+1))
				curlOutput="$httpFailConnect"
				curlColor='red'
			elif [[ $test1 =~ "$httpsslError"  ]]; then
				((ithttpsslError=ithttpsslError+1))
				curlOutput="$httpsslError"
				curlColor='red'
			elif [[ $test1 =~ "$httptimeout1" ]]; then
				((ithttptimeout=ithttptimeout+1))
				curlOutput="$httptimeout1"
				curlColor='red'
			elif [[ $test1 =~ "$httptimeout2"  ]]; then
				((ithttptimeout=ithttptimeout+1))
				curlOutput="$httptimeout2"
				curlColor='red'
			else
				curlOutput="New curl error that has to be identified">>Report/testFile.tex
				curlColor='red'
			fi

			echo $line
			if [[ $result == 1 ]]; then
				test2=$(./main $line)   
				if [ $? -eq 0 ]; then
					mainOutPut="Davix test Ok"
                                        ((davixSuccess=davixSuccess+1))
                                else
                                                mainOutPut="Davix test Failed"
                                                result=0
                                fi  
                        else
                        	mainOutPut="Davix not tested"
                                result=0
                        fi  

		fi	
	
		
		#fill the report
		if [[ $result == 1 ]]; then
			color='green'
			((successDatadisks=successDatadisks+1))
		else
			color='red'	
		fi
		getSiteParams $datadisk
		#echo '\rule{\textwidth}{1pt}'$'\\\\\n'
		echo '\rule{\textwidth}{1pt}'$'\\\\\n'>>Report/testFile.tex
		echo '\textcolor{'$color'}{\normalsize{'$datadiskforlatex$'}}\\\\\n'>>Report/testFile.tex
		echo 'Storage:' $typeStorage', version: '$storageVersion$'\\\\\n'>>Report/testFile.tex
		echo $'File tested:\\\\'>>Report/testFile.tex 
		echo '\footnotesize{'${file//_/\\_}$'}\\\\\n'>>Report/testFile.tex
		echo 'date: '$now$'\\\\\n'>>Report/testFile.tex
		echo 'curl output: ' '\textcolor{'$curlColor'}{'$curlOutput$'}\\\\\n'>>Report/testFile.tex
		echo 'davix result: ' '\textcolor{'$color'}{'$mainOutPut$'}\\\\\n'>>Report/testFile.tex
		#echo '-----------------------------------------------------------'
	done < ../Clouds/$cloud/listFilePerSite.txt 
fi

rm Report/testFileCanvas.tex
cd PieChart/curl/
echo $ithttp200 $ithttp403a $ithttp403b $ithttp404 $ithttp500 $ithttpFailConnect $ithttpsslError $itHasNotWebDAV $itHasNoFile $ithttp400 $ithttptimeout
make clean
make
./main $ithttp200 $ithttp403a $ithttp403b $ithttp404 $ithttp500 $ithttpFailConnect $ithttpsslError $itHasNotWebDAV $itHasNoFile $ithttp400 $ithttptimeout
cp canvas.eps ../../Report/Img/curlPiecanvas.eps
cd ../..
echo '\includegraphics[width=\textwidth]{curlPiecanvas.eps}'>>Report/testFileCanvas.tex

((total=ithttp200+ithttp403a+ithttp403b+ithttp404+ithttp500+ithttpFailConnect+ithttpsslError+itHasNotWebDAV+itHasNoFile+ithttp400))
((failedDatadisks=totalDatadisks-davixSuccess))
cd PieChart/davix/
echo $davixSuccess $failedDatadisks
make clean
make
./main $davixSuccess $failedDatadisks
cp canvas.eps ../../Report/Img/davixPiecanvas.eps
cd ../..
echo '\includegraphics[width=\textwidth]{davixPiecanvas.eps}'>>Report/testFileCanvas.tex

cd TimeEvolution/curl
echo $(date +"%d/%m/%y")$'\t'$ithttp200 >>curlsuccess.txt
make clean
make
./main
cp canvas.eps ../../Report/Img/timeEvolutioncanvas.eps
cd ../..
echo '\includegraphics[width=\textwidth]{timeEvolutioncanvas.eps}'>>Report/testFileCanvas.tex
#echo '\includegraphics[width=\textwidth]{../TimeEvolution/davix/canvas.eps}'>>Report/testFileCanvas.tex
