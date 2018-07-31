#!/bin/sh
/usr/proc/bin/pstack @core.path@ >@pstack.out@
/usr/proc/bin/pmap @core.path@ >@pmap.out@
/usr/proc/bin/pldd @core.path@ >@pldd.out@
