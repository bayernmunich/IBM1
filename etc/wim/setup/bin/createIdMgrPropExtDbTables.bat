@echo off 
rem --------------- Begin Copyright - Do not add comments here --------------
rem --
rem -- Licensed Materials - Property of IBM
rem --
rem -- Restricted Materials of IBM
rem --
rem -- Virtual member manager
rem --
rem -- (C) Copyright IBM Corp. 2009, 2010
rem --
rem -- US Government Users Restricted Rights - Use, duplication or
rem -- disclosure restricted by GSA ADP Schedule Contract with
rem -- IBM Corp.
rem --
rem ----------------------------- End Copyright -----------------------------

rem Script to create tables for Property Extension database

setlocal 


set DBHOME=
set DBNAME=
set DBUSER=
set DBPASS=
set SQLDIR=
set DBTYPE=
set DBIHOM=
set DBSCHE=

if (%1)==() goto Usage

rem Parse command line arguments
:LOOP
    if (%1)==(-h) goto Usage
    if (%1)==(-?) goto Usage 
    if (%1)==(-b) goto SETDBHOME
    if (%1)==(-n) goto SETDBNAME
    if (%1)==(-u) goto SETDBUSER
    if (%1)==(-p) goto SETDBPASS
    if (%1)==(-s) goto SETSQLDIR
    if (%1)==(-t) goto SETDBTYPE
    if (%1)==(-d) goto SETDBSCHEMA
    shift
    if not (%1)==() goto LOOP
goto CKPARAM 

:SETDBHOME
    shift
    if not (%1)==() (set DBHOME=%~f1)
    shift 
goto LOOP

:SETDBNAME
    shift
    if not (%1)==() (set DBNAME=%1)
    shift
goto LOOP

:SETDBUSER
    shift
    if not (%1)==() (set DBUSER=%1)
    shift
goto LOOP

:SETDBPASS
    shift
    if not (%1)==() (set DBPASS=%1)
    shift
goto LOOP

:SETSQLDIR
    shift
    if not (%1)==() (set SQLDIR=%~f1)
    shift
goto LOOP

:SETDBTYPE
    shift
    if not (%1)==() (set DBTYPE=%1)
    shift
goto LOOP

:SETDBSCHEMA
    shift
    if not (%1)==() (set DBSCHE=%1)
    shift
goto LOOP


:CKPARAM 
    if not defined DBTYPE goto Usage 
    if not defined DBHOME goto Usage
    if not defined DBNAME goto Usage
    if not defined SQLDIR goto Usage
    if "%DBTYPE%"=="derby"  goto Derby
    if not defined DBUSER goto Usage
    if not defined DBPASS goto Usage 

:MAIN

   set START_MSG="Running SQL files..."
   set END_MSG="Property Extension database tables created successfully. Use the setupIdMgrPropertyExtensionRepositoryTables wsadmin command to populate the tables."
   
   if "%DBTYPE%"=="db2" goto DB2 
   if "%DBTYPE%"=="oracle" goto Oracle
   if "%DBTYPE%"=="informix" goto Informix
   if "%DBTYPE%"=="sqlserver" goto SqlServer 

   echo "Database type parameter is invalid." 

goto END


:DB2
 
   echo "Creating database %DBNAME% ...."

   db2 create database %DBNAME%
   db2 connect to %DBNAME% user %DBUSER% using %DBPASS%
   if not (%DBSCHE%)==() (
   	echo "Creating Schema  %DBSCHE% ...."
   	db2 CREATE SCHEMA %DBSCHE%
   )
   echo %START_MSG%
   db2 -tf "%SQLDIR%\db2\schema.sql"
   db2 -tf "%SQLDIR%\db2\primarykeys.sql"
   db2 -tf "%SQLDIR%\db2\indexes.sql"
   db2 -tf "%SQLDIR%\db2\references.sql"
   db2 -tf "%SQLDIR%\keys.sql"
   db2 -tf "%SQLDIR%\bootstrap.sql"

   echo %END_MSG%

goto END

:Oracle

   set ORACLE_HOME=%DBHOME%
   set ORACLE_SID=%DBNAME%

   echo %START_MSG%
   echo quit | "%DBHOME%\bin\sqlplus" %DBUSER%/%DBPASS% as sysdba @"%SQLDIR%\oracle\schema.sql"  
   echo quit | "%DBHOME%\bin\sqlplus" %DBUSER%/%DBPASS% as sysdba @"%SQLDIR%\oracle\primarykeys.sql"
   echo quit | "%DBHOME%\bin\sqlplus" %DBUSER%/%DBPASS% as sysdba @"%SQLDIR%\oracle\indexes.sql"
   echo quit | "%DBHOME%\bin\sqlplus" %DBUSER%/%DBPASS% as sysdba @"%SQLDIR%\oracle\references.sql"
   echo quit | "%DBHOME%\bin\sqlplus" %DBUSER%/%DBPASS% as sysdba @"%SQLDIR%\keys.sql"
   echo quit | "%DBHOME%\bin\sqlplus" %DBUSER%/%DBPASS% as sysdba @"%SQLDIR%\bootstrap.sql"
   
   echo %END_MSG%

goto END

