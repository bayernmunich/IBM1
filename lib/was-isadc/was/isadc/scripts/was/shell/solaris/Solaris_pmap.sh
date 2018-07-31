#!/bin/sh

if [ $# -lt 2 ]
then
    echo "$0 <sample period> <pid>"
    exit
fi

DT=${1:-300}
PID=${2:-$$}

if [ 0${DT} -lt 8 ]
then
    DT=8
fi

kill -0 ${PID} 1>/dev/null 2>&1
if [ $? -gt 0 ]
then
    echo "No such process ${PID}"
    exit
fi

echo
echo "Snapshot process map for ${PID} every ${DT}s"
echo

while true
do
    echo `date`" ===> snap"
    date >> jtc.pmap${PID}.log
    pmap -x ${PID} >> jtc.pmap${PID}.log
    sleep ${DT}
done

