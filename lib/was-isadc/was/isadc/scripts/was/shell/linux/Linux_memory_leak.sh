log=<log file name>
pid=<PID>
#!/bin/ksh
while true
do
  echo `date` >>$log
  vmstat 1 3 >>$log
  swapon -s >>$log
  ps aux >>$log
  cat /proc/meminfo >> $log
  ps -mp $pid -o THREAD >> $log
  cat /proc/$pid/maps
  echo " --------------------" >>$log
  sleep 600
done