:Informix

   set INFORMIXDIR=%DBHOME%
   set INFORMIXSERVER=demo_on
   set ONCONFIG=ONCONFIG.demo_on
   set PATH=%DBHOME%\bin;%PATH%
   set CLASSPATH=%INFORMIXDIR%\extend\krakatoa\krakatoa.jar;%INFORMIXDIR%\extend\krakatoa\jdbc.jar;%CLASSPATH%
   set DBTEMP=%DBHOME%\infxtmp
   set CLIENT_LOCALE=EN_US.CP1252
   set DB_LOCALE=EN_US.8859-1
   set SERVER_LOCALE=EN_US.CP1252
   set DBLANG=EN_US.CP1252
   mode con codepage select=1252
   
   del "%SQLDIR%\infor_tmp.sql"   

   echo "Creating database %DBNAME%"
   echo create database %DBNAME% ; >> "%SQLDIR%\infor_tmp.sql"
   echo connect to '%DBNAME%' user '%DBUSER%' using '%DBPASS%' ; >> "%SQLDIR%\infor_tmp.sql"

   "%DBHOME%\bin\dbaccess" - "%SQLDIR%\infor_tmp.sql"
   echo %START_MSG%
   "%DBHOME%\bin\dbaccess" %DBNAME% "%SQLDIR%\informix\schema.sql"
   "%DBHOME%\bin\dbaccess" %DBNAME% "%SQLDIR%\informix\primarykeys.sql"
   "%DBHOME%\bin\dbaccess" %DBNAME% "%SQLDIR%\informix\indexes.sql"
   "%DBHOME%\bin\dbaccess" %DBNAME% "%SQLDIR%\informix\references.sql"
   "%DBHOME%\bin\dbaccess" %DBNAME% "%SQLDIR%\keys.sql" 
   "%DBHOME%\bin\dbaccess" %DBNAME% "%SQLDIR%\bootstrap.sql"

   echo %END_MSG%

   rem del "%SQLDIR%\infor_tmp.sql"  
goto END

:SqlServer 

   set DbUser=%DBUSER%  
   set DbName=%DBNAME%

   echo "Creating database %DBNAME% ...."
   %DBHOME%\binn\sqlcmd -S %COMPUTERNAME% -U%DBUSER% -P%DBPASS% -Q "create database %DBNAME%"
   
   if not (%DBSCHE%)==() (
   	echo "Creating Schema  %DBSCHE% ...."
 
 	%DBHOME%\binn\sqlcmd -S %COMPUTERNAME% -d%DBNAME% -Q "CREATE SCHEMA %DBSCHE%"
   ) 
   
   echo %START_MSG%
   %DBHOME%\binn\sqlcmd -S %COMPUTERNAME% -d%DBNAME% -i %SQLDIR%\sqlserver\schema.sql
   %DBHOME%\binn\sqlcmd -S %COMPUTERNAME% -d%DBNAME% -i %SQLDIR%\sqlserver\primarykeys.sql
   %DBHOME%\binn\sqlcmd -S %COMPUTERNAME% -d%DBNAME% -i %SQLDIR%\sqlserver\indexes.sql
   %DBHOME%\binn\sqlcmd -S %COMPUTERNAME% -d%DBNAME% -i %SQLDIR%\sqlserver\references.sql
   %DBHOME%\binn\sqlcmd -S %COMPUTERNAME% -d%DBNAME% -i %SQLDIR%\sqlserver\keys.sql
   %DBHOME%\binn\sqlcmd -S %COMPUTERNAME% -d%DBNAME% -i %SQLDIR%\sqlserver\bootstrap.sql

   echo %END_MSG%

goto END


:Derby

    del "%SQLDIR%\der_tmp.sql"

    set DERBY_HOME="%DBHOME%"
    
    echo connect 'jdbc:derby:%DBNAME%;create=true'; >> "%SQLDIR%\der_tmp.sql"
    if not (%DBSCHE%)==() (
       	echo "Creating Schema  %DBSCHE% ...."	
	echo CREATE SCHEMA %DBSCHE%; >> "%SQLDIR%\der_tmp.sql"
    )
    echo run '%SQLDIR%\derby\schema.sql' ; >> "%SQLDIR%\der_tmp.sql"
    echo run '%SQLDIR%\derby\primarykeys.sql' ; >> "%SQLDIR%\der_tmp.sql"
    echo run '%SQLDIR%\derby\indexes.sql' ; >> "%SQLDIR%\der_tmp.sql"
    echo run '%SQLDIR%\derby\references.sql' ; >> "%SQLDIR%\der_tmp.sql"
    echo run '%SQLDIR%\keys.sql' ; >> "%SQLDIR%\der_tmp.sql"
    echo run '%SQLDIR%\bootstrap.sql' ; >> "%SQLDIR%\der_tmp.sql"
    
    echo "Creating database and running SQL files..."

    if exist "%DBHOME%\bin\networkServer" goto NetworkDerby 
    
    %DBHOME%\bin\ij.bat "%SQLDIR%\der_tmp.sql" goto Cleanup
    
    :NetworkDerby 
       
       %DBHOME%\bin\networkServer\ij.bat "%SQLDIR%\der_tmp.sql" 
     
    :Cleanup

       del %SQLDIR%\der_tmp.sql 
       echo %END_MSG%
   
goto END

:Usage

    echo  Usage:  %0 Creates tables for property extension database for federated repositories. Command parameters are:
    echo  -h   Help message
    echo  -t   Database type, valid value is one of db2, oracle, informix, sqlserver and derby 
    echo  -u   Database administrator userid  
    echo  -p   Database administrator password  
    echo  -b   Database home directory
    echo  -n   Database name to connect to 
    echo         In case of Oracle, use ORACLE_SID
    echo  -s   Location of 'vmm_install'\setup directory
    echo  -d   Database Schema
    echo  Note: All parameters are required (except -h)
    echo        For Derby database, only -t, -b, -n and -s parameters are required.
    echo 	In case of oracle DB script uses exsisting ideal database for creating tables.
    echo 	In case of informix demo_on named informix server should be exsisted.
    echo 	In case of sqlserver %computername% server should be exsisted. 
    echo 	For oracle schema should already exist in the specified database.

    
goto END


:END

endlocal
