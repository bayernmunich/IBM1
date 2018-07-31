#!/bin/sh
# Copyright IBM Corp. 2006, 2011

binDir=`dirname $0`
. $binDir/setupCmdLine.sh

if [ -f ${JAVA_HOME}/bin/java ]; then
    JAVA_EXE="${JAVA_HOME}/bin/java"
else
    JAVA_EXE="${JAVA_HOME}/jre/bin/java"
fi

WAS_CLASSPATH="$WAS_HOME"/properties:"$WAS_HOME"/plugins/com.ibm.ws.runtime.jar:"$WAS_HOME"/plugins/com.ibm.ws.runtime.client.jar:"$WAS_HOME"/plugins/nls/eclipse/plugins/*:"$WAS_HOME"/lib/wasproduct.jar

if [ "${WAS_ENDORSED_DIRS}" = "" ]; then
    ${JAVA_EXE} \
      -Dwas.install.root="$WAS_HOME" \
      -classpath "$WAS_CLASSPATH" com.ibm.websphere.product.VersionInfo "$@"
else
    ${JAVA_EXE} \
      -Dwas.install.root="$WAS_HOME" \
      -Djava.endorsed.dirs="$WAS_ENDORSED_DIRS" \
      -classpath "$WAS_CLASSPATH" com.ibm.websphere.product.VersionInfo "$@"
fi