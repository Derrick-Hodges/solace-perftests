echo "subscriber start, cmd is $cmd"

flows=$1
perfhost=$perfhost1
proc=5

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
		-cn=subscriber${i}${j}_ \
		-l -lwu=10 -lb=4096 \
		-stl=latency/topic/${i}${j} &
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
		-cn=subscriber${i}${j}_ \
		-l -lwu=10 -lb=4096 \
		-stl=latency/topic/${i}${j} &
done
