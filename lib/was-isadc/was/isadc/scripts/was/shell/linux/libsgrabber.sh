#!/bin/sh

if [ $# -ne 2 ]
then
        echo "./libsGrabber.sh <path to executable> <path to core>"
        exit
fi

# check files are executable, core and seq
if file $1 | grep "executable" > /dev/null
then
   if file $2 | grep "core file" > /dev/null
   then

        # Write GDB command script
        echo "file $1" > @gdb_script@
        echo "core $2" >> @gdb_script@
        echo "info share" >> @gdb_script@
        echo "quit" >> @gdb_script@
        gdb < @gdb_script@ > @gdb.log@

        # Filter shared libraries used
        grep -i "Yes" @gdb.log@ | cut -d " " -f 6- | tr -d " " > @libs.log@
        mkdir -p libs
        for i in `cat @libs.log@`
        do
                cp $i libs
        done

        # Tar and gzip it
        rm -f libs.tar.gz
        tar -cvf libs.tar $1 $2 libs/ > /dev/null
        gzip libs.tar
        echo "Done ..."
        echo "Send libs.tar.gz"

        # Delete temporary files
        # rm -rf /tmp/gdb_script /tmp/gdb.log /tmp/libs.log libs
        exit 0
   else
        echo "$2 is not core file"
   fi
else
   echo "$1 is not executable file"
fi

