#!/bin/sh
ls -al @core.path@ > @timestamp.out@
gdb -x @gdb.command@ @java.path@ @core.path@ > @gdb.trace.output@
