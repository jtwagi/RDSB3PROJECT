--verifying we are connected to server2
SELECT
    @@SERVERNAME AS ServerName,
    SERVERPROPERTY('InstanceName') AS InstanceName;

--creating the logins
USE master;
GO

CREATE LOGIN RDSB3L21
WITH PASSWORD = 'Rdsb3_L21#2026!';
GO

CREATE LOGIN RDSB3L22
WITH PASSWORD = 'Rdsb3_L22#2026!';
GO

CREATE LOGIN RDSB3L23
WITH PASSWORD = 'Rdsb3_L23#2026!';
GO

--------------------------------------------------
--RDSB3SERVER2 security configuration
--------------------------------------------------
--creating users for each login: Mapping users to have access on their assigned databases.

USE RDSB3DATABASE21; -- Making sure we are using the right database
GO
CREATE USER RDSB3L21 FOR LOGIN RDSB3L21;
GO

USE RDSB3DATABASE22; -- Making sure we are using the right database
GO
CREATE USER RDSB3L22 FOR LOGIN RDSB3L22;
GO

USE RDSB3DATABASE23; -- Making sure we are using the right database
GO
CREATE USER RDSB3L23 FOR LOGIN RDSB3L23;
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
      'RDSB3L21',
      'RDSB3L22',
      'RDSB3L23'
)
ORDER BY name;

--verify database mappings
USE RDSB3DATABASE21;
GO

SELECT 
    DB_NAME() AS DatabaseName, 
    name AS UserName
FROM sys.database_principals
WHERE name = 'RDSB3L21';

USE RDSB3DATABASE22;
GO

SELECT 
    DB_NAME() AS DatabaseName, 
    name AS UserName
FROM sys.database_principals
WHERE name = 'RDSB3L22';

USE RDSB3DATABASE23;
GO

SELECT 
    DB_NAME() AS DatabaseName, 
    name AS UserName
FROM sys.database_principals
WHERE name = 'RDSB3L23';

-------------------------------------------------------
--RDSB3SERVER2 security configuration completed!
-------------------------------------------------------
