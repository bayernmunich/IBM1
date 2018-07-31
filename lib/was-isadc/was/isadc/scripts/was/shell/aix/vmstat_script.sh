#!/bin/ksh

#VMSTAT_LOG=$1
# Adjust LIMIT & SLEEP_TIME to suite your purpose/need.
# There are 288 5 minute intervals in 1 day
LIMIT=500

#sleep for 5 minutes
SLEEP_TIME=300 
while true 
do
  i=0
  echo >@VMSTAT_LOG@
  while [ "$i" -le $LIMIT ]
  do
    date >>@VMSTAT_LOG@
    vmstat 5 12 >>@VMSTAT_LOG@
    echo >>@VMSTAT_LOG@
    i=`expr $i + 1`
    sleep $SLEEP_TIME
  done
done
