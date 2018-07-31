#!/bin/ksh
# @(#) 2002/03/27 Get shared libraries with executable and core for dbx analysis
###################################################################################

export LANG=C

typeset -r CN="$(basename $0)"
typeset -r MAP=".__dbx_map.out"
typeset -r CWD=$PWD
typeset TAR="${CN%.sh}_archive.tar"
integer I=0

Usage()
{
print -- "\
Usage : $CN executable_fullpath core \n\
\texecutable_fullpath : executable which generated core. Full path must be specified. \n\
\tcore                : core file \n\
\n\
Sample : $CN /usr/WebSphere/AppServer/java/jre/bin/java core\n\n\
This tool collects all of shared libraries for target core files.\n\
After this tool, each files with core and executable are archived into $TAR.Z\n\
"
}

Msg()
{
print ">> $@"
}

[[ $# < 2 ]] && { Usage ; exit -1 ; }
[[ -f $1 && -s $1 && $1 = /* ]] && EXE=$1
[[ -f $2 && -s $2 ]] && CORE=$2
[[ -z $EXE || -z $CORE ]] && { Msg "executable or core not found or not vaild." ; Usage ; exit -1 ; }

Msg "dbx map output : $MAP" ;
print "== $CN for map started at $(date) == \n" > $MAP
print "== ls -li for $CORE ==" >> $MAP ; ls -li $CORE >> $MAP
print "== sum for $CORE ==" >> $MAP ; sum $CORE >> $MAP
print "=====================================================" >> $MAP

echo "map" | dbx $EXE $CORE >> $MAP 2>&1
[[ $? != "0" ]] && { Msg "Error for dbx : RC=$?" ; exit -1; }
print "\n== $CN for map ended at $(date) ==" >> $MAP

if [[ -s $MAP ]] then
	I=0
	for F in $(awk -F ":" '$1 ~ /Object name/ {print $2}' $MAP)
	do
		LIB[$I]=$((( I == 0 )) && echo .$EXE || echo .$F)
		(( I += 1 ))
	done
fi

[[ -z $LIB ]] && { Msg "Error to get library list" ; exit -2 ; }
LIB=$(echo ${LIB[@]} | tr ' ' '\n' | sort | uniq)
Msg "List of library files : "
echo $LIB | tr ' ' '\n'
Msg "Are you sure to archive them? Enter to continue or Ctrl+C to exit." ; read TMP

TAR="$CWD/$TAR"
cd /
Msg "Archive library files into $TAR ..." ;  tar -h -cvf $TAR $LIB
Msg "Done."
cd $CWD
#Msg "Adding $MAP and $CORE into $TAR ..."; tar -rvf $TAR $MAP $CORE
Msg "Adding $MAP into $TAR ..."; tar -rvf $TAR $MAP
Msg "Done."
Msg "Compressing $TAR" ; compress $TAR
Msg "Done."
