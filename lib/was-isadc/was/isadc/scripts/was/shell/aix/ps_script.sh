#!/bin/ksh

#PS_LOG=$1
# Adjust LIMIT & SLEEP_TIME to suite your purpose/need.
# There are 288 5 minute intervals in 1 day
LIMIT=500

#sleep for 5 minutes
SLEEP_TIME=300 
while true 
do
  i=0
  echo >@PS_LOG@
  while [ "$i" -le $LIMIT ]
  do
    date >>@PS_LOG@
    ps avwwwg >>@PS_LOG@
    echo >>@PS_LOG@
    i=`expr $i + 1`
    sleep $SLEEP_TIME
  done
done
