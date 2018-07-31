#!/bin/sh
# The command line argument (parameter) is the location + filename of the core file.

CORE_FILE=@core.path@

#Names of the p* files produced. Can be changed if multiple cores are to be analyzed.
PSTACK_FILE=@pstack_crash.out@
PMAP_FILE=@pmap_crash.out@
PLDD_FILE=@pldd_crash.out@
RESULTS_FILE=solaris_crash_RESULTS.tar

# Gather environment information.
env > env.out
ulimit -a > ulimit.out
uname -a > uname.out
showrev -p > showrev.out
pkginfo -l > pkginfo.out
ls -al $CORE_FILE > ls.out

# The core file is analyzed for thread information:
/usr/proc/bin/pstack $CORE_FILE > $PSTACK_FILE
/usr/proc/bin/pmap $CORE_FILE > $PMAP_FILE
/usr/proc/bin/pldd $CORE_FILE > $PLDD_FILE

# Gather all produced files and compress
tar -cvf $RESULTS_FILE env.out ulimit.out uname.out showrev.out pkginfo.out ls.out $PSTACK_FILE $PMAP_FILE $PLDD_FILE
gzip $RESULTS_FILE

#rm env.out ulimit.out uname.out showrev.out pkginfo.out ls.out $PSTACK_FILE $PMAP_FILE $PLDD_FILE

echo "Files have been gzipped into the following file: solaris_crash_RESULTS.tar.gz"
echo "Please submit this file along with the other files mentioned in the MustGather."
echo "IMPORTANT: If you are processing multiple core files, please rename the "
echo " solaris_crash_RESULTS.tar.gz for each core file generated."


