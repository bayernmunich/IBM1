#!/bin/sh
# Script runs for approximately 2 minutes.
# The parameter is the process ID of the App Server that has high CPU.


# Stat commands which run in the background over the 2 minute period.
/usr/bin/netstat -an > @netstat.out@ &
/usr/bin/vmstat 5 24 > @vmstat.out@ &
/usr/bin/prstat -mvcLn 40 -p @pid@ 5 50 > @prstat.out@ &
/usr/bin/mpstat 5 24 > @mpstat.out@ &

# lsof and proc tools executed once only, at the start of the 2 minutes.
/usr/local/bin/lsof -p @pid@ > @lsof.out@ 
/usr/bin/pfiles @pid@ > @pfiles.out@  
/usr/bin/pmap @pid@ > @pmap.out@ 
/usr/bin/pldd @pid@ > @pldd.out@ 

# Java thread dumps pstacks are taken over the course of the 2 minutes.
# May need to increase the resolution of this section (more pstacks, less
# time delay between them) if there are spikes in prstat output. 
/usr/bin/pstack @pid@ > @pstack1.out@  
kill -3 @pid@ 
sleep 60

/usr/bin/pstack @pid@ > @pstack2.out@
kill -3 @pid@
sleep 60

/usr/bin/pstack @pid@ > @pstack3.out@
kill -3 @pid@
