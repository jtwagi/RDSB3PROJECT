---------------------------------------------------------------------------------------
 --verify that the query window is connected to SERVER1
 -- Avoids creating the Database in a wrong Instance
---------------------------------------------------------------------------------------
SELECT
    @@SERVERNAME AS ServerName,
    SERVERPROPERTY('InstanceName') AS InstanceName,
    SERVERPROPERTY('Edition') AS Edition,
    SERVERPROPERTY('ProductVersion') AS ProductVersion;
-----------------------------------------------------------------------------------------
--configuring the first 3 databases( RDSB3DATABASE11, RDSB3DATABASE12, RDSB3DATABASE13 ) on RDSB3SERVER1
-----------------------------------------------------------------------------------------
USE master;
GO

CREATE DATABASE RDSB3DATABASE11;
GO

CREATE DATABASE RDSB3DATABASE12;
GO

CREATE DATABASE RDSB3DATABASE13;
GO
----------------------------------------------------------------------------------------
  --setting recovery models on Instance RDSB3SERVER1
----------------------------------------------------------------------------------------
ALTER DATABASE RDSB3DATABASE11 SET RECOVERY FULL; 
GO

ALTER DATABASE RDSB3DATABASE12 SET RECOVERY BULK_LOGGED;
GO

ALTER DATABASE RDSB3DATABASE13 SET RECOVERY SIMPLE;
GO
---------------------------------------------------------------------------------------------
  --verification
---------------------------------------------------------------------------------------------
SELECT
    name AS DatabaseName,
    recovery_model_desc AS RecoveryModel,
    state_desc AS DatabaseState
FROM sys.databases
WHERE name IN (
    'RDSB3DATABASE11',
    'RDSB3DATABASE12',
    'RDSB3DATABASE13'
)
ORDER BY name;
