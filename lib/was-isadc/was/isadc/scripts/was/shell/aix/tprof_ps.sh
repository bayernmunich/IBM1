#! /bin/ksh
#TPROF_LOG=$1

mkdir @TPROF_LOG@
cd @TPROF_LOG@
tprof -k -s -e -x sleep 60

ps avwwwg > ps-w-tprof.log

#cd .. 
