#!/bin/sh

#try to call setupCMDLine.sh
if [ -r "../bin/setupCmdLine.sh" ]; then
cd ../bin
. ./setupCmdLine.sh
fi

cd ${AUTOPD_HOME}
