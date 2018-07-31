#!/bin/sh
# Licensed Materials - Property of IBM
#
# (C) Copyright IBM Corp. 2010, 2011 All Rights Reserved
#
# US Government Users Restricted Rights - Use, duplicate or
# disclosure restricted by GSA ADP Schedule Contract with
# IBM Corp.
# IBM_COPYRIGHT_END


sw=`pkginfo -c application -i | tr -s ' ' ',' | cut -d , -f 2`

for swName in $sw 
  do
    pkgoutput=`pkginfo -l $swName`
    name=`echo "$pkgoutput" | grep NAME | sed 's/:  /:/' | cut -d : -f 2`
    version=`echo "$pkgoutput" | grep VERSION | sed 's/:  /:/' | cut -d : -f 2 | sed 's/.DSP/,/' | cut -d , -f 1`
    vendor=`echo "$pkgoutput" | grep VENDOR | sed 's/:  /:/' | cut -d : -f 2`
    instdate=`echo "$pkgoutput" | grep INSTDATE | sed 's/:  /:/' | cut -d : -f 2`
    instloc=`echo "$pkgoutput" | grep BASEDIR | sed 's/:  /:/' | cut -d : -f 2`
    desc=`echo "$pkgoutput" | grep DESC | sed 's/:  /:/' | cut -d : -f 2`
    echo "$swName|$name|$version|$vendor|$instdate|$instloc|$desc"
done
