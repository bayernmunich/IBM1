#!/bin/sh

# All Rights Reserved * Licensed Materials - Property of IBM
# 5724-I63, 5724-H88, 5655-N01, 5733-W60 (C) COPYRIGHT International Business Machines Corp., 2005, 2010
# US Government Users Restricted Rights - Use, duplication or disclosure
# restricted by GSA ADP Schedule Contract with IBM Corp.

# OSGi cache Terminology:
#    ProfileCache - profiles/<A_Profile>/configuration
#                   This cache is used by only a few scripts (like stopServer)
#    ServerCache  - profiles/<A_Profile>/servers/<A_Specific_Server>/configuration
#                   This cache is used by a specific server instance 
#    WasHomeCache - <WAS_HOME>/configuration

# Launch osgiCfgInit
#   Clears the osgi caches contained in the osgi configuration directories 
#   as specified by the launch arguments.
#   Note: the locations of the osgi configuration are
#       <WAS_HOME>/configuration
#       <WAS_HOME>/profiles/*/configuration
#       <WAS_HOME>/profiles/*/servers/*/configuration

# Launch Arguments:
#   -all If from WAS_HOME, then performs osgi configuration init on 
#             WAS_HOME and all profiles and all servers
#   -washome Performs osgi configuration init only on WAS_HOME
#   -profile <profileName> Performs osgi configuration init on 
#                          <profileName>/configuration and 
#                          <profileName>/servers/<AllServers>/configuration
#   -profileConfig <profileName> Performs osgi configuration init on
#                          <profileName>/configuration
#   -servers <Server1, Server2...etc> Performs osgi configuration init on
#                          /servers/<AllSpecifiedServers>/configuration
#                          Under the profile this command is run in.
#   -help prints usage text
#
# If no arguments are specified, then the behavior is as follows:
#     if run from a profile/bin then clears the osgi caches for this profile
#     if run from <WAS_HOME>/bin then clears the osgi caches for the default profile
#     if run before a default profile exists, then the osgi cache 
#     for <WAS_HOME> is cleared.

_RETCODE=0
_SERVERARGS=""
_PROFILEARG=""
_PROFILECONFIGARG=""
_PROFILE=""
_ARGCOUNT=0
OSGI_INSTALL="-Dosgi.install.area=${WAS_HOME}"

printUsage()
{
   echo "osgiCfgInit.sh [-all|-washome|-profile profileName|-profileConfig profileName|-servers serverName1 serverName2..etc]."; 
   exit 1;
} 

# Clears the osgi config of the server passed as an argument
clearCfgForServer()
{
   #echo clearCfgForServer
   ORIG_OSGI_CFG=$OSGI_CFG 
   SERVER_CFG_AREA=$USER_INSTALL_ROOT/servers/$arg/configuration 
   #echo Finding "$SERVER_CFG_AREA"
   if [ -d "$SERVER_CFG_AREA" ]; then
      OSGI_CFG=-Dosgi.configuration.area=$SERVER_CFG_AREA
      $JAVA_EXE \
         $OSGI_INSTALL $OSGI_CFG  \
         -classpath $WAS_CLASSPATH \
         -Djava.endorsed.dirs="$WAS_ENDORSED_DIRS" \
         -Dwas.install.root=$WAS_HOME \
         $USER_INSTALL_PROP \
         com.ibm.wsspi.bootstrap.WSPreLauncher -clean -nosplash -application com.ibm.ws.bootstrap.WSLauncher com.ibm.ws.debug.osgi.OsgiCfgInit
         rc=$?
         if [ $rc -ne 0 ]; then
            echo Clean up failed for server $SERVER_CFG_AREA
            _RETCODE=$rc ;
         else
            echo OSGi server cache successfully cleaned for $SERVER_CFG_AREA 
         fi
   else
      echo Did not find server config area: $SERVER_CFG_AREA
   fi
   OSGI_CFG=$ORIG_OSGI_CFG
}

