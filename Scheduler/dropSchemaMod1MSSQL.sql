-- Scriptfile to drop schema (tables) in Microsoft SQL Server
-- Mod1 - Additional tokens to allow qualifiers on Table Prefix, and tokens are unquoted.
------------------------------------------------------------------------
-- 1. Replace all occurences of @TABLE_PREFIX@ with the Table Prefix you will use in the
--    configured Scheduler resource.
-- 2. Replace all occurences of @TABLE_QUALIFIER@ with a table name qualifier, such as a
--    Schema Name to use for Schema-qualified object names.  The replacement text should include
--    a trailing period (.) to delimit the qualifier from the unqualified object name.  If an
--    unqualified object name is desired, the @TABLE_QUALIFIER@ token must be replaced with an
--    empty string (and no delimiter).
-- 3. Process this script by one of the following methods:
--   a) Load this script into the SQL Query Analyzer and execute it.
--   b) Use the isql command to run the script.
--      Example:
--        isql -Usa -Pmypassword -Smyserver -dmydatabase -idropSchemaMod1MSSQL.sql



DROP TABLE @TABLE_QUALIFIER@@TABLE_PREFIX@TASK;

DROP TABLE @TABLE_QUALIFIER@@TABLE_PREFIX@TREG;

DROP TABLE @TABLE_QUALIFIER@@TABLE_PREFIX@LMGR;

DROP TABLE @TABLE_QUALIFIER@@TABLE_PREFIX@LMPR;

