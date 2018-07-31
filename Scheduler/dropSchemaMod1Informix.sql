-- Scriptfile to drop schema (tables) in Informix
-- Mod1 - Additional tokens to allow qualifiers on Table Prefix, and tokens are unquoted.
------------------------------------------------------------------------
-- 1. Replace all occurences of @TABLE_PREFIX@ with the Table Prefix you will use in the
--    configured Scheduler resource.
-- 2. Replace all occurences of @TABLE_QUALIFIER@ with a table name qualifier, such as an
--    owner name to use for owner-qualified object names.  The replacement text should include
--    a trailing period (.) to delimit the qualifier from the unqualified object name.  If an
--    unqualified object name is desired, the @TABLE_QUALIFIER@ token must be replaced with an
--    empty string (and no delimiter).
-- 3. Process this script in the Informix dbaccess command processor
-- Example:
--             dbaccess mydb dropSchemaMod1Informix.sql



DROP INDEX @TABLE_QUALIFIER@@TABLE_PREFIX@TASK_IDX1;

DROP INDEX @TABLE_QUALIFIER@@TABLE_PREFIX@TASK_IDX2;

DROP TABLE @TABLE_QUALIFIER@@TABLE_PREFIX@TASK;

DROP TABLE @TABLE_QUALIFIER@@TABLE_PREFIX@TREG;

DROP TABLE @TABLE_QUALIFIER@@TABLE_PREFIX@LMGR;

DROP INDEX @TABLE_QUALIFIER@@TABLE_PREFIX@LMPR_IDX1;

DROP TABLE @TABLE_QUALIFIER@@TABLE_PREFIX@LMPR;

