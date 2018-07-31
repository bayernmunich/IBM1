#!/bin/sh
# Licensed Materials - Property of IBM
#
# (C) Copyright IBM Corp. 2008, 2011 All Rights Reserved
#
# US Government Users Restricted Rights - Use, duplicate or
# disclosure restricted by GSA ADP Schedule Contract with
# IBM Corp.
# IBM_COPYRIGHT_END

#Licensed Materials - Property of IBM
#
#(C) Copyright IBM Corp. 2008-2010 All Rights Reserved
#
#US Government Users Restricted Rights - Use, duplicate or
#disclosure restricted by GSA ADP Schedule Contract with
#IBM Corp.


PROCVALIDATE=/proc/ppc64/rtas/validate_flash
VALIDATE_AUTH=-9002             # RTAS Not Service Authority Partition
exit_status=1
if [ ! -r "$PROCVALIDATE" ]; then
   modprobe rtas_flash || echo "could not load rtas_flash kernel module" ;
   exit 1
fi

if [ -e "/proc/device-tree/rtas/ibm,manage-flash-image" ]; then
    grep \\"$VALIDATE_AUTH" "$PROCVALIDATE" > /dev/null
    if [ "$?" -ne 0 ]; then
       # validate-flash did not return "not authorized"
       head --bytes=4k /dev/zero > $PROCVALIDATE 2>/dev/null
       grep 1 "$PROCVALIDATE" > /dev/null
       if [ "$?" -ne 0 ]; then
          # validate-flash did not return "not authorized"
          exit_status=0
       fi
    fi
else
    if [ -e "/proc/device-tree/rtas/ibm,update-flash-64-and-reboot"] || [ -e "/proc/device-tree/rtas/udpate-flash-and-reboot"]; then
        exit_status=0
    fi
fi

if [ $exit_status -ne 0 ]; then
    echo update_flash: flash image cannot be managed from this partition
else
    echo update_flash: flash image management is supported
fi

exit $exit_status;
