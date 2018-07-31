-- Scriptfile to drop schema (tables) in Derby 
-- Mod1 - Additional tokens to allow qualifiers on Table Prefix, and tokens are unquoted.
-- Note: Derby also uses the term "Schema" as the qualifier on a DB object name, which
-- typically is the ID of the user owning the object.
------------------------------------------------------------------------
-- 1. Replace all occurences of @TABLE_PREFIX@ with the Table Prefix you will use in the
--    configured Scheduler resource.
-- 2. Replace all occurences of @TABLE_QUALIFIER@ with a table name qualifier, such as a
--    Schema Name to use for Schema-qualified object names.  The replacement text should include
--    a trailing period (.) to delimit the qualifier from the unqualified object name.  If an
--    unqualified object name is desired, the @TABLE_QUALIFIER@ token must be replaced with an
--    empty string (and no delimiter).
-- 3. Process This script in the ij command line processor.  
-- Example: 
--    java -Djava.ext.dirs=C:/WebSphere/AppServer/derby/lib -Dij.database=C:/drivers/derby/databases/SCHEDDB -Dij.protocol=jdbc:derby: org.apache.derby.tools.ij dropSchemaMod1Derby.ddl



DROP INDEX @TABLE_QUALIFIER@@TABLE_PREFIX@TASK_IDX1;

DROP INDEX @TABLE_QUALIFIER@@TABLE_PREFIX@TASK_IDX2;

DROP TABLE @TABLE_QUALIFIER@@TABLE_PREFIX@TASK;

DROP TABLE @TABLE_QUALIFIER@@TABLE_PREFIX@TREG;

DROP TABLE @TABLE_QUALIFIER@@TABLE_PREFIX@LMGR;

DROP INDEX @TABLE_QUALIFIER@@TABLE_PREFIX@LMPR_IDX1;

DROP TABLE @TABLE_QUALIFIER@@TABLE_PREFIX@LMPR;

