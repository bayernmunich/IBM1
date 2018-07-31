#!/bin/sh

# All Rights Reserved * Licensed Materials - Property of IBM
# 5724-I63, 5724-H88, 5655-N02, 5733-W70 (C) COPYRIGHT International Business Machines Corp., 1997,2007
# US Government Users Restricted Rights - Use, duplication or disclosure
# restricted by GSA ADP Schedule Contract with IBM Corp.

binDir=`dirname "$0"`
currentDir=`pwd`
cd $binDir/../../../bin/
. ./setupCmdLine.sh
cd $currentDir

if [ "$ITP_LOC" = "" ] ; then
    echo "need to set ITP_LOC"
    exit
fi

if [ -s $USER_INSTALL_ROOT/ejbdeploy/configuration ]; then
    echo Removing $USER_INSTALL_ROOT/ejbdeploy/configuration
    rm -fr $USER_INSTALL_ROOT/ejbdeploy/configuration
fi

if [ -s $ITP_LOC/configuration ]; then
    echo Removing $ITP_LOC/configuration/org.*
    rm -fr $ITP_LOC/configuration/org.*
fi
