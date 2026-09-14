---------------------------------------------------------------------------------------
 --verify that the query window is connected to SERVER3
---------------------------------------------------------------------------------------
SELECT
    @@SERVERNAME AS ServerName,
    SERVERPROPERTY('InstanceName') AS InstanceName,
    SERVERPROPERTY('Edition') AS Edition,
    SERVERPROPERTY('ProductVersion') AS ProductVersion;
-----------------------------------------------------------------------------------------
--configuring the first 3 databases( RDSB3DATABASE31, RDSB3DATABASE32, RDSB3DATABASE33 ) on RDSB3SERVER3
-----------------------------------------------------------------------------------------
USE master;
GO

CREATE DATABASE RDSB3DATABASE31;
GO

CREATE DATABASE RDSB3DATABASE32;
GO

CREATE DATABASE RDSB3DATABASE33;
GO
----------------------------------------------------------------------------------------
  --setting recovery models on Instance RDSB3SERVER1
----------------------------------------------------------------------------------------
ALTER DATABASE RDSB3DATABASE31 SET RECOVERY FULL; 
GO

ALTER DATABASE RDSB3DATABASE32 SET RECOVERY BULK_LOGGED;
GO

ALTER DATABASE RDSB3DATABASE33 SET RECOVERY SIMPLE;
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
    'RDSB3DATABASE31',
    'RDSB3DATABASE32',
    'RDSB3DATABASE33'
)
ORDER BY name;
