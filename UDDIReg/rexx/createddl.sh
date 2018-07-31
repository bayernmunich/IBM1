/* rexx                                                              */
/*-------------------------------------------------------------------*/
/*                                                                   */        
/* createddl.sh                                                      */
/*                                                                   */   
/*-------------------------------------------------------------------*/
/*                                                                   */
/* INVOCATION: createddl.sh <database name> <tablespace name> <hlq>  */
/*                                                                   */
/* PARAMETERS: database name - name to be used in the generated      */
/*                             CREATE TABLE statements               */
/*                                                                   */
/*           tablespace name - name to be used in the generated      */
/*                             CREATE TABLE statements               */
/*                                                                   */
/*                      hlq  - high-level qualifier used to allocate */
/*                             target partitioned dataset            */
/*                                                                   */
/*                                                                   */
/* INPUT: DB2 DDL statements in <WASHome>/UDDIReg/databaseScripts    */
/*        Sample JCL in         <WASHome>/UDDIReg/jcl                */
/*                                                                   */
/* OUTPUT: Converted DDL in PDS <IBMUSER>.UDDI.SQL(membername)       */
/*         Converted JCL in PDS <IBMUSER>.UDDI.JCL(membername)       */
/*                                                                   */
/*-------------------------------------------------------------------*/
/*                                                                   */
/*                                                                   */
/* This exec will convert the DB2 DDL statements supplied in the     */
/* directory <WASHome>/UDDIReg/databaseScripts into a format which   */
/* can be processed by DSNTIAD, they are:                            */
/*                                                                   */
/*  1) Converted to EBCDIC                                           */
/*  2) Records are converted to 80-bytes                             */
/*  3) Copied as memebers of a partioned dataset                     */
/*                                                                   */
/*  The output members are:                                          */
/*  TABLE                                                            */
/*  TABLE7                                                           */
/*  INDEX                                                            */
/*  VIEW                                                             */
/*  TRIGGER                                                          */
/*  ALTER                                                            */
/*  INITIAL                                                          */
/*  INSERT                                                           */
/*                                                                   */
/* TABLE and TABLE7 are alternative files used for DB2 V7 and V8     */
/* databases respectively, all the other generated files are common  */
/* to both V7 and V8.                                                */
/*                                                                   */
/* The exec also converts to EBCDIC and copies to a PDS the sample   */
/* JCL for processing the generated DDL members                      */
/*                                                                   */
/* The output members are MAKEDB71 and MAKEDB81, which are the       */
/* samples for generating a V7 and V8 database respectively.         */
/*                                                                   */
/*                                                                   */
/*                                                                   */
/*-------------------------------------------------------------------*/

/*-------------------------------------------------------------------*/
/* Check parameters and assign default values                        */ 
/*-------------------------------------------------------------------*/
select;
   when __argv.0 = 1 then do;
      database_name   = "uddi30" ; 
      tablespace_name = "uddi30ts" ;
      HLQ             = "IBMUSER" 
   end;
   when __argv.0 = 2 then do;
      database_name   = __argv.2 ; 
      tablespace_name = database_name"ts" ; 
      HLQ             = "IBMUSER"
   end;
   when __argv.0 = 3 then do;
      database_name   = __argv.2 ;
      tablespace_name = __argv.3 ;
      HLQ             = "IBMUSER" ;
   end;
   when __argv.0 = 4 then do;
      database_name   = __argv.2 ;
      tablespace_name = __argv.3 ;
      HLQ             = __argv.4 ;
   end;
   otherwise do;
      say "Usage: createddl.sh <database name> <tablespace name> <hlq>"
      return;
   end;
end;

say "database.tablespace = "database_name"."tablespace_name;
say "HLQ = "HLQ


/*-------------------------------------------------------------------*/
/* Define some constants                                             */
/*-------------------------------------------------------------------*/
root_dir = "/WebSphere/V6R0M0/AppServer/UDDIReg"
temp_dir = "/tmp/udditmp"

