#!/bin/sh
#Ejbdeploy.sh for unix

if [ "$ITP_LOC" = "" ] ; then
  REPLACE_WAS_HOME=`dirname $0`/../../
  binDir=`dirname $0`/../../bin
  . $binDir/setupCmdLine.sh
fi

WAS_EXT_DIRS=$WAS_HOME/plugins:$WAS_EXT_DIRS

# Spit out minor error about itp loc not being set.
if [ "$ITP_LOC" = "" ] ; then
    echo "need to set ITP_LOC"
fi

if [ "$EJBDEPLOY_JAVA_HOME" = "" ] ; then
    EJBDEPLOY_JAVA_HOME=$JAVA_HOME
else
    echo "using JRE in $EJBDEPLOY_JAVA_HOME"
fi

if [ "$EJBDEPLOY_JVM_HEAP" = "" ] ; then
    EJBDEPLOY_JVM_HEAP="-Xms256m -Xmx256m"
else
    echo "using JVM heap $EJBDEPLOY_JVM_HEAP"
fi

# Set the classpath needed for the deploytool
ejbd_cp=$ITP_LOC/batch2.jar:$ITP_LOC/batch2_nl1.jar:$ITP_LOC/batch2_nl2.jar
ejbd_bootpath=$ITP_LOC/batchboot.jar:$JAVA_HOME/jre/lib/ext/iwsorbutil.jar

PLATFORM=`/bin/uname`
case $PLATFORM in
  AIX)
      JAVA_CMD="$EJBDEPLOY_JAVA_HOME/jre/bin/java"
      EJBDEPLOY_JVM_OPTIONS="-Xquickstart -Xverify:none";;
  Linux)
      JAVA_CMD="$EJBDEPLOY_JAVA_HOME/jre/bin/java"
	  ARCH=`/bin/uname -m`
	  if [ "$ARCH" = "ia64" ] ; then
	  EJBDEPLOY_JVM_OPTIONS="-XX:PermSize=40m -XX:MaxPermSize=128m -Xverify:none"
      else
	  EJBDEPLOY_JVM_OPTIONS="-Xj9 -XX:MaxPermSize=128m -Xverify:none"
	  fi;;
  SunOS)
      JAVA_CMD="$EJBDEPLOY_JAVA_HOME/jre/bin/java"
      EJBDEPLOY_JVM_OPTIONS="-XX:MaxPermSize=256m -XX:PermSize=40m -Xverify:none";;
  HP-UX)
      JAVA_CMD="$EJBDEPLOY_JAVA_HOME/jre/bin/java"
      EJBDEPLOY_JVM_OPTIONS="-XX:MaxPermSize=256m -XX:PermSize=40m -Xverify:none";;
  OS/390)
      # For z/OS, use ascii file-encoding and ebcdic output-encoding
      JAVA_CMD="$EJBDEPLOY_JAVA_HOME/bin/java"
        EJBDEPLOY_JVM_OPTIONS="-Dfile.encoding=ISO8859-1 -Xnoargsconversion "$EJBDEPLOY_JVM_OPTIONS
      if [ "$EJBCALLER" = "WEBSPHERE" ] ; then
         ejbd_cp=$ejbd_cp':'$WAS_CLASSPATH
         EJBDEPLOY_JVM_OPTIONS=$EJBDEPLOY_JVM_OPTIONS" -Dws.output.encoding=ISO8859-1 "
      fi;;
esac

# set options for ejb deploy....
ejbdopts="$@"
export itp_cp ejbd_cp ejbd_bootpath ejbdopts

# WAS_DEBUG="-Djava.compiler=NONE -Xdebug -Xnoagent -Xrunjdwp:transport=dt_socket,server=y,suspend=y,address=7777"

$JAVA_CMD \
        -Xbootclasspath/a:$ejbd_bootpath \
    $EJBDEPLOY_JVM_HEAP \
    -Dws.ext.dirs=$WAS_HOME/eclipse/plugins/j2ee.javax_1.4.0:$WAS_HOME/eclipse/plugins/com.ibm.ws.runtime.eclipse_1.0.0:$WAS_EXT_DIRS \
    -Dwebsphere.lib.dir=$WAS_HOME/lib \
    -Dwas.install.root=$WAS_HOME \
    -Djava.endorsed.dirs="$WAS_ENDORSED_DIRS" \
    -Ditp.loc=$ITP_LOC \
    -Dorg.osgi.framework.bootdelegation=* \
    -Dejbdeploy.user.install.root=$USER_INSTALL_ROOT/ejbdeploy \
    $USER_INSTALL_PROP \
    -Dcom.ibm.sse.model.structuredbuilder="off" \
    -cp $ejbd_cp \
    $EJBDEPLOY_JVM_OPTIONS \
    $WAS_DEBUG \
    $EJBDEPLOY_JVM_ARGS \
    com.ibm.etools.ejbdeploy.EJBDeploy "$@"

