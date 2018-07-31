-- Scriptfile to drop schema (tables) in DB2 on iSeries
-- Mod1 - Additional tokens to allow qualifiers on Table Prefix, and tokens are unquoted.
------------------------------------------------------------------------
-- If the @TABLE_QUALIFIER@ token is not used, then
-- the code assumes an implicit schema, i.e. the tables
-- and views have to be created in a collection that has
-- the name of the user connected to use the product.
------------------------------------------------------------------------
-- 1. Replace all occurrences of @TABLE_PREFIX@ to the Table Prefix you will use in the
--    configured Scheduler resource.
-- 2. Replace all occurrences of @TABLE_QUALIFIER@ with a table name qualifier, such as a
--    Collection Name to use for Collection-qualified object names.  The replacement text should include
--    a trailing period (.) to delimit the qualifier from the unqualified object name.  If an
--    unqualified object name is desired, the @TABLE_QUALIFIER@ token must be replaced with an
--    empty string (and no delimiter).
-- 3. Process this script in the DB2 command line processor
-- Example:
--            db2 -tf dropSchemaMod1DB2iSeries.ddl



DROP INDEX @TABLE_QUALIFIER@@TABLE_PREFIX@TASK_IDX1;

DROP INDEX @TABLE_QUALIFIER@@TABLE_PREFIX@TASK_IDX2;

DROP TABLE @TABLE_QUALIFIER@@TABLE_PREFIX@TASK;

DROP TABLE @TABLE_QUALIFIER@@TABLE_PREFIX@TREG;

DROP TABLE @TABLE_QUALIFIER@@TABLE_PREFIX@LMGR;

DROP INDEX @TABLE_QUALIFIER@@TABLE_PREFIX@LMPR_IDX1;

DROP TABLE @TABLE_QUALIFIER@@TABLE_PREFIX@LMPR;

