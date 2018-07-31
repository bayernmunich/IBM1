#!/bin/sh
# // THIS PRODUCT CONTAINS RESTRICTED MATERIALS OF IBM
# // 5724-I63, 5724-H88, 5655-N01, 5733-W61 (C) COPYRIGHT International Business Machines Corp., 1997,2006
# // All Rights Reserved * Licensed Materials - Property of IBM
# // US Government Users Restricted Rights - Use, duplication or disclosure
# // restricted by GSA ADP Schedule Contract with IBM Corp.
#
# //  DESCRIPTION: This script is called from setupCmdLine.sh and setupClient.sh
################################################################################
. $WAS_HOME/properties/sdk/cmdDefaultSDK.properties

COMMAND_SDK=${COMMAND_DEFAULT_SDK}

PLATFORM=`/bin/uname`

case $PLATFORM in

	OS/390)
		set -o logical
	;;
esac

if [ "${USE_HIGHEST_AVAILABLE_SDK}" = "true" ]; then
   if [ -f ${WAS_HOME}/bin/sdk/_highest_available_sdk.sh ]; then
       . ${WAS_HOME}/bin/sdk/_highest_available_sdk.sh
       COMMAND_SDK=${HIGHEST_AVAILABLE_SDK}
   fi    
fi


USE_COMMAND_OVERRIDE_SDK=true
COMMAND_OVERRIDE_SDK=_system
if [ "${USE_COMMAND_OVERRIDE_SDK}" = "true" ]; then
  if [ "${COMMAND_OVERRIDE_SDK}" != "" ]; then
     COMMAND_SDK=${COMMAND_OVERRIDE_SDK}
  fi    
fi 

. $WAS_HOME/bin/sdk/_setupsdk${COMMAND_SDK}.sh

