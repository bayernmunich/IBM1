#!/bin/sh
ulimit -c unlimited
ulimit -u unlimited
@define_variables1@
@define_variables2@
@was.enhanced.root@/bin/startServer.sh @serverName@