sqlfile.1  = "uddi30crt_10_prereq_db2.sql"
sqlfile.2  = "uddi30crt_20_tables_generic.sql"
sqlfile.3  = "uddi30crt_25_tables_db2udb.sql"
sqlfile.4  = "uddi30crt_30_constraints_generic.sql"
sqlfile.5  = "uddi30crt_35_constraints_db2udb.sql"
sqlfile.6  = "uddi30crt_40_views_generic.sql"
sqlfile.7  = "uddi30crt_45_views_db2udb.sql"
sqlfile.8  = "uddi30crt_50_triggers_db2udb.sql"
sqlfile.9  = "uddi30crt_60_insert_initial_static_data.sql"
sqlfile.10 = "uddi30crt_70_insert_default_database_indicator.sql"

NUM_SQL_FILES = 10

/*-------------------------------------------------------------------*/
/* Initialize counters                                               */
/*-------------------------------------------------------------------*/
j  = 1;
k  = 1;
x  = 1;
y  = 1;
g  = 1;
n  = 1;
m  = 1;
ix = 1;
cx = 1;
tx = 1;


/*-------------------------------------------------------------------*/
/* Insert create statements in TABLE and TABLE7                      */
/*-------------------------------------------------------------------*/
outcreatetable.k  = "set current rules='STD';"; k = k + 1;
outcreatetable.k  = "create database "database_name" bufferpool bp32k"; k = k + 1;                                 
outcreatetable.k  = "       ccsid unicode;"; k = k + 1;                                 
outcreatetable.k  = "create tablespace "tablespace_name" in "database_name";"; k = k + 1;

outcreatetable7.j = "set current rules='STD';"; j = j + 1;
outcreatetable7.j = "create database "database_name" bufferpool bp32k"; j = j + 1; 
outcreatetable7.j = "       ccsid unicode;"; j = j + 1;                                 
outcreatetable7.j = "create tablespace "tablespace_name" in "database_name";"; j = j + 1;

