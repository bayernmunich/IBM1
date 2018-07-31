#!/bin/sh
############################################
# This script is to collect performance information for issues that occur on HPUX
############################################

# The parameter is the process ID of the App Server that has high CPU or hung threads.

# rename parameter
PID=@pid@
echo "The supplied process ID is $PID"

############################################
# collect some non-cpu information

echo "MustGather: Collecting System Information"
date > env.out
env >> env.out
echo "MustGather: Finished creating the file env.out"

date > ulimit.out
ulimit >> ulimit.out
echo "MustGather: Finished creating the file ulimit.out"

date > uname.out
uname -a >> uname.out
echo "MustGather: Finished creating the file uname.out"

echo "MustGather: Creating the following files: swlist.out swlist_gold.out, swlist_java.out, swlist_full.out"
swlist | grep -e QPK -e GOLD > swlist_gold.out
swlist | grep -i Java > swlist_java.out
swlist > swlist_full.out
swlist -l fileset -a state | grep -i java >swlist.out
echo "MustGather: Finished creating the following files: swlist.out swlist_gold.out, swlist_java.out, swlist_full.out"

################################################

echo "MustGather: Creating the following files: tcp_conn_request.out, netstat.out, swapinfo.out"
date > tcp_conn_request.out
ndd -get /dev/tcp tcp_conn_request_max >> tcp_conn_request.out

date > netstat.out
netstat -p tcp >> netstat.out

date > swapinfo.out
swapinfo -tm >> swapinfo.out
echo "MustGather: Finished creating the following files: tcp_conn_request.out, netstat.out, swapinfo.out"

################################################

#Three thead dumps are produced
echo "MustGather: Performing kill -3 three times."
kill -3 $PID
echo "MustGather: 1st kill -3 finished.  Sleeping for 2 minutes"

#Vmstat will take about 2 minutes to complete
echo "MustGather: Creating the following file: vmstat.out"
date > vmstat.out
vmstat 5 24 >> vmstat.out  
echo "MustGather: Finished creating the following file: vmstat.out"

kill -3 $PID
echo "MustGather: 2nd kill -3 finished.  Sleeping for 2 minutes"
sleep 120
kill -3 $PID
echo "MustGather: Final kill -3 finished."
echo ""
echo "MustGather has finished, please follow the following instructions:"
echo "If you are running hpux_glance.sh, please wait until that script finishes."
echo "Please compress all files with the *.out extension that were generated and send to support."
echo ""
echo "Thread dumps are produced in the native_stdout.log.  All server logs are found in the <profile_root>/logs/<server_name>/"

