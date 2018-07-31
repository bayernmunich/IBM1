#!/bin/ksh
#--------------- Begin Copyright - Do not add comments here --------------
#--
#-- Licensed Materials - Property of IBM
#--
#-- Restricted Materials of IBM
#--
#-- Virtual member manager
#--
#-- (C) Copyright IBM Corp. 2009, 2010
#--
#-- US Government Users Restricted Rights - Use, duplication or
#-- disclosure restricted by GSA ADP Schedule Contract with
#-- IBM Corp.
#--
#----------------------------- End Copyright -----------------------------

#Script to create tables for Property Extension database

usage()
{
cat << EOF
Usage:  $0 Creates tables for a property extension database for federated repositories. Command parameters are:

OPTIONS: 
   -h	Help message 
   -t   Database type, valid value is one of db2, oracle, informix and derby 
   -u   Database administrator userid  
   -p   Database administrator password 
   -b   Database home directory 
   -n   Database name to connect to 
          In case of oracle, use ORACLE_SID
   -s   Location of 'vmm_install'/setup directory
   -i   Database instance home directory
        Required only when Database type is DB2
   -d   Database schema
   Note: Except -h -i and -d all parameters are required, 
         For Derby database, only -t, -b, -n and -s parameters are required.
         For DB2 database, -i parameter is required.          
         In case of oracle DB script uses exsisting ideal database for creating tables.
         In case of informix demo_on named informix server should be exsisted.
         For oracle schema should already exist in the specified database.

EOF
}

DB_HOME=
DB_NAME=
DB_USER=
DB_PASSWORD=
DB_INSTANCE_HOME=
SQL_DIR=
DB_TYPE=
DB_SCHE=

while getopts "hb:n:u:p:i:s:t:w:d" OPTION
do
     case $OPTION in
         h)
             usage
             exit 1
             ;;
         b)
             DB_HOME=$OPTARG
             ;;
         n)
             DB_NAME=$OPTARG
             ;;
         u)
             DB_USER=$OPTARG
             ;;
         p)
             DB_PASSWORD=$OPTARG
             ;;
         i)
             DB_INSTANCE_HOME=$OPTARG
             ;;
	 s)
             SQL_DIR=$OPTARG 
	     ;;
	 t)
             DB_TYPE=$OPTARG
             ;;
         d)
	     DB_SCHE=$OPTARG
             ;;
  	?)
             usage
             exit
             ;;

     esac
done

if [[ -z $DB_HOME ]] || [[ -z $DB_NAME ]]  || [[ -z $SQL_DIR ]] || [[ -z $DB_TYPE ]]
then
     usage
     exit 1
fi

if [ $DB_TYPE = !"derby" ]
then	 
	 if [[ -z $DB_USER ]] || [[ -z $DB_PASSWORD ]]
	 then 
		usage
       		exit 1 
         fi
fi	 


if [ $DB_TYPE = "db2" ]
then 
    if [[ -z $DB_INSTANCE_HOME ]]
    then 
	usage
	exit 1
    fi
fi		

START_MSG="Running SQL files..."
END_MSG="Property Extension database tables created successfully. Use the setupIdMgrPropertyExtensionRepositoryTables wsadmin command to populate the tables."

	
if [ $DB_TYPE = "db2" ] 
then 
	echo "Creating database $DB_NAME ...."
        . $DB_INSTANCE_HOME/sqllib/db2profile
	$DB_HOME/bin/db2 create database $DB_NAME
        db2start
	$DB_HOME/bin/db2 connect to $DB_NAME  user $DB_USER using $DB_PASSWORD
	if [ $DB_TYPE = !"" ] 
	then
		echo "Creating db schema $DB_SCHE ...."
 		$DB_HOME/bin/db2 CREATE SCHEMA $DB_SCHE
 	fi
	echo $START_MSG 
	$DB_HOME/bin/db2 -tf $SQL_DIR/db2/schema.sql
	$DB_HOME/bin/db2 -tf $SQL_DIR/db2/primarykeys.sql
	$DB_HOME/bin/db2 -tf $SQL_DIR/db2/indexes.sql
	$DB_HOME/bin/db2 -tf $SQL_DIR/db2/references.sql
        $DB_HOME/bin/db2 -tf $SQL_DIR/keys.sql
	$DB_HOME/bin/db2 -tf $SQL_DIR/bootstrap.sql

	echo $END_MSG


