#!/bin/sh
chdev -a fullcore=true -lsys0
chuser fsize=-1 data=-1 core=-1 root