# Clears the osgi config from just the profile/<arg>/configuration 
clearProfileCfgForSpecifiedProfile()
{
   # echo clearProfileCfgForSpecifiedProfile
   _PROFILESCRIPT="$WAS_HOME/properties/fsdb/${arg}.sh"
   if [ -f "$_PROFILESCRIPT" ] ; then
      # Note: there is one .sh per profile in the fsdb directory.
      # Each script is named to match the profile name.
      # 
      # Sourcing the fsdb/*.sh file sets up the WAS_USER_SCRIPT
      # environment variable to point to the setupCmdLine.sh in 
      # the profile directory specified by the argument passed
      # to this function.      
      . $_PROFILESCRIPT;
      if [ -f "$WAS_USER_SCRIPT" ]; then
         . $binDir/setupCmdLine.sh
         # Note the property that tells osgi where the osgi configuration is 
         # located is $OSGI_CFG.
         #
         # First clear the profile/configuration cache 
         # echo clearCfgForCurrentProfile
         $JAVA_EXE \
            $OSGI_INSTALL $OSGI_CFG  \
            -classpath $WAS_CLASSPATH \
            -Djava.endorsed.dirs="$WAS_ENDORSED_DIRS" \
            -Dwas.install.root=$WAS_HOME \
            $USER_INSTALL_PROP \
            com.ibm.wsspi.bootstrap.WSPreLauncher -clean -nosplash -application com.ibm.ws.bootstrap.WSLauncher com.ibm.ws.debug.osgi.OsgiCfgInit
         rc=$?;
         if [ $rc -ne 0 ]; then
            echo Clean up failed for profile $USER_INSTALL_ROOT.
            _RETCODE=$rc ;
         else
            echo OSGi profile cache successfully cleaned for ${USER_INSTALL_ROOT}. 
         fi 
      fi
   fi
}

