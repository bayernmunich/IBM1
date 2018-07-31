#!/bin/ksh
#
# Purpose:	Dump process information from both kernel(kdb) and user(dbx) space
# Usage:    	pdump.sh [-k] [-d] <PID>
# Last update:	Feb-24-2004, by taochen@austin.ibm.com

print_usage()
{
        print "\nUsage: ${0##/*/} [ -k | -d ] <PID>"
	print "       -k: skip kdb"
	print "       -d: call dbx\n"
}

clean_up()
{
        print -u2 "\nScript is stopped. Partial output is saved in $OFILE.\n"
        exit
}

#################################################################################################### general

get_general_config()
{
    print "\nGetting general environment data ..."
    {
	print "Date:     $(date +%d%h%Y-%H.%M.%S)"
	print "Machine:  $(hostname) - $(uname -M)"
	print "CPU#:     $((`lsdev -Cc processor|wc -l`))"
	print "User:     $(whoami)"

	## if not root, BIT is not a must, since we won't run kdb
	if [[ $(whoami) = "root" ]]; then  
		BIT=$((`bootinfo -K`)) 
		print "Kernel:   $BIT-bit"
	fi

	print ""
	lslpp -Lc \
		bos.up \
		bos.mp \
		bos.mp64 \
		bos.rte.libc \
		bos.rte.libpthreads \
		bos.rte.filesystem \
		bos.adt.debug \
		bos.sysmgt.serv_aid 2>&1 | awk '
		/^bos/ {
			gsub(/:/, " ")
			printf("%-8s - %-s\n", $3, $2)
		}'

	print "\n# ps -mp $PID -o THREAD\n"
	ps -mp $PID -o THREAD
	print "\n# ps auxeww $PID\n"
	ps auxeww $PID

	if [[ $(whoami) = "root" ]]; then  
		print "\n# svmon -P $PID"
		svmon -P $PID 2>/dev/null | egrep -v "\-\-"
	fi

    } >> $OFILE

}
## END of get_general_config()

#################################################################################################### kdb

run_kdb()
{
	print "Dumping process information from kdb ...\n"

	## from PID to PSLT
	{
		osl=$(oslevel | cut -c1-3)
		if [[ $BIT -eq 32 ]]
		then
			let PSLT=$PID/256
		else
			if [[ $osl = "5.2" ]]
			then
				let PSLT=$PID/4096
			else
				let PSLT=$PID/8192
			fi
		fi
		# init is an exception (1/$DIVISOR = 0)
		if [[ $PID -eq 1 ]]; then
			PSLT=1
		fi
	}

	print "\n# kdb ...\n" >> $OFILE
	print "\tdumping process slot $PSLT ..."

	BK="\n\n\n\n\n"

	printf " tpid %X $BK proc %d $BK lle -p %d\n" $PID $PSLT $PSLT \
	| kdb | sed -n -e '/^(0)/,$p' >> $OFILE 

	## most other kdb commands will rely on the tpid output:
	> pdump.tslot
	awk '
	/^pvthread|^thread/ {
		if ($4 != "ZOMB") {
			sub(/!/, " "); 
			sub(/>/, " "); 
			print $2 >> "pdump.tslot"
		}
	}' < $OFILE

	if [[ ! -s pdump.tslot ]]; then
		print -u2 "Error getting thread list. Skip other kdb commands."
		return
	fi

	# USER is a proc structure shared by all threads, 
	# in kdb though, 'user' command actually prints u-block of each threads.
	# ( USER = u-block - uthread ) 
	# so only the first thread's full user output is saved here.

	# buld a command list
	COMMS=""

	FIRSTT="true"
	for TSLT in `cat pdump.tslot`
	do 
		print "\tdumping thread slot $TSLT ..."
		if [[ $FIRSTT = "true" ]]; then
			COMMS=$COMMS"$BK th $TSLT $BK user $TSLT $BK f $TSLT $BK f -v $TSLT $BK sw $TSLT $BK mst"
			FIRSTT="false"
		else
			COMMS=$COMMS"$BK th $TSLT $BK user -ut $TSLT $BK f $TSLT $BK f -v $TSLT $BK sw $TSLT $BK mst"
		fi
	done
	rm pdump.tslot >/dev/null 2>&1 

	print "\tdumping other info ..."
	# kernel extension: 
	COMMS=$COMMS"$BK lke"

	# IPC :
	COMMS=$COMMS"$BK ipc 1 1"
	COMMS=$COMMS"$BK ipc 2 1"
	COMMS=$COMMS"$BK ipc 3 1"

	# send commands to kdb
	print $COMMS | kdb | sed -n -e '/^(0)/,$p' >> $OFILE
} 
## END of run_kdb()

#################################################################################################### dbx

