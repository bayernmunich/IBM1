#!/bin/sh
ulimit -c unlimited
ulimit -f unlimited
DISABLE_JAVADUMP=true
MQS_NO_SYNC_SIGNAL_HANDLING=true
export $DISABLE_JAVADUMP
export $MQS_NO_SYNC_SIGNAL_HANDLING
@was.enhanced.root@/bin/startServer.sh @serverName@
