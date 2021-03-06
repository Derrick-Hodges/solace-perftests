fanout=$1

half=$(( $fanout/2 ))
otherhalf=$(( $fanout - $half ))

echo "Running cmd $cmd for subscribers"

proc=1
j=0
for i in `zeroseq $half`
do
	proc=$(( $proc + 1 ))
	# ssh $perfhost1 \
	# taskset -c $proc \
		$cmd -cip=$rtr1,$rtr2 \
		-epl="SOLCLIENT_SESSION_PROP_KEEP_ALIVE_INT_MS,300,SOLCLIENT_SESSION_PROP_KEEP_ALIVE_LIMIT,2,SESSION_CONNECT_RETRIES_PER_HOST,2,SESSION_CONNECT_TIMEOUT_MS,300" -rc=1000 \
		-cn=subscriber${i}${j}_ \
		-stl=direct/\> &
done

proc=5
j=1
for i in `zeroseq $otherhalf`
do
	proc=$(( $proc + 1 ))
	# ssh $perfhost2 \
	# taskset -c $proc \
		$cmd -cip=$rtr1,$rtr2 \
		-epl="SOLCLIENT_SESSION_PROP_KEEP_ALIVE_INT_MS,300,SOLCLIENT_SESSION_PROP_KEEP_ALIVE_LIMIT,2,SESSION_CONNECT_RETRIES_PER_HOST,2,SESSION_CONNECT_TIMEOUT_MS,300" -rc=1000 \
		-cn=subscriber${i}${j}_ \
		-stl=direct/\> &
done
