#!/bin/sh

# All Rights Reserved * Licensed Materials - Property of IBM
# 5724-I63, 5724-H88, 5655-N01, 5733-W60 (C) COPYRIGHT International Business Machines Corp., 2006, 2010
# US Government Users Restricted Rights - Use, duplication or disclosure
# restricted by GSA ADP Schedule Contract with IBM Corp.
#
# OSGi cache Terminology:
#    ProfileCache - profiles/<A_Profile>/configuration
#                   This cache is used by only a few scripts (like stopServer)
#    ServerCache  - profiles/<A_Profile>/servers/<A_Specific_Server>/configuration
#                   This cache is used by a specific server instance 
#    WasHomeCache - <WAS_HOME>/configuration
# 
# Launch OSGi Console in order to debug, console connects to one of the 
# following osgi caches:
#   - if run from <WAS_INSTALL>/bin and no arguments provided, connected 
#     to the ProfileCache of the default profile.
#   - if run from a profile/bin with no args, connected to the 
#     ProfileCache of the profile the command is being run in.
#   - if run from a profile/bin with a server argument, connected to the 
#     server cache of the specified server.
#
# Launch Arguments:
#   -debug  <optional osgi debug file>, if none specified $WAS_HOME/bin/.options is used 
#   -washome
#   -server <a ServerName> 

binDir=`dirname $0`
. $binDir/setupCmdLine.sh

printUsage()
{
   echo "osgiConsole [-debug [osgi debug file]] [-washome]|[-server serverName]"; 
   exit 1; 
} 

# Verify that the argument passed to this function
# is not a known directive (i.e. anything like "-help, 
# -debug...etc")
verifyArgumentNotDirective()
{
      case $1 in
         -help)
              return 1            
              ;;
         -washome)
              return 1
              ;;
         -debug)
              return 1
              ;;
         -server)
              return 1
              ;;
         *)
              return 0
              ;;
      esac
}
  

parseArgs()
{
for arg in "$@" ; do
   # echo processing $arg
   if [ $_DEBUGOPTIONEXPECTEDNEXT = 1 ]; then
      verifyArgumentNotDirective $arg;
      if [ "$?" = "1" ]; then
         OSGI_DEBUG="-debug $WAS_HOME/bin/.options";
         echo Setting osgi debug to: $OSGI_DEBUG
      else 
         if [ -f "$arg" ]; then
	    OSGI_DEBUG="-debug $arg";
         else
	    echo "$arg does not exist";
	    printUsage
         fi
      fi
      _DEBUGOPTIONEXPECTEDNEXT=0;
   elif [ "$_SERVERNAMEEXPECTEDNEXT" = "1" ]; then
      if [ -d "$USER_INSTALL_ROOT/servers/$arg/configuration" ]; then
         # Set the OSGI_CFG variable to point to the serverCache of the
         # server (as specified by the argument being processed)
         OSGI_CFG="-Dosgi.configuration.area=$USER_INSTALL_ROOT/servers/$arg/configuration"
         echo Setting OSGi cfg area to: $OSGI_CFG
         _SERVERNAMEEXPECTEDNEXT=0;
      else 
         echo Server "$arg" does not exist under this profile.
      fi
   else
      case "$arg" in
         -help)
            printUsage
            ;;
         -washome)
	    OSGI_INSTALL="-Dosgi.install.area=${WAS_HOME}"
	    OSGI_CFG="-Dosgi.configuration.area=${WAS_HOME}/configuration"
	    USER_INSTALL_PROP="-Duser.install.root=${WAS_HOME}"
            _WASHOMESPECIFIED=1
            ;;
         -debug)
            _DEBUGOPTIONEXPECTEDNEXT=1
            ;;
         -server)
            _SERVERSPECIFIED=1
            _SERVERNAMEEXPECTEDNEXT=1
            ;;
         *)
            echo input argument $arg not valid
            printUsage 
            break
            ;;
      esac
   fi
done

if [ "$_SERVERSPECIFIED" = "1" ] && [ "$_WASHOMESPECIFIED" = "1" ]; then
   echo -server and -washome arguments specified. Only one or the other is allowed
   printUsage
fi
 
# complete all incomplete work
if [ "$_DEBUGOPTIONEXPECTEDNEXT" = "1" ]; then
   OSGI_DEBUG="-debug $WAS_HOME/bin/.options";
   echo Setting osgi debug to: $OSGI_DEBUG
   _DEBUGOPTIONEXPECTEDNEXT=0;
fi

if [ "$_SERVERNAMEEXPECTEDNEXT" = "1" ]; then
   echo -server directive used but no server name was provided
   printUsage
fi
}

# Begin main script execution path
if [ -f ${JAVA_HOME}/bin/java ]; then
	JAVA_EXE="${JAVA_HOME}/bin/java"
else
	JAVA_EXE="${JAVA_HOME}/jre/bin/java"
fi

# Handles command line arguments

OSGI_DEBUG="";
_DEBUGOPTIONEXPECTEDNEXT=0;
_SERVERNAMEEXPECTEDNEXT=0;
_SERVERSPECIFIED=0;
_WASHOMESPECIFIED=0;

if [ $# -gt 5 ]; then
   printUsage
else
   parseArgs $*
fi   

${JAVA_EXE} \
	$OSGI_INSTALL $OSGI_CFG \
	$USER_INSTALL_PROP \
	-Dwas.install.root=${WAS_HOME} \
	-Djava.endorsed.dirs="$WAS_ENDORSED_DIRS" \
        -classpath $WAS_CLASSPATH \
	com.ibm.wsspi.bootstrap.WSPreLauncher -nosplash $OSGI_DEBUG -console -consoleLog -application com.ibm.ws.bootstrap.WSLauncher com.ibm.ws.debug.osgi.StartOsgiConsole 
launchExit=$?
exit `expr $launchExit + $?`
