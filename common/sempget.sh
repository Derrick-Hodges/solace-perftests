#!/bin/bash -x

if [ "$#" -ne 3 ]; then
	echo "	USAGE: $0 <vmr-ip> <xml-request-file> <keyword-filter>"
	echo ""
	echo ""
	exit 1
fi
ip=$1
file=$2
filter=$3

user=admin
pass=admin
url=http://192.168.56.104:8080/SEMP
# url=http://69.20.234.126:8034/SEMP

# cat $file 
curl -s $url -u $user:$pass -d @$file | grep "$filter" 
# | sed "s/<\/*$tag>//g" | sed "s/\&gt;/\>/g" | egrep -v '\#P2P|\#SEMP|\#LOG|\#MCAST'