/*-------------------------------------------------------------------*/
/* Process each input file in turn                                   */
/*-------------------------------------------------------------------*/
do file_number =  1 to NUM_SQL_FILES
   
   /* Set up command to convert file to ebcdic                             */  
   command = "/bin/iconv -f ISO8859-1 -t IBM-1047 "root_dir"/databaseScripts/"sqlfile.file_number;

   /* Convert to ebcdic and read file into stem 'sql.'                     */
   call bpxwunix command,,sql.
   
   say "("right(sql.0,4)") "root_dir"/databaseScripts/"sqlfile.file_number;

   /* Process records read in                                              */
   do i = 1 to sql.0;

      sql.i = space(sql.i);                     /* get rid of extra spaces */

      if (substr(sql.i,1,2) = "--") then iterate; /* skip comments and     */
      if (length(sql.i) = 0 )       then iterate; /*    blank lines        */


      /* say "<"sql.i">"; */


      /*-------------------------------------------------------------------*/
      /* Find out what sort of record this is                              */
      /*-------------------------------------------------------------------*/
      parse upper var sql.i verb obj .
      /* say verb; */
      select;

         /*----------------------------------------------------------------*/
         /* We have a create                                               */
         /*----------------------------------------------------------------*/
         when (verb =  "CREATE") then do;
            select;
               /*----------------------------------------------------------*/
               /*  create table                                            */
               /*----------------------------------------------------------*/
               when (obj = "TABLE") then do;
                  createtable = sql.i
                  do until(verify(createtable,";","M") > 0);
                     i=i+1;
                     createtable = createtable" "space(sql.i);
                  end;

                  parse var createtable createtablename "(" columns ");" .

                  outcreatetable.k  = createtablename"("; k = k + 1;
                  outcreatetable7.j = createtablename"("; j = j + 1;

                  parse var columns column "," columns;

                  do while (columns ^= "");
                     
                     column7 = column;
                     call checkcolumn;
                     
                     outcreatetable.k = "        "column",";  k = k + 1;
                     outcreatetable7.j = "       "column7","; j = j + 1;
                     
                     parse var columns column "," columns;

                  end;
                  
                  column7 = column;
                  call checkcolumn;

                  
                  outcreatetable.k  = column" ) in "database_name"."tablespace_name";";  k = k + 1;
                  outcreatetable7.j = column7" ) in "database_name"."tablespace_name";"; j = j + 1;
               end;
               
               /*----------------------------------------------------------*/
               /*  create trigger                                          */
               /*----------------------------------------------------------*/
               when (obj = "TRIGGER") then do;
                  
                  createtrigger = "create trigger ibmudi30.trig"tx" \"; tx = tx + 1;
                 
                  do until(wordpos("end",createtrigger) > 0);
                     i=i+1;
                     createtrigger = createtrigger" "sql.i;
                  end;

                  do until (createtrigger = "");
                     parse var createtrigger line "\" createtrigger;
                     line = space(line);
                     do while (length(line) > 72);
                        split = pos(" ",line,25);
                        outcreatetrigger.g = left(line,split)" "; g = g + 1;
                        line = right(line,(length(line)-split)); 
                        line = space(line);
                     end;

                     outcreatetrigger.g = line; g = g + 1;
                  
                  end;
                  
                  outcreatetrigger.g = "#"; g = g + 1;
               end;

               /*----------------------------------------------------------*/
               /* create index                                             */
               /*----------------------------------------------------------*/
               when (obj = "INDEX") then do;               
                  createindex = sql.i
                  do until(verify(createindex,";","M") > 0);
                     i=i+1;
                     createindex = createindex" "space(sql.i);
                  end;
                  
                  /*------------------------------------------------------*/
                  /* Add PRIQTY for valueset index                        */
                  /*------------------------------------------------------*/
                  usingstr=""
                  parse upper var createindex . "ON" tablename "(" .
                  
                  if tablename = "IBMUDI30.VALUESET" then do;
                     usingstr = " using stogroup sysdeflt priqty 256 secqty 256";
                  end;
                  
                  /*------------------------------------------------------*/
                  /* Skip indices for these tables                        */
                  /*------------------------------------------------------*/
                  if (tablename ^= "IBMUDI30.PHONE" & tablename ^= "IBMUDI30.ADDRESS" & tablename ^= "IBMUDI30.ADDRLINE" ) 
                  then do;
                  
                     if (length(createindex)>72) then do;
                        parse var createindex createindexname "(" columns ");" .

                        outcreateindex.x = createindexname"("; x = x + 1;

                        parse var columns column "," columns;

                        do while (columns ^= "");
                           outcreateindex.x = "       "column","; x = x + 1;
                           parse var columns column "," columns;
                        end;
                     
                        outcreateindex.x = column ")"usingstr";"; x = x + 1;
                     
                     end;
                     else do;
                        outcreateindex.x = createindex; x = x + 1;
                     end;
                  end;
               end;
               
               /*----------------------------------------------------------*/
               /* create view                                              */
               /*----------------------------------------------------------*/
               when (obj = "VIEW") then do;

                  do until(verify(sql.i,";","M") > 0);
                     do while (length(sql.i) > 72);
                        split = pos(" ",sql.i,25);
                        outcreateview.y = left(sql.i,split); y = y + 1;
                        sql.i = right(sql.i,(length(sql.i)-split));  
                     end;
                     
                     outcreateview.y = sql.i; y = y + 1;
                     
                     i = i + 1;
                     sql.i = space(sql.i);                     /* get rid of extra spaces */

                  end;

                  do while (length(sql.i) > 72);
                     split = pos(" ",sql.i,25);
                     outcreateview.y = left(sql.i,split); y = y + 1;
                     sql.i = right(sql.i,(length(sql.i)-split));  
                  end;
                  
                  outcreateview.y = sql.i; y = y + 1;
                  
                  i = i + 1;
                  sql.i = space(sql.i);                     /* get rid of extra spaces */


               end;
               
               /*----------------------------------------------------------*/
               /* create sequence                                          */
               /*----------------------------------------------------------*/
               when (obj = "SEQUENCE") then do;
                   /* ignore sequence for now */
               end;
               /*----------------------------------------------------------*/
               /* otherwise                                                */
               /*----------------------------------------------------------*/
               otherwise do;
                  say "Unknown create type record is - "sql.i ;
               end;
            end;
         end;

         /*----------------------------------------------------------------*/
         /*  We have an alter statement                                    */
         /*----------------------------------------------------------------*/
         when (verb =  "ALTER") then do;

            altertable = sql.i                                              
            do until(verify(altertable,";","M") > 0);                       
               i=i+1;                                                        
               altertable = altertable" "space(sql.i);  
            end;

            usingstr=""
            parse var altertable altertablename "add constraint" constraintname constraint;

            parse var constraint type . "(" columns ")" .;
            if (type = "primary" | type = "unique" ) then do;
                parse var altertablename . . tablename
                
                if tablename = "ibmudi30.valueset" then do;
                   usingstr = " using stogroup sysdeflt priqty 256 secqty 256";
                end;

                outaltertable.n = "create unique index gix"ix ; n = n + 1; ix = ix + 1;
                outaltertable.n = "on "tablename"("columns")";  n = n + 1; 
                outaltertable.n = usingstr";"; n = n + 1;   

            end;
           
            outaltertable.n = altertablename; n = n + 1;
            outaltertable.n = "add constraint gcx"cx; n = n + 1; cx = cx + 1;

            do while (length(constraint) > 72);                          
               split = pos(" ",constraint,25);                           
               outaltertable.n = left(constraint,split); n = n + 1;   
               constraint = right(constraint,(length(constraint)-split));            
            end;                                                   
            outaltertable.n = constraint; n = n + 1;                                                       

         end;
         
         /*----------------------------------------------------------------*/ 
         /* We have an insert statement                                    */ 
         /*----------------------------------------------------------------*/ 
         when (verb =  "INSERT") then do;

            if (file_number = 9) then do;
               outinitial.1 = sql.i;
            end;
            else do;
               do until(verify(sql.i,";","M") > 0);                                          
                  do while (length(sql.i) > 72);                                           
                     split = pos(" ",sql.i,25);                                            
                     outinsert.m = left(sql.i,split); m = m + 1;                       
                     sql.i = right(sql.i,(length(sql.i)-split));                           
                  end;                                                                     
                                                                                        
                  outinsert.m = sql.i; m = m + 1;                                      
                                                                                         
                  i = i + 1;
                  sql.i = space(sql.i);                     /* get rid of extra spaces */  
                                                                                        
               end;                                                                        
                                                                                        
               do while (length(sql.i) > 72);                                              
                  split = pos(" ",sql.i,25);                                               
                  outinsert.m = left(sql.i,split); m = m + 1;                          
                  sql.i = right(sql.i,(length(sql.i)-split));                              
               end;                                                                        
                                                                                        
               outinsert.m = sql.i; m = m + 1;                                         
                                                                                        
               i = i + 1;                                                                  
               sql.i = space(sql.i);                     /* get rid of extra spaces */     


            end;
         end;
         /*----------------------------------------------------------------*/
         /* Unknown statement                                              */
         /*----------------------------------------------------------------*/
         otherwise; do;
            say "Unknown verb record is - "sql.i ;
            return;
         end;
      end;
   end;
