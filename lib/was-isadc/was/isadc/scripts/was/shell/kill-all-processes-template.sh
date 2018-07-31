#!/bin/sh
OUT1=`ps -ef | grep @searchString@ | grep -v "grep" | awk '{print $2}'`
OUT2=`ps -ef | grep $OUT1 | grep -v "grep" | awk '{print $2}' | awk '{SUM = SUM " " $1}; END {print SUM}'`

kill @num@ $OUT2
