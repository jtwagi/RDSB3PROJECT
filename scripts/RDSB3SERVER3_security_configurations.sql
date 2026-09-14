--verifying we are connected to server3
SELECT
    @@SERVERNAME AS ServerName,
    SERVERPROPERTY('InstanceName') AS InstanceName;

--creating the logins
USE master;
GO

CREATE LOGIN RDSB3L31
WITH PASSWORD = 'Rdsb3_L31#2026!';
GO

CREATE LOGIN RDSB3L32
WITH PASSWORD = 'Rdsb3_L32#2026!';
GO

CREATE LOGIN RDSB3L33
WITH PASSWORD = 'Rdsb3_L33#2026!';
GO

--------------------------------------------------------------------------------------
--RDSB3SERVER3 security configuration
--creating users for each login: Mapping users to have access on their assigned databases.
----------------------------------------------------------------------------------------

USE RDSB3DATABASE31; -- Making sure we are using the right database
GO
CREATE USER RDSB3L31 FOR LOGIN RDSB3L31;
GO

USE RDSB3DATABASE32; -- Making sure we are using the right database
GO
CREATE USER RDSB3L32 FOR LOGIN RDSB3L32;
GO

USE RDSB3DATABASE33; -- Making sure we are using the right database
GO
CREATE USER RDSB3L33 FOR LOGIN RDSB3L33;
GO

-- Verify the logins
use master;
GO

SELECT 
      name AS LoginName,
      type_desc AS LoginType,
      is_disabled AS IsDisabled
 FROM sys.server_principals
 WHERE name IN(
      'RDSB3L31',
      'RDSB3L32',
      'RDSB3L33'
)
ORDER BY name;

--verify database mappings
USE RDSB3DATABASE31;
GO

SELECT 
    DB_NAME() AS DatabaseName, 
    name AS UserName
FROM sys.database_principals
WHERE name = 'RDSB3L31';

USE RDSB3DATABASE32;
GO

SELECT 
    DB_NAME() AS DatabaseName, 
    name AS UserName
FROM sys.database_principals
WHERE name = 'RDSB3L32';

USE RDSB3DATABASE33;
GO

SELECT 
    DB_NAME() AS DatabaseName, 
    name AS UserName
FROM sys.database_principals
WHERE name = 'RDSB3L33';

-------------------------------------------------------
--RDSB3SERVER3 security configuration completed!
-------------------------------------------------------

