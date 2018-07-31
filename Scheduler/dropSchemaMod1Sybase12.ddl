/*
 Scriptfile to drop schema (tables) in Sybase v12 and later
 Mod1 - Additional tokens to allow qualifiers on Table Prefix, and tokens are unquoted.
 ------------------------------------------------------------------------
 1. Replace all occurences of @TABLE_PREFIX@ with the Table Prefix you will use in the
    configured Scheduler resource.
 2. Replace all occurences of @TABLE_QUALIFIER@ with a table name qualifier, such as a
    owner name to use for owner-qualified object names.  The replacement text should include
    a trailing period (.) to delimit the qualifier from the unqualified object name.  If an
    unqualified object name is desired, the @TABLE_QUALIFIER@ token must be replaced with an
    empty string (and no delimiter).
 3. Process this script using the isql command line processor
 Example: 
     isql -U<userid> -P<password> -S<sybase server> -D<databasename> -i dropSchemaMod1Sybase12.ddl
*/


DROP TABLE @TABLE_QUALIFIER@@TABLE_PREFIX@TASK
GO

DROP TABLE @TABLE_QUALIFIER@@TABLE_PREFIX@TREG
GO

DROP TABLE @TABLE_QUALIFIER@@TABLE_PREFIX@LMGR
GO

DROP TABLE @TABLE_QUALIFIER@@TABLE_PREFIX@LMPR
GO

