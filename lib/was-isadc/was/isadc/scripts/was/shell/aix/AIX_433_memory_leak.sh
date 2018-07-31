#!/bin/ksh

#
# Author : Ben Hardill
# IBM Hursley eBit Java Tech. Center
#
# version: 0.1 
#
# description: Script for monitoring native memory usage on a AIX machine.
# It creates a number of files that hold svmon , vmstat and threads
# Run with no arguments for details
#


trap cleanup INT TERM

cleanup()
{
    kill -9 $vmstatpid
    kill -9 $svmonpid
    exit 0
}

helpOutput ()
{
	echo "Run as follows:"
    echo "AIX_memory_leak.sh -p <pid> -f <basefilename> -i <interval>"
    echo ""
    echo "Where <pid> is the process id to be profiled"
    echo "<basefilenam> is a path and identifier for the output"
    echo "<interval> is the time in seconds between each iteration"
    echo "eg:"
    echo "AIX_memory_leak.sh -p 123456 -f /logs/leak -i 120"
    echo ""
    echo "This will monitor process 123456 at 2 min intervals puting the output"
    echo "into the following files:"
    echo "/logs/leak.12345.svmon"
    echo "/logs/leak.12345.vmstat"
    echo "/logs/leak.12345.threads"
}


if [ $# -eq 0 ]; then
	helpOutput
	exit 1
fi

while getopts p:f:i:h c
do
	case $c in
		p)	if [ $OPTARG != "?" ] ; then
				pid=$OPTARG
			else
				echo "no PID given"
                exit 1
			fi;;
		f)	if [ $OPTARG != "?" ] ; then
				filename=$OPTARG
			else
				echo "no Output file given"
                exit 1
			fi;;
        i) if [ $OPTARG != "?" ] ; then
				interval=$OPTARG
			else
				echo "no interval given"
                exit 1
			fi;;
		h | ? | \?)	helpOutput
			exit 0;;
	esac
done
shift `expr $OPTIND - 1`

if [ -z $pid ]; then
    echo "No PID given"
    helpOutput
    exit 1
fi

if [ -z $interval ]; then
    echo "No interval given"
    helpOutput
    exit 1
fi

if [ -z $filename ]; then
    echo "No basename given"
    helpOutput
    exit 1
fi

echo "Process ID = " $pid
echo "file Basename = " $filename
echo "svmon data going to " $filename.$pid.svmon
date > $filename.$pid.svmon
svmon -i $interval -m -P $pid 2>&1 >>  $filename.$pid.svmon &
svmonpid=$!
echo "vmstat data going to " $filename.$pid.vmstat
date > $filename.$pid.vmstat
vmstat $interval 2>&1 >> $filename.$pid.vmstat &
vmstatpid=$!

echo "Thread info going to " $filename.$pid.threads
while true
do
  echo 'date' >>$filename.$pid.threads
  ps -mp $pid -o THREAD >> $filename.$pid.threads
  echo " -------------------------------------------------------" >>$filename.$pid.threads
  sleep $interval
done

