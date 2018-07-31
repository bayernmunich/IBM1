#!/bin/sh

# ===========================================================================
# Licensed Materials - Property of IBM
# "Restricted Materials of IBM"
#
# Author : Bharat Devdas
# email : bhdevdas@in.ibm.com
#
# Version 1.0 - First go.
#
# ===========================================================================

# Default Variable Values
THRESH=0					# By default all the threads consuming more than 0% CPU are selected.
AOS=/tmp/aos.$$					# Temporary file created by the script. Deleted after the useage.
DISPLAY=OFF					# The output shall be displayed on the screen by default.
GLANCE=@glance.path@		# Path of the glance executable.
JAVA_ONLY=1					# Show only java threads information.
AND_STMT=""					# Option to select only java threads.
FILEN=./hpux_glance.out			# File into which the output is to be logged.
INT=25						# Intervals for glance to record the readings.
ITR=13						# Number of iterations glance has to run.

# Script Functions
Usage()
{  
	echo "Usage $0 [-h][-g Path to Glance][-j|-J][-i No. of iterations][-c %CPU Threshold][-f Display frequency][-s ON|OFF]\n"
	exit 1
}

Print_help_screen()
{
	clear
	echo "#################################################################"
	echo "#  Help for hpux_highcpu.sh                                     #"
	echo "#################################################################"
	echo "# Options :                                                     #"
	echo "# ---------                                                     #"
	echo "# j - Print only java threads i.e. threads executing under java #"
	echo "#     processes.  Use -J to show all threads.                   #"
	echo "# a - Print all threads subject to usage of -c                  #"
	echo "# c - Set % CPU threshold. Defaults to 0% [Range 1-99]          #"
	echo "#     Used to set the threshold of %CPU above which the script  #"
	echo "#     will display threads.                                     #"
	echo "# s - Screen display ON/OFF. If ON, output is displayed on      #"
	echo "#     stdout and the same will be written to the output file.   #"
	echo "#     If OFF, the default, output is sent to the output file    #"
	echo "#     './hpux_highcpu.out'.                                     #"
	echo "# f - Frequency of display. The output will be displayed every  #"
	echo "#     n seconds.                                                #"
	echo "# i - Allows you to limit the number of intervals that Glance   #"
	echo "#     will run. Glance will execute for the number of           #"
	echo "#     iterations specified  and  then  terminate.               #"
	echo "# g - Give the full path and file name of the glance            #"
	echo "#     executable.  Default location is /opt/perf/bin/glance     #"
	echo "#                                                               #"
	echo "# Examples:                                                     #"
	echo "# --------                                                      #"
	echo "# 1. Display all java threads, no threshold, 5 iterations.      #"
	echo "#     $ hpux_highcpu.sh -j -i 5                                 #" 
	echo "# 2. Display all system threads consuming more than 60% CPU.    #"
	echo "#     $ hpux_highcpu.sh -J -c 60                                #"
	echo "# 3. Display all system threads, no limits whatsoever.          #"
	echo "#     $ hpux_highcpu.sh -J                                      #"
	echo "# 4. Display all java threads consuming more than 90% CPU.      #"
	echo "#     $ hpux_highcpu.sh -j -c 90                                #"
	echo "#                                                               #"
	echo "#                                                               #"
	echo "#################################################################"

	exit 0
}

set_command()
{
	CMD_EXEC="$GLANCE -j $INT -aos $AOS -iterations $ITR"
}

