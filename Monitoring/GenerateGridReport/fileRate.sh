#! /bin/bash



if [ "$1" == "" ]
then
   echo Set an argument to this script
   echo argument 1: cloud
   exit 1
fi

now=$(date +"%y%m%d")
here=$PWD

rm Report/numberFileRead.tex
rm Report/eventsRates.tex
i=0

rm Matrix/ROOT/* Matrix/ROOT2/*

cd Matrix/PerCentReadFiles/
make clean
make
cd ../EventsRate/
make clean
make
cd ../Ratios/
make clean
make

cd $here 
cp ../RunJobs/lastJobVersion.txt .


while read allgrid
do
	mallgrid=$tallgrid
	tallgrid=$xallgrid
	xallgrid=$allgrid
done < lastJobVersion.txt

			
if [[ $1 == 'all' ]]; then
	for inode in $(ls ../Clouds)
	do
		cd Matrix/PerCentReadFiles/
		./main $inode pascache $mallgrid
		cd ../..
		cp Matrix/PerCentReadFiles/canvas.eps Report/Img/$inode\_PerCentFile.eps
		mv Matrix/PerCentReadFiles/canvas.eps Matrix/Canvas/$inode/PerCentReadFiles/$now.eps
	
		echo '\subsection{Cloud '$inode'}'>>Report/eventsRates.tex
		echo '\includegraphics[width=\textwidth]{'$inode'_PerCentFile.eps}'>>Report/eventsRates.tex

		cd Matrix/PerCentReadFiles/
		./main $inode ttreecache $tallgrid
		cd ../..
		cp Matrix/PerCentReadFiles/canvas.eps Report/Img/$inode\_tPerCentFile.eps
		mv Matrix/PerCentReadFiles/canvas.eps Matrix/Canvas/$inode/PerCentReadFiles/t$now.eps
	
		echo '\includegraphics[width=\textwidth]{'$inode'_tPerCentFile.eps}'>>Report/eventsRates.tex

		cd Matrix/PerCentReadFiles/
		./main $inode xrootd $xallgrid
		cd ../..
		cp Matrix/PerCentReadFiles/canvas.eps Report/Img/$inode\_xPerCentFile.eps
		mv Matrix/PerCentReadFiles/canvas.eps Matrix/Canvas/$inode/PerCentReadFiles/x$now.eps
	
		echo '\includegraphics[width=\textwidth]{'$inode'_xPerCentFile.eps}'>>Report/eventsRates.tex

		cd Matrix/EventsRate/
		./main $inode pascache $mallgrid
		cd ../..
		cp Matrix/EventsRate/canvas.eps Report/Img/$inode\_EventsRate.eps
		mv Matrix/EventsRate/canvas.eps Matrix/Canvas/$inode/EventsRate/$now.eps
	
		echo '\includegraphics[width=\textwidth]{'$inode'_EventsRate.eps}'>>Report/eventsRates.tex

		cd Matrix/EventsRate/
		./main $inode ttreecache $tallgrid
		cd ../..
		cp Matrix/EventsRate/canvas.eps Report/Img/$inode\_tEventsRate.eps
		mv Matrix/EventsRate/canvas.eps Matrix/Canvas/$inode/EventsRate/t$now.eps
	
		echo '\includegraphics[width=\textwidth]{'$inode'_tEventsRate.eps}'>>Report/eventsRates.tex
		
		cd Matrix/EventsRate/
		./main $inode xrootd $xallgrid
		cd ../..
		cp Matrix/EventsRate/canvas.eps Report/Img/$inode\_xEventsRate.eps
		mv Matrix/EventsRate/canvas.eps Matrix/Canvas/$inode/EventsRate/x$now.eps
	
		echo '\includegraphics[width=\textwidth]{'$inode'_xEventsRate.eps}'>>Report/eventsRates.tex

		#####################################################

		cd $here
		cd Matrix/Ratios/
		./main $inode $tallgrid
		cd ../..
		cp Matrix/Ratios/canvas.eps Report/Img/$inode\_xRatio.eps
		mv Matrix/Ratios/canvas.eps Matrix/Canvas/$inode/EventsRate/ratio_$now.eps
		
		echo '\includegraphics[width=\textwidth]{'$inode'_xRatio.eps}'>>Report/eventsRates.tex	
		echo '\vspace{1ex}'$'\\\\\n'  >>Report/eventsRates.tex
		echo '\vspace{1ex}'$'\\\\\n'  >>Report/numberFileRead.tex
	done
else
	echo "WARNING: code not updated for a specific cloud"
	#echo $inode
	inode=$1
	cd /afs/cern.ch/user/s/sblunier/public/Histograms/Davix
	./getHist.sh $inode 
	cd -
	cd Matrix/PerCentReadFiles/
	make clean
	make
	./main
	#rm ../ROOT2/*
	cd ../..
	cp Matrix/PerCentReadFiles/canvas.pdf Clouds/$inode/PerCentFile.pdf
	cp Matrix/PerCentReadFiles/canvas.eps Clouds/$inode/PerCentFile.eps
	mv Matrix/PerCentReadFiles/canvas.pdf Matrix/Canvas/$inode/PerCentReadFiles/$now.pdf
	mv Matrix/PerCentReadFiles/canvas.eps Matrix/Canvas/$inode/PerCentReadFiles/$now.eps
		
	cd Matrix/EventsRate/
	make clean
	make
	./main
	cd ../..
	cp Matrix/EventsRate/canvas.pdf Clouds/$inode/EventsRate.pdf
	cp Matrix/EventsRate/canvas.eps Clouds/$inode/EventsRate.eps
	mv Matrix/EventsRate/canvas.pdf Matrix/Canvas/$inode/EventsRate/$now.pdf
	mv Matrix/EventsRate/canvas.eps Matrix/Canvas/$inode/EventsRate/$now.eps
	echo '\subsection{'$inode'}'>>Report/numberFileRead.tex
	echo '\includegraphics[width=\textwidth]{'../Clouds/$inode'/PerCentFile.eps}'>>Report/numberFileRead.tex
	echo '\subsection{'$inode'}'>>Report/eventsRates.tex
	echo '\includegraphics[width=\textwidth]{'../Clouds/$inode'/EventsRate.eps}'>>Report/eventsRates.tex
fi
