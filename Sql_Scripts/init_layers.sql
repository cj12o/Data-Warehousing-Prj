/*Warning => This Script basicvally drops desired Schema if present, then recreates it.
Aim is to avoid any kind of issues with Schema_name
ONLY RUN this script when you want to create brand new Schemas and Drop the existing ones
*/




--Schema creation
DO $$
BEGIN
--gold creation
IF EXISTS(
	SELECT *
	FROM INFORMATION_SCHEMA.schemata
	WHERE INFORMATION_SCHEMA.schemata.schema_name='gold'
	)THEN 
		DROP SCHEMA gold;
		RAISE NOTICE 'Schema gold dropped';
END IF;
CREATE SCHEMA gold;
RAISE NOTICE 'Schema gold created';
--Silver creation
IF EXISTS(
	SELECT 1
	FROM INFORMATION_SCHEMA.schemata
	WHERE INFORMATION_SCHEMA.schemata.schema_name='silver'
	)THEN 
		DROP SCHEMA silver;
		RAISE NOTICE 'Schema silver dropped';
END IF;
CREATE SCHEMA silver;
RAISE NOTICE 'Schema silver created';
--Bronze creation
IF EXISTS(
	SELECT 1
	FROM INFORMATION_SCHEMA.schemata
	WHERE INFORMATION_SCHEMA.schemata.schema_name='bronze'
	)THEN 
		DROP SCHEMA bronze;
		RAISE NOTICE 'Schema bronze dropped';
END IF;
CREATE SCHEMA bronze;
RAISE NOTICE 'Schema bronze created';
END
$$