run_dbx()
{
	print "\nDumping process information from dbx ...\n"

        DBXCMD="/usr/bin/dbx -a $PID"

        print "\n# dbx -a $PID \n" >> $OFILE

	## Get the current thread's output first
	print "\n p '(dbx) where' \n where \
	      \n p '(dbx) x' \n x     \
	      \n p '(dbx) (\$stkp)/200' \n (\$stkp)/200 \
	      \n p '(dbx) map' \n map   \
	      \n p '(dbx) p __n_pthreads' \n p __n_pthreads \
	      \n p '(dbx) p __multi_threaded' \n p __multi_threaded \
	      \n p '(dbx) mutex' \n mutex \
	      \n p '(dbx) condition' \n condition \
	      \n p '(dbx) rwlock' \n rwlock \
	      \n p '(dbx) th' \n th \
	      \n p '(dbx) detach' \n detach" | $DBXCMD >> $OFILE 2>&1

	if [[ $? -ne 0 ]]; then
		print -u "Can not dbx attach to the process. Skip dbx."
		return 
	fi

	sed -n -e '/(dbx) th/,$p' $OFILE | grep "k-tid" >/dev/null 2>&1 
	## multi-threaded
	if [[ $? -eq 0 ]] 
	then
		## build a command list
		BRK='p "."'
		SECT=">>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>"
		COMMS="$BRK\n"

		COMMS=$COMMS"p '$SECT thread info'\n$BRK\n thread info\n$BRK\n"

		## Since thread number is not necessarily continuous,
		## we have to get the exact thread number.

		sed -n -e '/(dbx) th/,$p' $OFILE | awk '/^..t[0-9]/ {print $1}' | while read TPT
		do
			PT=${TPT#*t}

			print "\tdumping tid $PT ..."
			COMMS=$COMMS"p '$SECT thread current $PT' \n$BRK\n thread current $PT\n"
			COMMS=$COMMS"p '$SECT x $PT' \n$BRK\n x \n$BRK\n"
			COMMS=$COMMS"p '$SECT where $PT' \n$BRK\n where \n$BRK\n"
			COMMS=$COMMS"p '$SECT (\$stkp)/100 $PT' \n$BRK\n (\$stkp)/100 \n$BRK\n"
		done
		COMMS=$COMMS"p '(dbx) detach' \n detach"

		print "\n# dbx -a $PID \n" >> $OFILE
		print $COMMS | $DBXCMD 2>/dev/null >> $OFILE
	fi

	print "\tlisting object files ..."
	print "\n + List of object files: \n" >> $OFILE
	awk '/Object name: / { print $NF }' $OFILE | /usr/bin/sort | /usr/bin/uniq | while read obj
	do
		## the main program may not locate in the current directory
		## so ls -l may return error > /dev/null
		realobj=$obj
		/bin/ls -l $realobj >> $OFILE 2>/dev/null
		/bin/ls -l $realobj 2>/dev/null | /usr/bin/grep ^lrwx >/dev/null 2>&1
		while [[ $? -eq 0 ]]
		do
			realobj=`/bin/ls -l $realobj 2>/dev/null | awk '{print $NF}'`
			/bin/ls -l $realobj >> $OFILE  2>/dev/null
			/bin/ls -l $realobj 2>/dev/null | /usr/bin/grep ^lrwx >/dev/null 2>&1
		done
	done
} 
## END of run_dbx

#################################################################################################### main

while getopts :kdh flag ; do
        case $flag in
                k)      NOKDB=1;;
                d)      USEDBX=1;;
                h)      print_usage
                        return 0;;
                \?)     print -u2 "\nInvalid parameter"
                        print_usage
                        return 1;;
        esac
done
shift $(($OPTIND -1))

## check tools
{
	## check permission to run kdb
	if [[ -z $NOKDB && $(whoami) != root ]]; then
		print -u2 "\n'root' authority is required for kdb (use '-k' to skip kdb).\n" 
		return 1
	fi

	## check dbx tool
	if [[ -n $USEDBX && (! -f /usr/bin/dbx) ]]; then
		print -u2 "/usr/bin/dbx doesn't exist. Install bos.adt.debug or use '-d' to skip dbx."
		return 1
	fi
}

## validate PID
{
	## need one parameter
	if [[ $# -ne 1 ]]; then
		print_usage
		return 1
	fi

	## numeric?
	if [[ ${1##+([0-9])} != "" ]] ; then
		print -u2 "\n$1 is not a PID"
		print_usage
		return 1
	fi

	## existing PID?
	/bin/ps -p $1 > /dev/null 2>&1
	if [[ $? -eq 1 ]]; then
		print -u2 "\nPID $1 doesn't exist.\n"
		return 1
	fi

	PID=$1
}


## create output file
{
	OFILE="pdump.$(/bin/ps -p $PID -ocomm=).$PID.`date +%d%h%Y-%H.%M.%S`.out"
	> $OFILE
	if [[ $? -ne 0 ]]; then
		print -u2 "\nCannot create output file in the current directory. Please check permission.\n"
		return 1
	fi
}

trap clean_up TERM INT

## collect output
{
	get_general_config

	if [[ -z $NOKDB ]]; then
		run_kdb
	fi

	if [[ -n $USEDBX ]]; then
		run_dbx
	fi

	# extra data
	{
		print "\n# ps -efk \n" 
		ps -efk 
		print "\n# ipcs -a \n"
		ipcs -a

	} >> $OFILE
}

print "\nDone.\nOutput file is $OFILE\n"
/bin/ls -l $OFILE 
print

## The End
