
--verifying we are connected to server1
SELECT
    @@SERVERNAME AS ServerName,
    SERVERPROPERTY('InstanceName') AS InstanceName;

--creating the logins
CREATE LOGIN RDSB3L11
WITH PASSWORD = 'Rdsb3_L11#2026!';
GO

CREATE LOGIN RDSB3L12
WITH PASSWORD = 'Rdsb3_L12#2026!';
GO

CREATE LOGIN RDSB3L13
WITH PASSWORD = 'Rdsb3_L13#2026!';
GO

--------------------------------------------------
--RDSB3SERVER1 security configuration
--------------------------------------------------
--creating users for each login: Mapping users to have access on their assigned databases.

USE master; -- Making sure we are using the right database
GO

CREATE USER RDSB3L11 FOR LOGIN RDSB3L11;
GO

CREATE USER RDSB3L12 FOR LOGIN RDSB3L12;
GO

CREATE USER RDSB3L13 FOR LOGIN RDSB3L13;
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
      'RDSB3L11',
      'RDSB3L12',
      'RDSB3L13'
)
ORDER BY name;

--verify database mappings
USE RDSB3DATABASE11;
GO

SELECT 
    DB_NAME() AS DatabaseName, 
    name AS UserName
FROM sys.database_principals
WHERE name = 'RDSB3L11';

USE RDSB3DATABASE12;
GO

SELECT 
    DB_NAME() AS DatabaseName, 
    name AS UserName
FROM sys.database_principals
WHERE name = 'RDSB3L12';

USE RDSB3DATABASE13;
GO

SELECT 
    DB_NAME() AS DatabaseName, 
    name AS UserName
FROM sys.database_principals
WHERE name = 'RDSB3L13';

-------------------------------------------------------
--RDSB3SERVER1 security configuration completed!
-------------------------------------------------------
