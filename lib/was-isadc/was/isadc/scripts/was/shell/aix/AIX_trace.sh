##################################################
#
# AIX_trace.sh
#
# Script to automate collection of addition AIX
# trace data during a JVM hang or performance
# degradation.
#
##################################################

trace -a -n -l -L50000000 -T25000000 -o ./trace.out
sleep 30
trcstop

trcnm > ./trcnm.out
gennames > ./gennames.out
gensyms > ./gensyms.out
cp /etc/trcfmt ./trcfmt.out
trcrpt -r trace.out > ./trcrpt.out
