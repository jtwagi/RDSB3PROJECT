---------------------------------------------------------------------------------------
 --verify that the query window is connected to SERVER2
---------------------------------------------------------------------------------------
SELECT
    @@SERVERNAME AS ServerName,
    SERVERPROPERTY('InstanceName') AS InstanceName,
    SERVERPROPERTY('Edition') AS Edition,
    SERVERPROPERTY('ProductVersion') AS ProductVersion;
-----------------------------------------------------------------------------------------
--configuring the first 3 databases( RDSB3DATABASE21, RDSB3DATABASE22, RDSB3DATABASE23 ) on RDSB3SERVER2
-----------------------------------------------------------------------------------------
USE master;
GO

CREATE DATABASE RDSB3DATABASE21;
GO

CREATE DATABASE RDSB3DATABASE22;
GO

CREATE DATABASE RDSB3DATABASE23;
GO
----------------------------------------------------------------------------------------
  --setting recovery models on Instance RDSB3SERVER1
----------------------------------------------------------------------------------------
ALTER DATABASE RDSB3DATABASE21 SET RECOVERY FULL; 
GO

ALTER DATABASE RDSB3DATABASE22 SET RECOVERY BULK_LOGGED;
GO

ALTER DATABASE RDSB3DATABASE23 SET RECOVERY SIMPLE;
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
    'RDSB3DATABASE21',
    'RDSB3DATABASE22',
    'RDSB3DATABASE23'
)
ORDER BY name;
