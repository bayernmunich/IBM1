-- Scriptfile to drop schema (tables) for Oracle
-- Mod1 - Additional tokens to allow qualifiers on Table Prefix, and tokens are unquoted.
-- Note: Oracle also uses the term "Schema" as the qualifier on a DB object name, which
-- typically is the ID of the user owning the object.
------------------------------------------------------------------------
-- 1. Replace all occurrences of @TABLE_PREFIX@ with the Table Prefix you will use in the
--    configured Scheduler resource.
-- 2. Replace all occurrences of @TABLE_QUALIFIER@ with a table name qualifier, such as a
--    Schema Name to use for Schema-qualified object names.  The replacement text should include
--    a trailing period (.) to delimit the qualifier from the unqualified object name.  If an
--    unqualified object name is desired, the @TABLE_QUALIFIER@ token must be replaced with an
--    empty string (and no delimiter).
-- 3. Replace all occurrences of @SCHED_TABLESPACE@ with a valid tablespace that was 
--    created by the createTablespaceOracle.ddl script.
-- 4. Process this script using SQL*Plus
-- Example: 
--  o  sqlplus username/password@mydb @dropSchemaMod1Oracle.ddl
--  o  or, at the sqlplus prompt, enter
--     SQL> @dropSchemaMod1Oracle.ddl



DROP INDEX @TABLE_QUALIFIER@@TABLE_PREFIX@TASK_IDX1;

DROP INDEX @TABLE_QUALIFIER@@TABLE_PREFIX@TASK_IDX2;

DROP TABLE @TABLE_QUALIFIER@@TABLE_PREFIX@TASK;

DROP TABLE @TABLE_QUALIFIER@@TABLE_PREFIX@TREG;

DROP TABLE @TABLE_QUALIFIER@@TABLE_PREFIX@LMGR;

DROP INDEX @TABLE_QUALIFIER@@TABLE_PREFIX@LMPR_IDX1;

DROP TABLE @TABLE_QUALIFIER@@TABLE_PREFIX@LMPR;