end;


/*-------------------------------------------------------------------*/
/* Adjust record counts ready for writefile                          */ 
/*-------------------------------------------------------------------*/
outcreatetable.0    = k - 1;
outcreatetable7.0   = j - 1;
outcreateindex.0    = x - 1;
outcreateview.0     = y - 1;
outcreatetrigger.0  = g - 1;
outaltertable.0     = n - 1;
outinitial.0        = 1;
outinsert.0         = m - 1;

/*-------------------------------------------------------------------*/
/* Convert jcl files                                                 */ 
/*-------------------------------------------------------------------*/
address sh;

command = "/bin/iconv -f ISO8859-1 -t IBM-1047 "root_dir"/jcl/makedb71.jclsample";
call bpxwunix command,,jcl1.

command = "/bin/iconv -f ISO8859-1 -t IBM-1047 "root_dir"/jcl/makedb81.jclsample";
call bpxwunix command,,jcl2.



/*-------------------------------------------------------------------*/
/* Create a temporary directory and write files to it                */ 
/*-------------------------------------------------------------------*/
address sh;

"mkdir "temp_dir

address syscall;
writefile temp_dir"/table.sql"    755 outcreatetable.   ;
writefile temp_dir"/table7.sql"   755 outcreatetable7.  ;
writefile temp_dir"/index.sql"    755 outcreateindex.   ;
writefile temp_dir"/view.sql"     755 outcreateview.    ;
writefile temp_dir"/trigger.sql"  755 outcreatetrigger. ;
writefile temp_dir"/alter.sql"    755 outaltertable.    ;
writefile temp_dir"/initial.sql"  755 outinitial.       ;
writefile temp_dir"/insert.sql"   755 outinsert.        ;

writefile temp_dir"/makedb71.jcl" 755 jcl1.;
writefile temp_dir"/makedb81.jcl" 755 jcl2.;

