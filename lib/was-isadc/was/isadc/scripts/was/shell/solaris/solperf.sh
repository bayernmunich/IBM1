#!/bin/sh
###############################################################################
#
# This script is used to collect data for 
# 'MustGather: Performance, Hang or High CPU Issues on Solaris'
#
# ./solperf.sh [PID(s)_of_the_problematic_JVM(s)_separated_by_spaces]
#
SCRIPT_VERSION=2011.03.17
#
###############################################################################
#                        #
# Variables              #
#                        #
##########################
SCRIPT_SPAN=240          # How long the whole script should take. Default=240
THREAD_DUMP_INTERVAL=120 # How often thread dumps should be taken. Default=120  
VMSTAT_INTERVAL=5        # How often vmstat data should be taken. Default=5
PRSTATPID_INTERVAL=10    # How often prstatpid data should be taken. Default=10
PRSTATSYS_INTERVAL=10    # How often prstatsys data should be taken. Default=10
MPSTAT_INTERVAL=10       # How often mpstat data should be taken. Default=10
NUMBER_OF_THREADS=100    # How many threads prstatpid should track. Default=100
NUMBER_OF_PROCESSES=5    # How many processes prstatsys should track. Default=5
COLLECT_PSTACK=TRUE      # TRUE/FALSE. Default=TRUE
############################################################################### 
# * All values are in seconds.                                                  
# * All the 'INTERVAL' values should divide into the 'SCRIPT_SPAN' by a whole   
#   integer to obtain expected results.                                         
# * Setting any 'INTERVAL' too low (especially THREAD_DUMP) can result in data     
#   that may not be useful towards resolving the issue.  This becomes a problem 
#   when the process of collecting data obscures the real issue.                
################################################################################
if [ $# -eq 0 ]
then
echo "$0 : Unable to find required PID argument.  Please rerun the script as follows:"
echo "$0 : ./solperf.sh [PID(s)_of_the_problematic_JVM(s)_separated_by_spaces]"
exit 1
fi

# Create the screen.out and put the current date in it.
date > screen.out

# Starting up
echo `date` "MustGather>> solperf.sh script starting..." | tee -a screen.out
echo `date` "MustGather>> Script version:  $SCRIPT_VERSION." | tee -a screen.out

# Display the PIDs which have been input to the script
for i in $*
do
	echo `date` "MustGather>> PROBLEMATIC_PID is:  $i" | tee -a screen.out
done

# Display the parameters being used in this script
echo `date` "MustGather>> SCRIPT_SPAN = $SCRIPT_SPAN" | tee -a screen.out
echo `date` "MustGather>> THREAD_DUMP_INTERVAL = $THREAD_DUMP_INTERVAL" | tee -a screen.out
echo `date` "MustGather>> VMSTAT_INTERVAL = $VMSTAT_INTERVAL" | tee -a screen.out
echo `date` "MustGather>> PRSTATPID_INTERVAL = $PRSTATPID_INTERVAL" | tee -a screen.out
echo `date` "MustGather>> PRSTATSYS_INTERVAL = $PRSTATSYS_INTERVAL" | tee -a screen.out
echo `date` "MustGather>> MPSTAT_INTERVAL = $MPSTAT_INTERVAL" | tee -a screen.out
echo `date` "MustGather>> NUMBER_OF_THREADS = $NUMBER_OF_THREADS" | tee -a screen.out
echo `date` "MustGather>> NUMBER_OF_PROCESSES = $NUMBER_OF_PROCESSES" | tee -a screen.out
echo `date` "MustGather>> COLLECT_PSTACK = $COLLECT_PSTACK" | tee -a screen.out
################################################################################
#                       # 
# Start collection of:  # 
#  * whoami             #
#  * pspid              #
#  * pssys              # 
#                       # 
######################### 
# Collect the user currently executing the script
echo `date` "MustGather>> Collecting user authority data..." | tee -a screen.out
date > whoami.out
whoami >> whoami.out
echo `date` "MustGather>> Collection of user authority data complete." | tee -a screen.out

# Collect the pssys and pspid data.
echo `date` "MustGather>> Collecting pssys and pspid data..." | tee -a screen.out
date > pssys.out
/usr/ucb/ps -auxwww >> pssys.out 2>&1
echo `date` "MustGather>> Collection of pssys data complete." | tee -a screen.out
for i in $*
do
	date > pspid.$i.out
	echo >> pspid.$i.out
	echo "Collected against PID $i." >> pspid.$i.out
	echo >> pspid.$i.out
  /usr/ucb/ps -auxewww $i >> pspid.$i.out
	echo `date` "MustGather>> Collection of pspid data for PID $i complete." | tee -a screen.out
done
echo `date` "MustGather>> Completed collection of pssys and pspid data." | tee -a screen.out
################################################################################
#                       # 
# Start collection of:  # 
#  * vmstat             # 
#  * mpstat             # 
#  * prstatsys          #
#  * prstatpid          #
#                       # 
######################### 
# Start the colletion of vmstat data.
# It runs in the background so that other tasks can be completed while this runs.
echo `date` "MustGather>> Starting collection of vmstat data..." | tee -a screen.out
date >> vmstat.out
/usr/bin/vmstat $VMSTAT_INTERVAL `expr $SCRIPT_SPAN / $VMSTAT_INTERVAL + 1` >> vmstat.out 2>&1 &
echo `date` "MustGather>> Collection of vmstat data started." | tee -a screen.out

# Start the colletion of mpstat data.
# It runs in the background so that other tasks can be completed while this runs.
echo `date` "MustGather>> Starting collection of mpstat data..." | tee -a screen.out
date > mpstat.out
/usr/bin/mpstat $MPSTAT_INTERVAL `expr $SCRIPT_SPAN / $MPSTAT_INTERVAL + 1` >> mpstat.out 2>&1 &
echo `date` "MustGather>> Collection of mpstat data started." | tee -a screen.out

# Start the colletion of prstatsys data.
# It runs in the background so that other tasks can be completed while this runs.
echo `date` "MustGather>> Starting collection of prstatsys data..." | tee -a screen.out
date > prstatsys.out
/usr/bin/prstat -n $NUMBER_OF_PROCESSES $PRSTATSYS_INTERVAL `expr $SCRIPT_SPAN / $PRSTATSYS_INTERVAL + 1` >> prstatsys.out 2>&1 &
echo `date` "MustGather>> Collection of prstatpid data started." | tee -a screen.out

# Start the colletion of prstatpid data, one for each PID.
# It runs in the background so that other tasks can be completed while this runs.
for i in $*
do
	echo `date` "MustGather>> Starting collection of prstatpid data for PID $i..." | tee -a screen.out
	date > prstatpid.$i.out
	echo >> prstatpid.$i.out
	echo "Collected against PID $i." >> prstatpid.$i.out
	echo >> prstatpid.$i.out
	/usr/bin/prstat -mvcLn $NUMBER_OF_THREADS -p $i $PRSTATPID_INTERVAL `expr $SCRIPT_SPAN / $PRSTATPID_INTERVAL + 1` >> prstatpid.$i.out 2>&1 &
	echo `date` "MustGather>> Collection of prstatpid data for PID $i started." | tee -a screen.out
done
################################################################################
#                       # 
# Start collection of:  # 
#  * thread dumps       #
#                       # 
######################### 
# Start collection of thread dumps.
# Loop the appropriate number of times, pausing for the given amount of time, and iterate through each supplied PID.
n=1
m=`expr $SCRIPT_SPAN / $THREAD_DUMP_INTERVAL`
while [ $n -le $m ]
do
	echo `date` "MustGather>> Collecting thread dumps..." | tee -a screen.out
	for i in $*
	do
		kill -3 $i >> screen.out 2>&1
		echo `date` "MustGather>> Collected a thread dump for PID $i." | tee -a screen.out
    
    if [ $COLLECT_PSTACK = "TRUE" ]
    then
      echo `date` "MustGather>> Collecting pstack data against PID $i..." | tee -a screen.out
      date > pstack-$n.$i.out
      echo >> pstack-$n.$i.out
      echo "Collected against PID $i." >> pstack-$n.$i.out
      echo >> pstack-$n.$i.out
      /usr/bin/pstack $i >> pstack-$n.$i.out 2>&1
      echo `date` "MustGather>> Completed collection of pstack data against PID $i." | tee -a screen.out
    fi
	done
	echo `date` "MustGather>> Continuing to collect data for $THREAD_DUMP_INTERVAL seconds..." | tee -a screen.out
	sleep $THREAD_DUMP_INTERVAL
	n=`expr $n + 1`
done

# Collect the final thread dump(s).
echo `date` "MustGather>> Collecting final thread dump..." | tee -a screen.out
for i in $*
do
	kill -3 $i >> screen.out 2>&1
	echo `date` "MustGather>> Collected the final thread dump for PID $i." | tee -a screen.out
	
	if [ $COLLECT_PSTACK = "TRUE" ]
	then
	  echo `date` "MustGather>> Collecting the final pstack against PID $i..." | tee -a screen.out
    date > pstack-$n.$i.out
    echo >> pstack-$n.$i.out
    echo "Collected against PID $i." >> pstack-$n.$i.out
    echo >> pstack-$n.$i.out
    /usr/bin/pstack $i >> pstack-$n.$i.out 2>&1
    echo `date` "MustGather>> Completed the collection of the final pstack data against PID $i." | tee -a screen.out
	fi
done
################################################################################
#                       # 
# Other data collection # 
#                       # 
######################### 
# Gather environment information.
echo `date` "MustGather>> Collecting environment information.  This may take a few moments." | tee -a screen.out

env > env.out 2>&1
ulimit -a > ulimit.out 2>&1
uname -a > uname.out 2>&1
showrev -p > showrev.out 2>&1
pkginfo -l > pkginfo.out 2>&1
/usr/bin/netstat -an > netstat.out 2>&1
df -hk > df-hk.out 2>&1

for i in $*
do
	date > lsof.$i.out
	date > pfiles.$i.out
	date > pmap.$i.out
	date > pldd.$i.out
	
	echo >> lsof.$i.out
	echo >> pfiles.$i.out
	echo >> pmap.$i.out
	echo >> pldd.$i.out
	
	echo "Collected against PID $i." >> lsof.$i.out
	echo "Collected against PID $i." >> pfiles.$i.out
	echo "Collected against PID $i." >> pmap.$i.out
	echo "Collected against PID $i." >> pldd.$i.out

	echo >> lsof.$i.out
	echo >> pfiles.$i.out
	echo >> pmap.$i.out
	echo >> pldd.$i.out
	
	/usr/local/bin/lsof -p $i >> lsof.$i.out 2>&1
	/usr/bin/pfiles $i >> pfiles.$i.out 2>&1
	/usr/bin/pmap $i >> pmap.$i.out 2>&1
	/usr/bin/pldd $i >> pldd.$i.out 2>&1
done

echo `date` "MustGather>> Completed collection of environment information." | tee -a screen.out
################################################################################
#                       #
# Compress & Cleanup    #
#                       #
#########################
# Brief pause to make sure all data is collected.
echo `date` "MustGather>> Preparing for packaging and cleanup..." | tee -a screen.out
sleep 5

# Build a string to contain all the file names
if [ $COLLECT_PSTACK = "TRUE" ]
  then
    FILES_STRING="env.out ulimit.out uname.out showrev.out pkginfo.out netstat.out vmstat.out prstatsys.out mpstat.out pssys.out screen.out whoami.out df-hk.out prstatpid.*.out lsof.*.out pfiles.*.out pmap.*.out pldd.*.out pstack*.out pspid.*.out"
  else
    FILES_STRING="env.out ulimit.out uname.out showrev.out pkginfo.out netstat.out vmstat.out prstatsys.out mpstat.out pssys.out screen.out whoami.out df-hk.out prstatpid.*.out lsof.*.out pfiles.*.out pmap.*.out pldd.*.out pspid.*.out"
fi

# Compress all the files that we have just created.
echo `date` "MustGather>> Compress output files into solperf_RESULTS.tar.gz"
tar -cvf solperf_RESULTS.tar $FILES_STRING
gzip solperf_RESULTS.tar

# Remove .out files that have just been tar.gz'd together
echo `date` "MustGather>> Remove the temporary output files as they have now been added to the solperf_RESULTS.tar.gz file."
rm $FILES_STRING

echo `date` "MustGather>> Output files removed."
echo `date` "MustGather>> solperf.sh script complete."
echo
echo `date` "MustGather>> Output files are contained within ---->   solperf_RESULTS.tar.gz.   <----"
echo `date` "MustGather>> The thread dumps that were created are NOT included in the solperf_RESULTS.tar.gz."
echo `date` "MustGather>> By default the thread dumps should be printed to the native_stdout.log"
echo `date` "MustGather>> Be sure to submit solperf_RESULTS.tar.gz, the server logs, and the server.xml as noted in the MustGather."
################################################################################
