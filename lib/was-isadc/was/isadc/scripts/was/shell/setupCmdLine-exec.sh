#!/bin/sh

CMD=$1
DIR=`dirname $CMD`

cd $DIR
. ./setupCmdLine.sh

echo "WAS_HOME=$WAS_HOME" >>  @output.file@
echo "USER_INSTALL_ROOT=$USER_INSTALL_ROOT" >>  @output.file@
echo "WAS_CELL=$WAS_CELL" >>  @output.file@
echo "WAS_NODE=$WAS_NODE" >>  @output.file@

