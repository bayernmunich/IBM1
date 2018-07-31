#!/bin/sh

# The parameter is the process ID of the App Server that has high CPU.

# rename parameter
PID=${1}
echo $PID
# collect some non-cpu information
echo "Collecting non cpu info"
env > env.out
ulimit > ulimit.out
uname -a > uname.out
swlist | grep -e QPK -e GOLD > swlist_gold.out
swlist | grep -i Java > swlist_java.out
swlist > swlist.out
swlist -l fileset -a state | grep -i java >swlist.out
ndd -get /dev/tcp tcp_conn_request_max > tcp_conn_request.out

# collect data during high cpu
echo "Collecting cpu info"
netstat p tcp > netstat_p_cpu.out
echo "after netstat"
swapinfo -tm > swapinfo_cpu.out
echo "after swap"
#vmstat 5 30> vmstat_cpu.out
#echo "after vmstat"
#top -s5 -d60 > top_cpu.out
#echo "after top" 
sar -o sarfile 2 15
echo "after sar"
sar -Af sarfile >sar_cpu.out
echo "Before Kill"
kill -3 $PID
echo "after 1st kill sleeping"
sleep 120
kill -3 $PID
echo "after 2nd kill sleeping"
sleep 120
kill -3 $PID 
sleep 120
echo "after 3rd kill sleeping"   
kill -s SIGQUIT $PID
