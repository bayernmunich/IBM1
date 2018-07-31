#!/bin/sh

binDir=`dirname "$0"`
. "$binDir"/setupCmdLine.sh
currentDir=$PWD

if [ -f ${JAVA_HOME}/bin/java ]; then
    JAVA_EXE="${JAVA_HOME}/bin/java"
elif [ -f ${JAVA_HOME}/jre/bin/java ]; then
    JAVA_EXE="${JAVA_HOME}/jre/bin/java"
else
    echo "Cannot locate the java command. Verify that the directory specified by the JAVA_HOME variable is a valid java installation."
    exit 5
fi

if [ -e "$binDir/../properties/sdk/cmdDefaultSDK.properties" ] ; then
    JAVA_VER_INFO=`grep "COMMAND_DEFAULT_SDK" "$binDir/../properties/sdk/cmdDefaultSDK.properties" | cut -d"=" -f2`
    JAVA_LOCATION=`grep "com.ibm.websphere.sdk.location.$JAVA_VER_INFO=" "$binDir/../properties/sdk/$JAVA_VER_INFO.properties" | cut -d"=" -f2 | cut -d"/" -f2`
    JAVA_OS=`grep "com.ibm.websphere.sdk.platform.$JAVA_VER_INFO=" "$binDir/../properties/sdk/$JAVA_VER_INFO.properties" | cut -d"=" -f2 | tr '[:upper:]' '[:lower:]'`
    JAVA_ARCH=`grep "com.ibm.websphere.sdk.bits.$JAVA_VER_INFO=" "$binDir/../properties/sdk/$JAVA_VER_INFO.properties" | cut -d"=" -f2`
else
    echo Cannot locate the cmdDefaultSDK.properties
    exit 99
fi

if [ -e "$binDir/../$JAVA_LOCATION" ] ; then
    # We check out the JAVA_OS and JAVA_ARCH against the system.
    THIS_OS=`uname -s | tr '[:upper:]' '[:lower:]'`
    case "$JAVA_OS" in
        *solaris*) ;; 
        *aix*) ;; 
        *$THIS_OS*) case "$JAVA_ARCH" in
                        *64*) THIS_ARCH=`uname -p`
                              case "$THIS_ARCH" in
                                  *64*) ;;
                                  *) echo "This system does not support running the 64 bit JDK provided by this createRemoteMigrJar file."
                                     echo "You can rerun the createRemoteMigrJar script with -includeJava false option."
                                     echo "WASPreUpgrade aborted...."
                                     exit 10 ;;
                              esac ;;
                        *) ;;
                    esac ;;
        *) echo "The JDK provided by the createRemoteMigrJar file is for a $JAVA_OS system and cannot be run on this $THIS_OS system."
           echo "You can rerun the createRemoteMigrJar script with -includeJava false option."
           echo "WASPreUpgrade aborted...."
           exit 15 ;;
    esac
else
    JAVA_VERSION=`$JAVA_EXE -version 2>&1 | head -1 | cut -d"." -f2`
    if ! [[ "$JAVA_VERSION" = "6" || "$JAVA_VERSION" = "7" || "$JAVA_VERSION" = "8" || "$JAVA_VERSION" = "9" ]] ; then
        echo "The WASPreUpgrade command requires a java version of 1.6.0 or greater."
        echo `$JAVA_EXE -fullversion 2>&1`
        exit 20
    fi
fi

isJavaOption=false
nonJavaOptionCount=1
use64bit=false
for option in "$@" ; do
  if [ "$option" = "-javaoption" ] ; then
     isJavaOption=true
  else
     if [ "$isJavaOption" = "true" ] ; then
        javaOption="$javaOption $option"
        isJavaOption=false
     else 
        if [ "$option" = "-use64BitJVM" ] ; then
            use64bit=true
        else
            nonJavaOption[$nonJavaOptionCount]="$option"
            nonJavaOptionCount=$((nonJavaOptionCount+1))
        fi
     fi
  fi
