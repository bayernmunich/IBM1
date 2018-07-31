

@echo off

if exist "@tprof.home@\bin\setrunenv.cmd" call "@tprof.home@\bin\setrunenv.cmd"

call "@tprof.home@\bin\run.tprof" -s 0 -r @timeperiod@