elif [ $DB_TYPE = "oracle" ]
then
        ORACLE_HOME=$DB_HOME
        ORACLE_SID=$DB_NAME
        export ORACLE_HOME
        export ORACLE_SID   
        
       	echo $START_MSG 
	$DB_HOME/bin/sqlplus /nolog << EOF
        connect $DB_USER/$DB_PASSWORD as sysdba
	
        @$SQL_DIR/oracle/schema.sql schema.sql
        @$SQL_DIR/oracle/primarykeys.sql primarykeys.sql 
	@$SQL_DIR/oracle/indexes.sql indexes.sql
	@$SQL_DIR/oracle/references.sql references.sql
	@$SQL_DIR/keys.sql keys.sql
	@$SQL_DIR/bootstrap.sql bootstrap.sql
        EXIT
EOF
	echo $END_MSG

elif [ $DB_TYPE = "informix" ]
then
        echo " Creating database $DB_NAME "
        INFORMIXDIR=$DB_HOME
        INFORMIXSERVER=demo_on
        export INFORMIXDIR
        export INFORMIXSERVER
       
        echo " Creating database $DB_NAME " 	
        echo " create database $DB_NAME ; " > /tmp/informix.sql
	echo " connect to '$DB_NAME' user '$DB_USER' using '$DB_PASSWORD' " >> /tmp/informix.sql 

	$DB_HOME/bin/dbaccess -  /tmp/informix.sql
	echo $START_MSG
	$DB_HOME/bin/dbaccess $DB_NAME $SQL_DIR/informix/schema.sql
	$DB_HOME/bin/dbaccess $DB_NAME $SQL_DIR/informix/primarykeys.sql
	$DB_HOME/bin/dbaccess $DB_NAME $SQL_DIR/informix/indexes.sql
	$DB_HOME/bin/dbaccess $DB_NAME $SQL_DIR/informix/references.sql
	$DB_HOME/bin/dbaccess $DB_NAME $SQL_DIR/keys.sql
	$DB_HOME/bin/dbaccess $DB_NAME $SQL_DIR/bootstrap.sql

	echo $END_MSG
	rm -f /tmp/informix.sql

elif [ $DB_TYPE = "derby" ]
then 
	DERBY_HOME=$DB_HOME
	export PATH
	export DERBY_HOME

	echo " connect 'jdbc:derby:$DB_NAME;create=true'; " > /tmp/derby.sql
	if [ $DB_TYPE = !"" ] 
	then
		echo "Creating db schema $DB_SCHE ...."
    		echo " CREATE SCHEMA %DBSCHE%; " > /tmp/derby.sql
	fi

	echo " run '$SQL_DIR/derby/schema.sql' ; " >>  /tmp/derby.sql
	echo " run '$SQL_DIR/derby/primarykeys.sql' ; " >>  /tmp/derby.sql
	echo " run '$SQL_DIR/derby/indexes.sql' ; " >>  /tmp/derby.sql
	echo " run '$SQL_DIR/derby/references.sql' " ; >> /tmp/derby.sql
	echo " run '$SQL_DIR/keys.sql' " ; >> /tmp/derby.sql
	echo " run '$SQL_DIR/bootstrap.sql' " ; >> /tmp/derby.sql

        echo " Creating Database $DB_NAME and running SQL files "

	if [[ -d $DB_HOME/bin/networkServer ]]
	then 
		$DERBY_HOME/bin/networkServer/ij.sh /tmp/derby.sql
	else
		$DERBY_HOME/bin/ij.sh /tmp/derby.sql
	fi

	echo $END_MSG

	rm -f /tmp/derby.sql

fi
