#!/bin/sh

# All Rights Reserved * Licensed Materials - Property of IBM
# 5724-I63, 5724-H88, 5655-N01, 5733-W60 (C) COPYRIGHT International Business Machines Corp., 2008
# US Government Users Restricted Rights - Use, duplication or disclosure
# restricted by GSA ADP Schedule Contract with IBM Corp.

# vceexport launcher
# Usage: vceexport WAS_HOME TEMP_DIR OUTPUT_DIR OUTFILE_BASENAME VCE_LIB_DIR (PROFILE_NAME)
# Note: Script must be called from $WAS_ROOT/bin

# !!!!!!!! THIS SCRIPT IS PART OF THE VCE AUTOMATION FRAMEWORK AND NOT INTENDED 
# !!!!!!!! TO BE EXECUTED STANDALONE. PLEASE REFER TO README OR HELP DOCUMENTATION.

WAS_HOME=$1
VCE_TEMP=$2
VCE_OUT=$3
VCE_FILE=$4
VCE_LIB=$5
cd $WAS_HOME/bin
echo cmd: $0
echo parameters: $*
if [ "$6" = "" ]; then 
	. ./setupCmdLine.sh
else
	. ./setupCmdLine.sh -profileName $6
fi

if [ ! "$USER_INSTALL_ROOT" ] ; then
   USER_INSTALL_ROOT=$WAS_HOME
fi

# For debugging the utility itself
# WAS_DEBUG="-Djava.compiler=NONE -Xdebug -Xnoagent -Xrunjdwp:transport=dt_socket,server=y,suspend=y,address=7777"

DELIM=" "
C_PATH="$WAS_CLASSPATH:$WAS_HOME/optionalLibraries/jython/jython.jar"

#Platform specific args...
PLATFORM=`/bin/uname`
case $PLATFORM in
  AIX | Linux | SunOS | HP-UX)
    CONSOLE_ENCODING=-Dws.output.encoding=console ;;
  OS/390)
    EXTRA_D_ARGS="-Dfile.encoding=ISO8859-1 $DELIM -Djava.ext.dirs="$JAVA_EXT_DIRS""
    EXTRA_X_ARGS="-Xnoargsconversion" ;;
esac

# Set java options for performance
PLATFORM=`/bin/uname`
case $PLATFORM in
  AIX)
      PERF_JVM_OPTIONS="-Xms64m -Xmx256m -Xquickstart" ;;
  Linux)
      PERF_JVM_OPTIONS="-Xms64m -Xmx256m -Xj9 -Xquickstart" ;;
  SunOS)
      PERF_JVM_OPTIONS="-Xms64m -Xmx256m -XX:PermSize=40m" ;;
  HP-UX)
      PERF_JVM_OPTIONS="-Xms64m -Xmx256m -XX:PermSize=40m" ;;
  OS/390)
      PERF_JVM_OPTIONS="-Xms64m -Xmx256m" ;;
esac 

echo wasboot.cp=$WAS_BOOTCLASSPATH
echo xargs=$EXTRA_X_ARGS
echo con.enc=$CONSOLE_ENCODING
echo was.debug=$WAS_DEBUG
echo perf.opts=$PERF_JVM_OPTIONS
echo was.install.root=$WAS_HOME
echo user.install.root=$USER_INSTALL_ROOT
echo was.repository.root=$CONFIG_ROOT
echo was.repository.temp=$VCE_TEMP
echo local.cell=$WAS_CELL
echo local.node=$WAS_NODE
echo com.ibm.itp.location=$WAS_HOME/bin
echo ws.ext.dirs=$WAS_EXT_DIRS:$VCE_LIB
echo vce.lib=$VCE_LIB
echo export.workdir=$VCE_OUT
echo export.fileprefix=$VCE_FILE
echo export.hidePasswords=true
echo dargs=$EXTRA_D_ARGS
echo cargs=$JVM_EXTRA_CMD_ARGS
echo perf.j.opts=$PERF_JVM_OPTIONS
echo wlog=$WAS_LOGGING
echo classpath=$C_PATH

"$JAVA_HOME/bin/java" \
  -Xbootclasspath/p:"$WAS_BOOTCLASSPATH" \
  $EXTRA_X_ARGS \
  $CONSOLE_ENCODING \
  $WAS_DEBUG \
  -Dperf.java.options="$PERF_JVM_OPTIONS" \
  -Dwas.install.root="$WAS_HOME" \
  -Duser.install.root="$USER_INSTALL_ROOT" \
  -Dwas.repository.root="$CONFIG_ROOT" \
  -Dwas.repository.temp="$VCE_TEMP" \
  -Dlocal.cell="$WAS_CELL" \
  -Dlocal.node="$WAS_NODE" \
  -Dcom.ibm.ws.management.standalone=true \
  -Dcom.ibm.itp.location="$WAS_HOME/bin" \
  -Dws.ext.dirs="$WAS_EXT_DIRS:$VCE_LIB" \
  -Dvce.lib="$VCE_LIB" \
  -Dexport.workdir="$VCE_OUT" \
  -Dexport.fileprefix=$VCE_FILE \
  -Dexport.hidePasswords=true \
  $EXTRA_D_ARGS \
  $JVM_EXTRA_CMD_ARGS \
  $PERF_JVM_OPTIONS \
  $WAS_LOGGING \
  -classpath "$C_PATH" com.ibm.ws.bootstrap.WSLauncher \
  com.ibm.topology.websphere.provider.VCEExportLauncher
  
if [ $?=0 ] ; then
	. $VCE_OUT/export-temp.sh
fi

rc=$?

if [ -f $VCE_OUT/export-temp.sh ] ; then
	rm $VCE_OUT/export-temp.sh
fi

exit $rc
