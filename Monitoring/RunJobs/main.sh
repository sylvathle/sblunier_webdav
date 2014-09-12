#!/bin/bash

#export X509_USER_PROXY=./x509up_u68281
for i in {1..100}
do
   echo $1 $2 $3
   python getFiles.py $3
   python launch_main.py $1 $2
done
