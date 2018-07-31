###############################################################################
#
# This script is used to collect data for 
# 'MustGather: Performance, Hang or High CPU Issues on Linux'
#
# ./linperf.sh [PID(s)_of_the_problematic_JVM(s)_separated_by_spaces]
#
SCRIPT_VERSION=2011.05.03
#
###############################################################################
#                        #
# Variables              # 
#                        #
##########################
SCRIPT_SPAN=240          # How long the whole script should take. Default=240
JAVACORE_INTERVAL=120    # How often javacores should be taken. Default=120
TOP_INTERVAL=60          # How often top data should be taken. Default=60
TOP_DASH_H_INTERVAL=5    # How often top dash H data should be taken. Default=5
VMSTAT_INTERVAL=5        # How often vmstat data should be taken. Default=5
###############################################################################
# * All values are in seconds.
# * All the 'INTERVAL' values should divide into the 'SCRIPT_SPAN' by a whole 
#   integer to obtain expected results.
# * Setting any 'INTERVAL' too low (especially JAVACORE) can result in data
#   that may not be useful towards resolving the issue.  This becomes a problem 
#   when the process of collecting data obscures the real issue.
###############################################################################
if [ $# -eq 0 ]
then
echo "$0 : Unable to find required PID argument.  Please rerun the script as follows:"
echo "$0 : ./linperf.sh [PID(s)_of_the_problematic_JVM(s)_separated_by_spaces]"
exit 1
fi
##########################
# Create output files    #
#                        #
##########################
# Create the screen.out and put the current date in it.
echo > screen.out
date >> screen.out

# Starting up
echo $(date) "MustGather>> linperf.sh script starting..." | tee -a screen.out
echo $(date) "MustGather>> Script version:  $SCRIPT_VERSION." | tee -a screen.out

# Display the PIDs which have been input to the script
for i in $*
do
	echo $(date) "MustGather>> PROBLEMATIC_PID is:  $i" | tee -a screen.out
done

# Display the being used in this script
echo $(date) "MustGather>> SCRIPT_SPAN = $SCRIPT_SPAN" | tee -a screen.out
echo $(date) "MustGather>> JAVACORE_INTERVAL = $JAVACORE_INTERVAL" | tee -a screen.out
echo $(date) "MustGather>> TOP_INTERVAL = $TOP_INTERVAL" | tee -a screen.out
echo $(date) "MustGather>> TOP_DASH_H_INTERVAL = $TOP_DASH_H_INTERVAL" | tee -a screen.out
echo $(date) "MustGather>> VMSTAT_INTERVAL = $VMSTAT_INTERVAL" | tee -a screen.out

# Collect the user currently executing the script
echo $(date) "MustGather>> Collecting user authority data..." | tee -a screen.out
date > whoami.out
whoami >> whoami.out 2>&1
echo $(date) "MustGather>> Collection of user authority data complete." | tee -a screen.out

# Create some of the output files with a blank line at top
echo $(date) "MustGather>> Creating output files..." | tee -a screen.out
echo > vmstat.out
echo > ps.out
echo > top.out
echo $(date) "MustGather>> Output files created:" | tee -a screen.out
echo $(date) "MustGather>>      vmstat.out" | tee -a screen.out
echo $(date) "MustGather>>      ps.out" | tee -a screen.out
echo $(date) "MustGather>>      top.out" | tee -a screen.out
for i in $*
do
	echo > topdashH.$i.out
	echo $(date) "MustGather>>      topdashH.$i.out" | tee -a screen.out
done

###############################################################################
#                       #
# Start collection of:  #
#  * top                #
#  * top dash H         #
#  * vmstat             #
#                       #
#########################
# Start the collection of top data.
# It runs in the background so that other tasks can be completed while this runs.
echo $(date) "MustGather>> Starting collection of top data..." | tee -a screen.out
date >> top.out
echo >> top.out
top -bc -d $TOP_INTERVAL -n `expr $SCRIPT_SPAN / $TOP_INTERVAL + 1` >> top.out 2>&1 &
echo $(date) "MustGather>> Collection of top data started." | tee -a screen.out

# Start the collection of top dash H data.
# It runs in the background so that other tasks can be completed while this runs.
echo $(date) "MustGather>> Starting collection of top dash H data..." | tee -a screen.out
for i in $*
do
	date >> topdashH.$i.out
	echo >> topdashH.$i.out
	echo "Collected against PID $i." >> topdashH.$i.out
	echo >> topdashH.$i.out
	top -bH -d $TOP_DASH_H_INTERVAL -n `expr $SCRIPT_SPAN / $TOP_DASH_H_INTERVAL + 1` -p $i >> topdashH.$i.out 2>&1 &
	echo $(date) "MustGather>> Collection of top dash H data started for PID $i." | tee -a screen.out
done

# Start the collection of vmstat data.
# It runs in the background so that other tasks can be completed while this runs.
echo $(date) "MustGather>> Starting collection of vmstat data..." | tee -a screen.out
date >> vmstat.out
vmstat $VMSTAT_INTERVAL `expr $SCRIPT_SPAN / $VMSTAT_INTERVAL + 1` >> vmstat.out 2>&1 &
echo $(date) "MustGather>> Collection of vmstat data started." | tee -a screen.out

################################################################################
#                       #
# Start collection of:  #
#  * javacores          #
#  * ps                 #
#                       #
#########################
# Initialize some loop variables
n=1
m=`expr $SCRIPT_SPAN / $JAVACORE_INTERVAL`

# Loop
while [ $n -le $m ]
do
	
	# Collect a ps snapshot: date at the top, data, and then a blank line
	echo $(date) "MustGather>> Collecting a ps snapshot..." | tee -a screen.out
	date >> ps.out
	ps -eLf >> ps.out 2>&1
	echo >> ps.out
	echo $(date) "MustGather>> Collected a ps snapshot." | tee -a screen.out
	
	# Collect a javacore against the problematic pid (passed in by the user)
	# Javacores are output to the working directory of the JVM; in most cases this is the <profile_root>
	echo $(date) "MustGather>> Collecting a javacore..." | tee -a screen.out
	for i in $*
	do
		kill -3 $i >> screen.out 2>&1
		echo $(date) "MustGather>> Collected a javacore for PID $i." | tee -a screen.out
	done
	
	# Pause for JAVACORE_INTERVAL seconds.
	echo $(date) "MustGather>> Continuing to collect data for $JAVACORE_INTERVAL seconds..." | tee -a screen.out
	sleep $JAVACORE_INTERVAL
	
	# Increment counter
	n=`expr $n + 1`

done

# Collect a final javacore and ps snapshot.
echo $(date) "MustGather>> Collecting the final ps snapshot..." | tee -a screen.out
date >> ps.out
ps -eLf >> ps.out 2>&1
echo >> ps.out
echo $(date) "MustGather>> Collected the final ps snapshot." | tee -a screen.out

echo $(date) "MustGather>> Collecting the final javacore..." | tee -a screen.out
for i in $*
do
	kill -3 $i >> screen.out 2>&1
	echo $(date) "MustGather>> Collected the final javacore for PID $i." | tee -a screen.out
done
################################################################################
#                       #
# Other data collection #
#                       #
#########################
echo $(date) "MustGather>> Collecting other data.  This may take a few moments..." | tee -a screen.out

dmesg | grep -i virtual > dmesg.out 2>&1
df -hk > df-hk.out 2>&1

echo $(date) "MustGather>> Collected other data." | tee -a screen.out
################################################################################
#                       #
# Compress & Cleanup    #
#                       #
#########################
# Brief pause to make sure all data is collected.
echo $(date) "MustGather>> Preparing for packaging and cleanup..." | tee -a screen.out
sleep 5

# Tar the output files together
echo $(date) "MustGather>> Compressing output files into linperf_RESULTS.tar.gz" | tee -a screen.out

# Build a string to contain all the file names
FILES_STRING="vmstat.out ps.out top.out screen.out dmesg.out whoami.out df-hk.out"
for i in $*
do
	TEMP_STRING=" topdashH.$i.out"
	FILES_STRING="$FILES_STRING $TEMP_STRING"
done

tar -cvf linperf_RESULTS.tar $FILES_STRING

# GZip the tar file to create linperf_RESULTS.tar.gz
gzip linperf_RESULTS.tar

# Clean up the output files now that they have been tar/gz'd.
echo $(date) "MustGather>> Cleaning up..."
rm $FILES_STRING

echo $(date) "MustGather>> Clean up complete."
echo $(date) "MustGather>> linperf.sh script complete."
echo
echo $(date) "MustGather>> Output files are contained within ---->   linperf_RESULTS.tar.gz.   <----"
echo $(date) "MustGather>> The javacores that were created are NOT included in the linperf_RESULTS.tar.gz."
echo $(date) "MustGather>> Check the <profile_root> for the javacores."
echo $(date) "MustGather>> Be sure to submit linperf_RESULTS.tar.gz, the javacores, and the server logs as noted in the MustGather."
################################################################################
