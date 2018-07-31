#!/bin/sh
netstat @netstat.args@ > @netstat.out@
vmstat 5 12 > @vmstat.out@
