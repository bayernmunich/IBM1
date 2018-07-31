#!/bin/sh

if [ $# -lt 1 ]
then
    echo "$0 <sample period>"
    exit
fi

DT=${1:-300}

if [ 0${DT} -lt 8 ]
then
    DT=8
fi

echo
echo "Snapshot process details every ${DT}s"
echo

while true
do
    echo `date`" ===> snap"
    date >> jtc.ps$$.log
    ps -e -o "pid pcpu pmem nlwp vsz args" | sort -nr -k5,5 >> jtc.ps$$.log
    sleep ${DT}
done