printaos()
{
echo "# Ignore the first interval as startup overhead may skew results:\n\
alwaysprint = 1\n\
syscallthreshold = syscallthreshold\n\
if syscallthreshold == 0 then\n\
	syscallthreshold = 10\n\
initiallost = initiallost\n\
if initiallost == 0 then\n\
	initiallost = gbl_lost_mi_trace_buffers\n\
lostbufs = lostbufs\n\
notfirstinterval = notfirstinterval\n\
if (notfirstinterval == 1) then {\n\
	if (alwaysprint <> 0)\n\
	or\n\
	(gbl_syscall_rate > syscallthreshold)\n\
	or\n\
	((lostbufs < gbl_lost_mi_trace_buffers) and\n\
	(initiallost < gbl_lost_mi_trace_buffers))\n\
	or\n\
	(gbl_mi_lost_proc > 0)\n\
	then {\n\n\
	print \"-----\", gbl_stattime\n\
	print \"gbl cpu utilization =\", gbl_cpu_total_util|7|0, \"\%\"\n\
	print \"alive processes     =\", gbl_alive_proc|7|0\n\
	print \"active processes    =\", gbl_active_proc|7|0\n\
	print \"priority queue      =\", gbl_pri_queue|7|1\n\
	print \"run queue           =\", gbl_run_queue|7|1\n\
	print \"context switch rate =\", gbl_cswitch_rate|7|0\n\
	print \"network packet rate =\", gbl_net_packet_rate|7|1\n\
	print \"disk phys io rate   =\", gbl_disk_phys_io_rate|7|1\n\
	print \"memory pageout rate =\", gbl_mem_pageout_rate|7|1\n\
	\n\
# Check for lost MI buffers:\n\
	lostbufs = gbl_lost_mi_trace_buffers\n\
	if lostbufs > 10 then\n\
		print \"total mi lost buffers =\", lostbufs|7|0\n\
	if lostbufs > 1000 then\n\
		print \"(recommend restart of perftools: midaemon -T; mwa restart)\"\n\
	\n\
	if gbl_mi_lost_proc > 0 then\n\
		print \"new mi lost processes =\", gbl_mi_lost_proc|7|0\n\
	\n\
		print \"system call rate    =\", gbl_syscall_rate|7|0\n\
# Reset syscall threshold if high water mark seen:\n\
	if gbl_syscall_rate > syscallthreshold then\n\
		syscallthreshold = gbl_syscall_rate\n\
	\n\
# Calculate fork rate and keep track of most frequent syscall:\n\
	forkrate = 0\n\
	highestrate = 0\n\
	systemcall loop {\n\
	if ((syscall_call_name == \"fork\") or (syscall_call_name == \"vfork\"))\n\
	and\n\
	(syscall_call_rate > 1) then\n\
# Note that fork syscalls are double counted as instrumented at end: \n\
	forkrate = forkrate + syscall_call_rate / 2\n\
	if syscall_call_rate > highestrate then {\n\
		highestrate = syscall_call_rate\n\
		highestcall = syscall_call_name\n\
	}\n\
}\n\
	print \"process fork rate   =\", forkrate|7|1\n\
	comprate = gbl_completed_proc / gbl_interval\n\
	print \"proc completion rate=\", comprate|7|1\n\
	print \"highest syscall rate=\",highestrate|7|0,\n\
	\" for system call \", highestcall|12 \n\
	\n\
# Show ARM transaction data..\n\
	comprate = 0\n\
	totaltrans = 0\n\
	tt loop\n\
	totaltrans = totaltrans + tt_count\n\
	if totaltrans > 0 then\n\
		comprate = totaltrans / gbl_interval\n\
	print \"arm compl tran rate =\", comprate|7|1\n\
	\n\
# Print out interesting active threads, including ones running with\n\
# realtime (rtprio and posix) priorities and ones consuming significant\n\
# system cpu..\n\
	headers_printed = 0\n\
	thread loop {\n\
		if $AND_STMT ((thread_cpu_syscall_util > 20) or\n\
			(thread_cpu_total_util > $THRESH)) then {\n\
			if headers_printed == 0 then {\n\
				print \" \"\n\
				print \"Process name   pid     ktid     pri    cpu%    scall%\",\n\
				\" dsptch cpu-swtch     shell-cmd\"\n\
				print \"------------   ---     ----     ---    ----    ------\",\n\
				\" ------ ---------     ---------\"\n\
				headers_printed = 1\n\
			}\n\
			print thread_proc_name|7, \"  \",\n\
			thread_proc_id, \" \", thread_thread_id|8 , \" \",\n\
			thread_pri|6|0, \" \", thread_cpu_total_util|7|0, \" \",\n\
			thread_cpu_syscall_util|7|0, \" \",\n\
			thread_dispatch|6|0, \" \", thread_cpu_switches|9|0, \"       \", thread_proc_cmd|30\n\
		}\n\
	}\n\
	print \" \"\n\n\
}# end print condition true\n\
else {\n\
	print \".....\", gbl_stattime\n\
}# end else no printable condition this interval\n\
\n\
}# end of \"not first interval\" condition\n\
else {\n\
	\n\
	exec \"echo \\\"Thread activity adviser script started \`date\` on \`uname -n\`\\\"\"\n\
	print \"  \"\n\
	exec \"echo \\\"uptime at \`uptime\`\\\"\"\n\
	print \"  \"\n\
	exec  \"echo \\\"\`ps -f | head -1\` \\\" \"\n\
	exec  \"echo \\\"\`ps -ef | grep midaemon | grep -v grep\` \\\" \"\n\
	print \"  \"\n\
	exec \"echo \\\"version: \`what /opt/perf/bin/glance | cut -c 1-50\`\\\"\"\n\
	print \"  \"\n\
	print \"system model   = \", gbl_machine_model\n\
	print \"os release     = \", gbl_osrelease\n\
	print \"num cpus       = \", gbl_num_cpu|9|0\n\
	print \"active cpus    = \", gbl_active_cpu|9|0\n\
	print \"num disks      = \", gbl_num_disk|9|0\n\
	print \"physical mem   = \", gbl_mem_phys|9|0\n\
	print \"free memory    = \", gbl_mem_free|9|0\n\
	print \"config nproc   = \", tbl_proc_table_avail|9|0\n\
	print \"  \"\n\
	print \"mi maximum num processes     =\", gbl_mi_proc_entries|7|0\n\
	print \"mi maxmum num        threads =\", gbl_mi_thread_entries|7|0\n\
	print \"mi cumulative lost processes =\", gbl_mi_lost_proc_cum|7|0\n\
	print \"mi cumulative lost buffers   =\", gbl_lost_mi_trace_buffers|7|0\n\
	print \"  \"\n\
# invoke syscall loop but ignore results for first interval:\n\
	systemcall loop { }\n\
	notfirstinterval = 1\n\
	\n\
} # end else first interval\n" >> $AOS

}

