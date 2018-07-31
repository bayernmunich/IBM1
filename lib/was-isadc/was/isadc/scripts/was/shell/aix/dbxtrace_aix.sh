#!/bin/ksh

# Automate getting the dbx trace information
# --------------------------------------------------------
# AIX V4 32bit max thread limit in sys/thread.h
# Customer can adjust this value to max of target process
# --------------------------------------------------------
integer MAXTHREADS=512
integer MINTHREADS=1	
integer THREAD_NUM=$MINTHREADS

#
# Usage 
#

PROGNAME=$(basename $0)
function Usage {
        print "$(basename $0): Automate getting dbx trace information " 1>&2
        print "" 1>&2
        print "For core files:" 1>&2
	print "    Usage:   $PROGNAME [executable] [core]" 1>&2
	print "      or :   $PROGNAME -c corefile" 1>&2
	print "    Example: $PROGNAME /usr/jdk_base/bin/aix/native_threads/java core"  1>&2
        print "    (Please make sure you use the java executable and not the java script)" 1>&2
        print "" 1>&2
        print "To attach to a running or hung process" 1>&2
	print "    Usage:   $PROGNAME -a PID"  1>&2
	print "    Example: $PROGNAME -a 1234"  1>&2
	exit -1 
}

#
# Parse command lime arguments
#
typeset PID
EXECUTABLE=/usr/jdk_base/bin/aix/native_threads/java
CORE_FILE=core

if [[ $# > 0 ]]
then
    if [[ $1 = "-a" ]]
    then
       if [[ $# -eq 2 ]] 
       then
           PID=$2
       else
           Usage
       fi
    elif [[ $1 = "-c" ]]
    then
       if [[ $# -eq 2 ]] 
       then
           CORE_FILE=$2
       else
           Usage
       fi
    else
        EXECUTABLE=$1
        if [[ $# -eq 2 ]] 
        then
            CORE_FILE=$2
        fi
    fi
fi

#
# Check command lime arguments
#     then set the appropriate dbx commands
#
if [[ $PID. -eq . ]]
then
    if [[ ! ( -f $EXECUTABLE ) ]]
    then
	print "executable file: $EXECUTABLE does not exist" 1>&2
	Usage
    fi

    if [[ ! ( -x $EXECUTABLE ) ]]
    then
	print "executable file: $EXECUTABLE is not executable" 1>&2
	Usage
    fi

    if [[ ! ( -f $CORE_FILE ) ]]
    then
	print "core file: $CORE_FILE does not exist" 1>&2
	Usage
    fi
    if [[ $CORE_FILE = core ]]
    then
        print "******************************************" 1>&2
        print "* Failure of this script or dbx may      *" 1>&2
        print "* overwrite your existing core file.     *" 1>&2
        print "* It is recomended that you rename your  *" 1>&2
        print "* existing core file and use the -c flag *" 1>&2
        read Y_OR_N?"* Do you wish to continue (y/n): " 1>&2
        print "******************************************" 1>&2
        if [[ $Y_OR_N. != y. ]] && [[ $Y_OR_N. != Y. ]] 
        then
            exit 0
        fi
    fi
    typeset -r DBX_COMMAND="/usr/bin/dbx $EXECUTABLE $CORE_FILE" 
    typeset -r DETACH="quit"
else
    ps $PID > /dev/null 2>&1
    if [[ $? != "0" ]]
    then
        print "Process ID : $PID does not exist" 1>&2
	Usage
    fi
    typeset -r DBX_COMMAND="/usr/bin/dbx -a $PID"
    typeset -r DETACH="detach"
fi

#---------------------------------------------------------
# Prepare a command file to get all the thread information
#---------------------------------------------------------
# $DBX_COMMAND
# ---- Loop from 1 to MAXTHREADS ----
# > thread current THREAD_NUM
# > where
# ----------------------------
# > $DETACH



typeset THREAD_SUB_COMMAND
typeset -r WHERE="where"
typeset -r DIVIDER="-----------------------------------------------------------------"

# Create thread sub command statements 
print "Creating subcommand file...." 1>&2
typeset -r COMMAND_FILE=./dbx_commands.$$
awk -v thread_num=$THREAD_NUM -v max_threads=$MAXTHREADS -vdivider=$DIVIDER -vpid=$PID \
' BEGIN {
    print "thread"
    print "print \"\""
    print "thread info"
    print "print \"" divider "\""
    print "print \"Register Dump and Instruction trace follows\""
    print "unset \$noflregs"
    print "registers"
    print "where"
    print "print \"listi .-40,.+40 \""
    print "listi .-40,.+40"
    print "print \"" divider "\""
    while (thread_num <= max_threads) {
      print "thread " thread_num
      print "thread current " thread_num
      print "where"
      print "print \"" divider "\""
      thread_num++
    }
#    if (pid != 0 ) { # if attaching then capture javacore.txt
#      print "sh kill -QUIT " pid
#    }
  }
' < /dev/null >> $COMMAND_FILE
echo "$DETACH" >> $COMMAND_FILE

# Remove the tail end information about non existant threads
typeset -r REMOVE_MISSING_THREADS="/^['][\$]t[0-9]*['] is not an existing thread./,/^$DIVIDER/d"
typeset -r REMOVE_BAD_LINES="/^program is not active\$/d"

print "Running dbx..." 1>&2
$DBX_COMMAND < $COMMAND_FILE 2>&1 | sed -e "$REMOVE_MISSING_THREADS" -e "$REMOVE_BAD_LINES" 

rm $COMMAND_FILE
if [[ $? != "0" ]]
then
    print "failed to remove $COMMAND_FILE" 1>&2
fi
print "dbx has ended with RC=$?" 1>&2
