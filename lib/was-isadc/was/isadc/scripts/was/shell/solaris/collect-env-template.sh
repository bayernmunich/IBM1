#!/bin/sh
env > @env.out@
ulimit -a > @ulimit.out@
uname -a > @uname.out@
showrev -p >@showrev.out@
pkginfo -l > @pkginfo.out@
