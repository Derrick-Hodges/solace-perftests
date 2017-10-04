#!/bin/bash
cd `dirname $0`

if [ "$#" -ne 4 ]; then
	echo "	USAGE: $0 <rate> <size> <duration> <lb-consumers>"
	echo ""
	echo ""
	exit 1
fi
rate=$1
size=$2
dur=$3
cons=$4
count=$(( $rate * $dur ))

mkdir -p output
. ../common/shared.sh
setpath ..

# SUBSCRIBER START
rm -f output/sub.*
for i in `zeroseq $cons`
do
$cmd -cip=$rtr1,$rtr2 \
	-epl="SOLCLIENT_SESSION_PROP_KEEP_ALIVE_INT_MS,300,SOLCLIENT_SESSION_PROP_KEEP_ALIVE_LIMIT,2,SESSION_CONNECT_RETRIES_PER_HOST,2,SESSION_CONNECT_TIMEOUT_MS,300" -rc=1000 \
	-cn=subscriber$i \
	-sql=competingconsumers -pe -pep=d -pea=0 >>output/sub.out 2>>output/sub.err&
	echo $! >> output/sub.pid
done


read -p "Subscribers started; press enter to continue"


# PUBLISHER START
$cmd -cip=$rtr1,$rtr2 \
	-epl="SOLCLIENT_SESSION_PROP_KEEP_ALIVE_INT_MS,300,SOLCLIENT_SESSION_PROP_KEEP_ALIVE_LIMIT,2,SESSION_CONNECT_RETRIES_PER_HOST,2,SESSION_CONNECT_TIMEOUT_MS,300" -rc=1000 \
	-cn=publisher \
	-pql=competingconsumers -mrt=max -mr=$rate -msa=$size -mn=$count >output/pub.out 2>output/pub.err

kill -INT `cat output/sub.pid`

sleep 3

gather



