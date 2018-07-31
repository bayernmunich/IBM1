#!/bin/ksh

# Automate getting the gdb trace information
# --------------------------------------------------------
# Customer can adjust this value to max of target process
# --------------------------------------------------------
integer MAXTHREADS=512
integer MINTHREADS=1
integer THREAD_NUM=$MINTHREADS

typeset -r DEFAULT_JAVA="/usr/jdk_base/bin/sparc/native_threads/java"
#
# Usage 
#

PROGNAME=$(basename $0)
function Usage {
        print "$PROGNAME: Automate getting gdb trace information " 1>&2
        print "" 1>&2
        print "For core files:" 1>&2
        print "    Usage:   $PROGNAME [executable] [core]" 1>&2
        print "      or :   $PROGNAME -c corefile" 1>&2
        print "    Example: $PROGNAME $DEFAULT_JAVA"
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
#     then set the appropriate gdb commands
#
if [ "$EXECUTABLE" = "" ]
then
   # Get default EXECUTABLE following symbolic links
   PRG=`whence java` >/dev/null 2>&1
   while [ -L "$PRG" ]; do
       src=`ls -l $PRG | awk '{ print $NF }'`
       res=`echo $src | grep -sc '^/'`
       if [ "0$res" -eq 0 ]; then
           PRG=${PRG%/*}/$src
       else
           PRG=$src
      fi
   done
   if [[ -x ${PRG%/*}/sparc/native_threads/java ]]
   then
        EXECUTABLE=${PRG%/*}/sparc/native_threads/java
   else 
        EXECUTABLE=$DEFAULT_JAVA
   fi
   if [[ ! -x $EXECUTABLE ]]
   then
        echo Cannot find an executable version of java 
        echo
        Usage
   fi
   echo "Found java in " $EXECUTABLE 1>&2
   read answer?"Do you want to use this one (y/n): "
   if [[ "$answer" != "Y" && "$answer" != "y" ]] 
   then
       echo
       echo "Please try again specifying the executable you wish to use"
       echo
       Usage
   fi
fi
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

if [[ "$PID" = "" ]]
then
    if [[ ! ( -f $CORE_FILE ) ]]
    then
        print "core file: $CORE_FILE does not exist" 1>&2
        Usage
    fi
    if [[ $CORE_FILE = core ]]
    then
        print "******************************************" 1>&2
        print "* Failure of this script or gdb may      *" 1>&2
        print "* overwrite your existing core file.     *" 1>&2
        print "* It is recomended that you rename your  *" 1>&2
        print "* existing core file and use the -c flag *" 1>&2
        read Y_OR_N?"* Do you wish to continue (y/n): " 1>&2
        print "******************************************" 1>&2
        if [[ "$Y_OR_N" != "y" ]] && [[ "$Y_OR_N" != "Y" ]] 
        then
            exit 0
        fi
    fi
    typeset -r GDB_COMMAND="/usr/local/bin/gdb $EXECUTABLE $CORE_FILE" 
    typeset -r DETACH="detach\\nquit"
else
    ps -p $PID > /dev/null 2>&1
    if [[ $? != "0" ]]
    then
        print "Process ID : $PID does not exist" 1>&2
        Usage
    fi
    typeset -r GDB_COMMAND="/usr/local/bin/gdb $EXECUTABLE $PID"
    typeset -r DETACH="detach\\nquit"
fi

#---------------------------------------------------------
# Prepare a command file to get all the thread information
#---------------------------------------------------------
# $GDB_COMMAND
# ---- Loop from 1 to MAXTHREADS ----
# > thread THREAD_NUM
# > info frame
# > where
# ----------------------------
# > $DETACH

typeset THREAD_SUB_COMMAND
typeset -r WHERE="where"
typeset -r DIVIDER="-----------------------------------------------------------------"

# Create thread sub command statements 
typeset -r COMMAND_FILE=./gdb_commands.$$
print "Creating subcommand file...." 1>&2
awk \
' BEGIN {
    pid=0'$PID'
    thread_num=0'$THREAD_NUM'
    max_threads=0'$MAXTHREADS'
    divider="'$DIVIDER'"
    print "set prompt"
    print "echo \\n\\n"
    print "shell uname -a"
    print "echo \\n"
    print "info threads"
    print "echo \\n"
    print "maintenance info sol-threads"
    print "echo \\n" divider "\\n"
    print "echo Register Dump and Instruction trace follows\\n\\n"
    print "info all-registers"
    print "echo \\n"
    print "where"
    print "echo \\n"
    print "disassemble"
    print "echo \\n" divider "\\n"
    while (thread_num <= max_threads) {
      print "thread " thread_num
      print "echo \\n"
      print "info frame"
      print "echo \\n"
      print "where"
      print "echo \\n" divider "\\n"
      thread_num++
    }
    print "Thread ID 0 not known."
    print "thread " 1
    print "echo \\n" divider "\\n"
  }
' < /dev/null >> $COMMAND_FILE
echo "$DETACH" >> $COMMAND_FILE

# Remove the tail end information about non existant threads
typeset -r KEEP_PID_INFO="/^Attaching to program/p"
typeset -r KEEP_CORE_INFO="/^Core was generated/p"
typeset -r KEEP_KILL_INFO="/^Program terminated/p"
typeset -r REMOVE_PREAMBLE="1,/^(gdb)/d"
typeset -r REMOVE_MISSING_THREADS="/^Thread ID [0-9]* not known./,/^$DIVIDER/d"
typeset -r REMOVE_BAD_LINES="/^No core file now.\$/d"

print "Running gdb..." 1>&2
$GDB_COMMAND < $COMMAND_FILE 2>&1 \
| sed -e "$KEEP_PID_INFO" \
      -e "$KEEP_CORE_INFO" \
      -e "$KEEP_KILL_INFO" \
      -e "$REMOVE_PREAMBLE" \
      -e "$REMOVE_MISSING_THREADS" \
      -e "$REMOVE_BAD_LINES"

rm $COMMAND_FILE
if [[ $? != "0" ]]
then
    print "failed to remove $COMMAND_FILE" 1>&2
fi
print "gdb has ended with RC=$?" 1>&2
