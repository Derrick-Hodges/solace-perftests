rtr1=192.168.56.104
rtr2=192.168.56.103

# perfhost1=192.168.130.94
perfhost1=127.0.0.1

cmd=../common/c/7.2.5.6/sdkperf_c_osx
killcmd=sdkperf_c_osx
# cmd=sdkperf_java.sh
# killcmd=java

gather() {
    pc=0
    for PC in `grep 'Total Messages transmitted                 = ' output/pub.out | awk '{print $NF}'`; do
	pc=$(( $pc + $PC ))
    done
    echo "Published: $pc"
    sc=0
    # Total Messages received across all clients = 15000
    for SC in `grep 'Total Messages received across all clients =' output/sub.out | awk '{print $NF}'`; do
	sc=$(( $sc + $SC ))
    done
    echo "Received: $sc"
}

gatherlat() {
    match=$1
    file=$2
    data=""
    n=0
    for D in `grep "$match" $file | awk '{print $(NF-1)}'`; do
	if [ $n -eq 0 ]; then
		data="$D"
	else
		data="$data, $D"
	fi
	n=$(( $n + 1 ))
    done
    echo $data
}

gatherlats() {
	echo "avg is `gatherlat Average output/sub.out`"
	echo "50% is `gatherlat 50th output/sub.out`"
	echo "95% is `gatherlat 95th output/sub.out`"
	echo "99% is `gatherlat 99th output/sub.out`"
	echo "99.9% is `gatherlat 99.9th output/sub.out`"
	echo "stdev is `gatherlat Deviation output/sub.out`"
}

zeroseq() {
	seq 0 $(( $1 - 1 ));
}

cleanup() {
    echo "Cleaning up"
    . ./scripts/publisher*_stop.sh >output/pubstop.out 2> output/pubstop.err
    sleep 1
    . ./scripts/subscriber_stop.sh >output/substop.out 2> output/substop.err
    sleep 5
    . ./scripts/*_stop.sh >output/laststop.out 2> output/laststop.err
    gather
    exit 0
}

setpath() {
    basedir=$1/common
    echo "setpath(basedir = $basedir)"
    export PATH="$basedir/c/7.2.5.6:$basedir/java/8.0.0.12:$basedir/mqtt/7.2.5.4:$basedir/rest/7.2.5.4:$PATH"
}

trap 'cleanup' SIGINT
