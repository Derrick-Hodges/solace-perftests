
if [ "$#" -ne 4 ]; then
	echo "	USAGE: $0 <rate> <size> <duration> <flows>"
	echo ""
	echo ""
	return
fi

aggrate=$1
size=$2
dur=$3
flows=$4
rate=$(( $aggrate / $flows ))
count=$(( $rate * $dur ))

echo "Publishing $flows streams at $rate each for $count messages"

half=$(( $flows/2 - 1 ))

proc=1
j=0
for i in `seq 0 $half`
do
	proc=$(( $proc + 1 ))
	# ssh $perfhost1 \
	# taskset -c $proc \
		$cmd -cip=$rtr1,$rtr2 \
		-epl="SOLCLIENT_SESSION_PROP_KEEP_ALIVE_INT_MS,300,SOLCLIENT_SESSION_PROP_KEEP_ALIVE_LIMIT,2,SESSION_CONNECT_RETRIES_PER_HOST,2,SESSION_CONNECT_TIMEOUT_MS,300" -rc=1000 \
		-cn=publisher${i}${j}_ \
		-l \
		-ptl=latency/topic/${i}${j} -mr=$rate -msa=$size -mn=$count &
done

proc=5
j=1
for i in `seq 0 $half`
do
	proc=$(( $proc + 1 ))
	# ssh $perfhost2 \
	# taskset -c $proc \
		$cmd -cip=$rtr1,$rtr2 \
		-epl="SOLCLIENT_SESSION_PROP_KEEP_ALIVE_INT_MS,300,SOLCLIENT_SESSION_PROP_KEEP_ALIVE_LIMIT,2,SESSION_CONNECT_RETRIES_PER_HOST,2,SESSION_CONNECT_TIMEOUT_MS,300" -rc=1000 \
		-cn=publisher${i}${j}_ \
		-l \
		-ptl=latency/topic/${i}${j} -mr=$rate -msa=$size -mn=$count &
done