# Clears the osgi profile and server caches in the profile you are 
# executing the command from. 
clearCfgForCurrentProfile()
{
   # Note the property that tells osgi where the osgi configuration is 
   # located is $OSGI_CFG.
   #
   # First clear the profile/configuration cache 
   # echo clearCfgForCurrentProfile
   $JAVA_EXE \
      $OSGI_INSTALL $OSGI_CFG  \
      -classpath $WAS_CLASSPATH \
      -Djava.endorsed.dirs="$WAS_ENDORSED_DIRS" \
      -Dwas.install.root=$WAS_HOME \
      $USER_INSTALL_PROP \
      com.ibm.wsspi.bootstrap.WSPreLauncher -clean -nosplash -application com.ibm.ws.bootstrap.WSLauncher com.ibm.ws.debug.osgi.OsgiCfgInit
   rc=$?;
   if [ $rc -ne 0 ]; then
      echo Clean up failed for profile $USER_INSTALL_ROOT.
      _RETCODE=$rc ;
   else
      echo OSGi profile cache successfully cleaned for ${USER_INSTALL_ROOT}. 
   fi
   
   # Now clear the profile/servers/<ServerName>/configuration cache for
   # each server under this profile
   for j in $USER_INSTALL_ROOT/servers/* ; do
      SERVER_CFG_AREA=$j/configuration
      if [ -d "$SERVER_CFG_AREA" ]; then
         OSGI_CFG=-Dosgi.configuration.area=$SERVER_CFG_AREA
         $JAVA_EXE \
            $OSGI_INSTALL $OSGI_CFG  \
	    -classpath $WAS_CLASSPATH \
	    -Djava.endorsed.dirs="$WAS_ENDORSED_DIRS" \
	    -Dwas.install.root=$WAS_HOME \
	    $USER_INSTALL_PROP \
	    com.ibm.wsspi.bootstrap.WSPreLauncher -clean -nosplash -application com.ibm.ws.bootstrap.WSLauncher com.ibm.ws.debug.osgi.OsgiCfgInit
            rc=$?
         if [ $rc -ne 0 ]; then
            echo Clean up failed for server $j.      
            _RETCODE=$rc ; 
         else
            echo OSGi server cache successfully cleaned for $j.
         fi
      else
         echo Unable to clear OSGi cache for $j, Directory $SERVER_CFG_AREA does not exist 
      fi 
   done;
}

# Clear the osgi cache for the profile specified in the passed arg 
clearCfgForSpecifiedProfile()
{
   # echo clearCfgForSpecifiedProfile $arg
   _PROFILESCRIPT="$WAS_HOME/properties/fsdb/${arg}.sh"
   if [ -f "$_PROFILESCRIPT" ] ; then
      # Note: there is one .sh per profile in the fsdb directory.
      # Each script is named to match the profile name.
      # 
      # Sourcing the fsdb/*.sh file sets up the WAS_USER_SCRIPT
      # environment variable to point to the setupCmdLine.sh in 
      # the profile directory specified by the argument passed
      # to this function.      
      . $_PROFILESCRIPT;
      if [ -f "$WAS_USER_SCRIPT" ]; then
         . $binDir/setupCmdLine.sh
         clearCfgForCurrentProfile
      else
         echo $WAS_USER_SCRIPT file was not found
      fi
   fi
}

# Clear osgi profile and server caches in all profiles 
clearCfgForAllProfiles()
{
   # echo clearCfgForAllProfiles
   for i in $WAS_HOME/properties/fsdb/*.sh ; do
      if [ -f "$i" ]; then
         # Note: there is one .sh per profile in the fsdb directory.
         # Each script is named to match the profile name.
         # 
         # Sourcing the fsdb/*.sh file sets up the WAS_USER_SCRIPT
         # environment variable to point to the setupCmdLine.sh in 
         # the profile directory we intend to process.
         . $i;
         if [ -f "$WAS_USER_SCRIPT" ]; then
            # Run the setupCmdLine from <WAS_INSTALL>/bin
            . $binDir/setupCmdLine.sh
            clearCfgForCurrentProfile
         else
            echo $WAS_USER_SCRIPT file was not found
         fi
      fi
   done;
}
 
# Clear osgi cache locatated in <WAS_HOME>/configuration
clearWASHomeCfg()
{
   # echo clearWASHomeCfg
   OSGI_CFG="-Dosgi.configuration.area=${WAS_HOME}/configuration"
   $JAVA_EXE \
      $OSGI_INSTALL $OSGI_CFG  \
      -classpath $WAS_CLASSPATH \
      -Dwas.install.root=$WAS_HOME \
      -Djava.endorsed.dirs="$WAS_ENDORSED_DIRS" \
      -Duser.install.root=${WAS_HOME} \
      com.ibm.wsspi.bootstrap.WSPreLauncher -clean -nosplash -application com.ibm.ws.bootstrap.WSLauncher com.ibm.ws.debug.osgi.OsgiCfgInit
   rc=$?
   if [ $rc -ne 0 ]; then
      echo Clean up failed for profile $WAS_HOME/configuration.
      _RETCODE=$rc ;
   else
      echo OSGi cache successfully cleaned for $WAS_HOME/configuration.
   fi
}   

# Begin the main body of the script  
binDir=`dirname $0`
. $binDir/setupCmdLine.sh

if [ -f ${JAVA_HOME}/bin/java ]; then
	JAVA_EXE="${JAVA_HOME}/bin/java"
else
	JAVA_EXE="${JAVA_HOME}/jre/bin/java"
fi
   
if [ $# -eq "0" ]; then
   # if the setupCmdLine.bat command is run from a profile, then
   # USER_INSTALL_PROP and USER_INSTALL_ROOT will be set.
   # If we find no default profile then let's cleanup WASHOME.
   if [ -z "$USER_INSTALL_PROP" ] || [ ! -d "$USER_INSTALL_ROOT" ]; then
      echo No default profile found.
      clearWASHomeCfg
   else
      # We are running from a profile/bin or <WAS_HOME>/bin, clear the 
      # osgi caches from /servers/*/configuration and /configuration 
      # Note: in the case where this command is being run from the 
      # <WAS_HOME>/bin directory, the caches of the default profile 
      # are cleared.
      clearCfgForCurrentProfile
   fi
else
   for arg in "$@" ; do
      _ARGCOUNT=`expr $_ARGCOUNT + 1`
      if [ "$_SERVERARGS" = "1" ]; then
         clearCfgForServer $arg
      elif [ "$_PROFILEARG" = "1" ]; then
         clearCfgForSpecifiedProfile $arg
         break
      elif [ "$_PROFILECONFIGARG" = "1" ]; then
         clearProfileCfgForSpecifiedProfile $arg
         break
      else
         case $arg in
            -help)
               printUsage
               break            
               ;;
            -washome)
               clearWASHomeCfg
               break
               ;;
            -servers)
               if [ "$#" -lt "2" ]; then
                  echo Error: No servers were specified
                  printUsage
                  break
               fi
               # set a flag to indicate all further arguments are server 
               # names
               _SERVERARGS=1 
               ;;
            -all)
               clearCfgForAllProfiles
               clearWASHomeCfg
               break
               ;;
            -profile)
               # set a flag to indicate the next argument is a 
               # profile name
               _PROFILEARG=1
               ;;
            -profileConfig)
               # set a flag to indicate the next argument is a 
               # profile name
               _PROFILECONFIGARG=1
               ;;
            *)
               echo input argument $arg not valid
               printUsage 
               break           
               ;;
         esac
      fi
   done
fi

# Do a final check to verify all arguments passed to this script were 
# processed by the main argument do loop. If not, issue a warning 
# message and list the arguments that were ignored.
if [ $_ARGCOUNT -lt "$#" ]; then
   _COUNT=0
   _IGNOREDARGS=""
   for arg in "$@" 
   do
      _COUNT=`expr $_COUNT + 1`
      if [ $_COUNT -gt $_ARGCOUNT ]; then
         _IGNOREDARGS="$_IGNOREDARGS  $arg"
      fi 
   done
   echo Warning - the following arguments were ignored: $_IGNOREDARGS
fi

exit `expr $_RETCODE + $?`
