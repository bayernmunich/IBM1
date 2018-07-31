#!/bin/sh

# cd @was_home@/bin
# . ./setupCmdLine.sh

export $JAVA_HOME=@was_home@/java

@was_home@/wlp/bin/server dump @server_name@ --archive=@output_file@

