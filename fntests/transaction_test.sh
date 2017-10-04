#!/bin/bash
cd `dirname $0`

if [ "$#" -ne 4 ]; then
	echo "	USAGE: $0 <rate> <size> <duration> <msgs-per-tx>"
	echo ""
	echo ""
	exit 1
fi
rate=$1
size=$2
dur=$3
txsz=$4
count=$(( $rate * $dur ))

mkdir -p output
. ../common/shared.sh
setpath ..

# SUBSCRIBER START
$cmd -cip=$rtr1,$rtr2 \
	-epl="SOLCLIENT_SESSION_PROP_KEEP_ALIVE_INT_MS,300,SOLCLIENT_SESSION_PROP_KEEP_ALIVE_LIMIT,2,SESSION_CONNECT_RETRIES_PER_HOST,2,SESSION_CONNECT_TIMEOUT_MS,300" -rc=1000 \
	-cn=subscriber \
	-sql=txtest -pe -ats=$txsz >output/sub.out 2>output/sub.err&
echo $! > output/sub.pid

read -p "Subscribers started; press enter to continue"

# PUBLISHER START
$cmd -cip=$rtr1,$rtr2 \
	-epl="SOLCLIENT_SESSION_PROP_KEEP_ALIVE_INT_MS,300,SOLCLIENT_SESSION_PROP_KEEP_ALIVE_LIMIT,2,SESSION_CONNECT_RETRIES_PER_HOST,2,SESSION_CONNECT_TIMEOUT_MS,300" -rc=1000 \
	-cn=publisher \
	-pql=txtest -mrt=max -mr=$rate -msa=$size -mn=$count >output/pub.out 2>output/pub.err

../common/sempget.sh $rtr1 show-client-trans-req.xml '<'

kill -INT `cat output/sub.pid`

sleep 3

gather