say "Conversion complete"

/*-------------------------------------------------------------------*/
/* Move temporary files into TSO partitioned dataset                 */ 
/*-------------------------------------------------------------------*/
/*say "Creating TSO datasets" */

/*-------------------------------------------------------------------*/
/* Set up  SPACE, DCB and attributes for a PDS                       */ 
/*-------------------------------------------------------------------*/
space   = "SPACE(10,10) TRACKS"
dcb     = "LRECL(80) RECFM(F,B) BLKSIZE(8000)"
pdsattr = "DSNTYPE(PDS) TRACKS DIR(30)" 

SQL_DSN = HLQ".UDDI.SQL"
JCL_DSN = HLQ".UDDI.JCL"

address TSO "ALLOC DA('"JCL_DSN"') "dcb" "pdsattr" "space" NEW "
address TSO "ALLOC DA('"SQL_DSN"') "dcb" "pdsattr" "space" NEW " 

/*-------------------------------------------------------------------*/
/* Call subroutine to copy individual files as members of the two    */
/* partitioned datasets just created                                 */ 
/*-------------------------------------------------------------------*/
/*             filename/  dataset  source     filetype               */
/*               member    name    directory                         */
call copytoTSO "makedb71" JCL_DSN  temp_dir   "jcl"  
call copytoTSO "makedb81" JCL_DSN  temp_dir   "jcl" 

call copytoTSO "table"    SQL_DSN  temp_dir   "sql"  
call copytoTSO "table7"   SQL_DSN  temp_dir   "sql"  
call copytoTSO "index"    SQL_DSN  temp_dir   "sql"  
call copytoTSO "view"     SQL_DSN  temp_dir   "sql"  
call copytoTSO "trigger"  SQL_DSN  temp_dir   "sql"  
call copytoTSO "alter"    SQL_DSN  temp_dir   "sql" 
call copytoTSO "initial"  SQL_DSN  temp_dir   "sql"  
call copytoTSO "insert"   SQL_DSN  temp_dir   "sql"  

say "---------------------------------------------------------------";
exit
/*-------------------------------------------------------------------*/
/* End of main line                                                  */ 
/*-------------------------------------------------------------------*/

/*-------------------------------------------------------------------*/
/* Subroutine to copy files to a TSO partitioned dataset             */ 
/*-------------------------------------------------------------------*/
copytoTSO: procedure 

/* Pick out arguments in upper and lower case as required            */ 
/*                                                                   */
parse       arg filename .   dir type  
parse upper arg member   dsn .   .    

from = dir"/"filename"."type 
to   = dsn"("member")"

say left(from,30)"===> "to 

/* Set up DD names                                                   */  
address TSO "ALLOC FI(COPYIDD) PATH('"from"') "
address TSO "ALLOC FI(COPYODD) DA('"to"') SHR "

/* Copy file                                                         */
address TSO "OCOPY INDD(COPYIDD) OUTDD(COPYODD) PATHOPTS(USE) TEXT"

/* Free DD names                                                     */
address TSO "FREE  FI(COPYIDD)"
address TSO "FREE  FI(COPYODD)" 

return;


/*-------------------------------------------------------------------*/
/* Subroutine to check column definitions                            */ 
/*-------------------------------------------------------------------*/
checkcolumn: procedure expose column column7 j outcreatetable7.  
   
   parse var column colname coltype rest;
   parse var coltype type "(" size ")"; 
   
   select;

      when(type = "bigint") then do;                                                                                                                   
         column  = colname" int "rest;
         column7 = column; 
      end;                                                                          
                                                                                 
      when(type = "clob") then do;  
         outcreatetable7.j = "row_id rowid not null generated always,"; j = j + 1;   
      end;

      when(type = "varchar") then do;
         
         if (size >= 765) then size = 255;
         if (colname = "usetype")     then size = 255;
         if (colname = "keyvalue")    then size = 219;
         if (colname = "entitykey")   then size = 219;
         if (colname = "name")        then size = 254;
         if (colname = "name_nocase") then size = 254;
         if (colname = "nodeid")      then size = 240;
         
         column7 = colname" varchar("size") "rest;
      end;
      
      otherwise;

   end;                                                                         
return;
/*-------------------------------------------------------------------*/
/* End of createddl.sh                                               */ 
/*-------------------------------------------------------------------*/
