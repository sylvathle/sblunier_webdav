#!/bin/bash
if [[ "$1" == "ttreecache" ]]; then
        title="Jobs with TTreeCache enabled"
	jobIDFile=tjobIDs.txt
elif [[ "$1" == "xrootd" ]];then
	title="Jobs with xrootd (TTreeCache enabled)"
	jobIDFile=xjobIDs.txt
else
        title="Jobs with TTreeCache disabled"
	jobIDFile=mjobIDs.txt
fi


echo $title $'\n'>>Report/jobStatus.tex
echo '\begin{longtable}{|c|c|}'$'\n'>>Report/jobStatus.tex 
echo $'\t''\hline'$'\n'>>Report/jobStatus.tex
echo $'\t''Queue & Job Status\\\hline'>>Report/jobStatus.tex
echo $'\t''\endhead'$'\n'>>Report/jobStatus.tex
cd beautifulsoup4-4.3.2
re='registered'
registered=0
ru='running'
running=0
do='done'
done=0
fi='finished'
finished=0
fa='failed'
failed=0
ca='cancelled'
cancelled=0
no='notfinished'
notfinished=0
task=0

cp ../RunJobs/mjobID.txt .
cp ../RunJobs/tjobID.txt .
cp ../RunJobs/xjobID.txt .

echo $jobIDFile

while read jobID
do
	echo $jobID
	jobStatus=$(python jobStatus.py $jobID)
	echo $jobStatus
	if [[ $jobStatus = 'failed' ]]; then
		((failed=failed+1))
	elif [[ $jobStatus = 'registeredpending' ]]; then
		((registered=registered+1))
	elif [[ $jobStatus = 'done' ]]; then
		((done=done+1))
	elif [[ $jobStatus = 'running' ]]; then
		((registered=registered+1))
	else
		echo job status not identified $jobStatus
	fi
done < $jobIDFile
cd ..
#echo $pythOutPut
echo '\hline'$'\n'>>Report/jobStatus.tex
echo '\end{longtable}'>>Report/jobStatus.tex
echo $done $failed $registered
cd PieChart/job/
make
./main $done $failed $registered

if [[ "$1" == "ttreecache" ]]; then
	mv canvas.eps tcanvas.eps
	cd ../..
	echo '\includegraphics[width=\textwidth]{../PieChart/job/tcanvas.eps}'>>Report/jobStatus.tex
elif [[ "$1" == "xrootd" ]];then
	mv canvas.eps xcanvas.eps
	cd ../..
	echo '\includegraphics[width=\textwidth]{../PieChart/job/xcanvas.eps}'>>Report/jobStatus.tex
else
	mv canvas.eps mcanvas.eps
	cd ../..
	echo '\includegraphics[width=\textwidth]{../PieChart/job/mcanvas.eps}'>>Report/jobStatus.tex
fi