clearaos()
{
	rm -f $AOS
}

execglance()
{
	echo >> $FILEN
	echo $CMD_EXEC >> $FILEN
	if [ $DISPLAY = "ON" ]
	then
		$CMD_EXEC | tee -a $FILEN
	else
		$CMD_EXEC 1>> $FILEN 2>> $FILEN
	fi
}










# Check Arguments
if [ $# -eq 0 ]
then
#	Usage
	echo "Default Settings Used"
#	exit 0
fi

# Get Options
while getopts hJjc:s:f:i:g: name 
do
    case $name in
    c) THRESH=$OPTARG;;
    f) INT=$OPTARG;;
	g) GLANCE=$OPTARG;;
    h) Print_help_screen ;;
	J) JAVA_ONLY=0 ;;
    j) JAVA_ONLY=1 ;;
    p) PRINT_FREQ=$OPTARG ;;
    s) DISPLAY=$OPTARG;;
    i) ITR=`expr $OPTARG + 1`;;
    *)echo "Invalid option" 
      Usage;;
   esac
done

#Arguments Output
echo "CPU Threshold=          $THRESH"
echo "Intervals (seconds)=    $INT"
echo "Iterations=             $ITR"
echo "Show Only Java Threads= $JAVA_ONLY"
echo "Output File=            $FILEN"

# Main
if [ $JAVA_ONLY -eq 1 ]
then
	AND_STMT="( thread_proc_name == \"java\" ) and"
else 
	AND_STMT=""
fi

#Determine where glace is located.  If no command-line argument, use the which command
if [ -z "$GLANCE" ]
then #Need to parse out string on return of error "no glance in" based on output of grep
	GLANCE=`which glance`
	EXEWHICH=`echo $GLANCE | grep "no glance in"`
	RETWHICH=$?
	
	if [ RETWHICH -ne 1 ] 
	then
		echo "The application 'glance' could not be located."
		echo "Please provide the location of glance with the -g argument."
		echo "Try adding '-g /opt/perf/bin/glance' to the list of arguments.\n"
		Usage
		exit 0
	fi
fi

echo "Path to glance=$GLANCE"

printaos

set_command

execglance

clearaos

if [ $DISPLAY = "OFF" ]
then
	echo "Output has been sent to \"$FILEN\""
else
	echo "Output has finished."
	echo "Use the \"-s OFF\" argument to not display what is written to \"$FILEN\"."
fi
