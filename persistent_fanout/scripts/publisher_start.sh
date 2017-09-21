
if [ "$#" -ne 3 ]; then
	echo "	USAGE: $0 <rate> <size> <duration"
	echo ""
	echo ""
	return
fi

rate=$1
msa=$2
dur=$3
count=$(( $rate * $dur ))

# ssh root@$perfhost1 \
# taskset -c 3,4  \
    $cmd -cip=tcps://$rtr1,tcps://$rtr2 -cn=publisher1_ \
    -epl="SOLCLIENT_SESSION_PROP_KEEP_ALIVE_INT_MS,300,SOLCLIENT_SESSION_PROP_KEEP_ALIVE_LIMIT,2,SESSION_CONNECT_RETRIES_PER_HOST,2,SESSION_CONNECT_TIMEOUT_MS,300" -rc=1000 \
    -cc=1 -apw=255 \
    -ptl=persistent/01 -mrt=max -mr=$rate -msa=100 -mt=persistent -mn=$count