done

#Platform specific args...
# Set java options for performance
PLATFORM=`/bin/uname`
case $PLATFORM in
  AIX)
	PERF_JVM_OPTIONS="-Xms256m -Xmx512m -Xquickstart"
    CONSOLE_ENCODING=-Dws.output.encoding=console
	LIBPATH="$WAS_LIBPATH":$LIBPATH
    export LIBPATH ;;	
  Linux)
	PERF_JVM_OPTIONS="-Xms256m -Xmx512m -Xj9 -Xquickstart"
    CONSOLE_ENCODING=-Dws.output.encoding=console
    LD_LIBRARY_PATH="$WAS_LIBPATH":$LD_LIBRARY_PATH
    export LD_LIBRARY_PATH ;;	
  SunOS)
	PERF_JVM_OPTIONS="-Xms256m -Xmx512m -XX:PermSize=40m -XX:+UnlockDiagnosticVMOptions -XX:+UnsyncloadClass"
    CONSOLE_ENCODING=-Dws.output.encoding=console
	LD_LIBRARY_PATH="$WAS_LIBPATH":$LD_LIBRARY_PATH
    export LD_LIBRARY_PATH ;;	
  HP-UX)
	PERF_JVM_OPTIONS="-Xms256m -Xmx512m -XX:PermSize=40m -XX:+UnlockDiagnosticVMOptions -XX:+UnsyncloadClass"
    CONSOLE_ENCODING=-Dws.output.encoding=console
    SHLIB_PATH="$WAS_LIBPATH":$SHLIB_PATH
    export SHLIB_PATH ;;		
esac


if [ -r /etc/redhat-release ]
then
    release=`cat /etc/redhat-release | awk '{print $7}'`
    version=${release%%\.*}
        
    if [ $version -ge 5 ]
    then
        if [ -x /usr/sbin/selinuxenabled ] && /usr/sbin/selinuxenabled; then
            scontext=`ls --scontext "$JAVA_HOME"/bin/java | awk '{ split($1, a, ":"); print a[3] }'`

            case $scontext in
            textrel_shlib_t | java_exec_t | nfs_t) ;;
            iso9660_t) 
                echo SELinux is preventing WASPreUpgrade from running. Please mount the install CD with option \'-o context=system_u:object_r:textrel_shlib_t\' 
                exit $FAIL_RC
                ;;
            *) 
                "$currentDir"/relabel_java.sh "$JAVA_HOME"

                ;;
            esac
        fi
    fi
fi

#WAS_MIGR_DEBUG_RMT_PRE="-Djava.compiler=NONE -Xdebug -Xnoagent -Xrunjdwp:transport=dt_socket,server=y,suspend=y,address=8888"

# Any WebSphere processes spawned by WASPreUpgrade will use the incorrect SDK if this env variable is true.
export USE_COMMAND_OVERRIDE_SDK=false

$JAVA_EXE \
  $WAS_MIGR_DEBUG_RMT_PRE \
  "$OSGI_INSTALL" -Dosgi.configuration.area="@user.home/WebSphereRemoteMigr"  \
  $EXTRA_X_ARG \
  $CONSOLE_ENCODING \
  -Dcom.ibm.websphere.migration.serverRoot="$WAS_HOME" \
  -Dws.ext.dirs="$WAS_EXT_DIRS" \
  -Dws.migration.pre.remote.xos="true" \
  -Dcom.ibm.ws.migration.ulimit=`ulimit -n` \
  $PERF_JVM_OPTIONS \
  $WAS_LOGGING \
  $EXTRA_D_ARG \
  $javaOption \
  -classpath "$WAS_CLASSPATH" \
  com.ibm.wsspi.bootstrap.WSPreLauncher \
  -nosplash -clean -application com.ibm.ws.bootstrap.WSLauncher com.ibm.ws.migration.WASPreUpgrade "${nonJavaOption[@]}"
rc=$?
exit $rc
