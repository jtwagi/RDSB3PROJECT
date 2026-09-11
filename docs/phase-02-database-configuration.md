# Phase 2 — Database and Recovery Model Configuration

## Objective

Create nine SQL Server databases across the three RDSB3 SQL Server
instances and configure the required recovery model for each database.

## Database Architecture

| SQL Server Instance | Database | Recovery Model |
|---|---|---|
| RDSB3SERVER1 | RDSB3DATABASE11 | FULL |
| RDSB3SERVER1 | RDSB3DATABASE12 | BULK_LOGGED |
| RDSB3SERVER1 | RDSB3DATABASE13 | SIMPLE |
| RDSB3SERVER2 | RDSB3DATABASE21 | FULL |
| RDSB3SERVER2 | RDSB3DATABASE22 | BULK_LOGGED |
| RDSB3SERVER2 | RDSB3DATABASE23 | SIMPLE |
| RDSB3SERVER3 | RDSB3DATABASE31 | FULL |
| RDSB3SERVER3 | RDSB3DATABASE32 | BULK_LOGGED |
| RDSB3SERVER3 | RDSB3DATABASE33 | SIMPLE |

## Implementation

Three databases were created on each SQL Server instance using
`CREATE DATABASE`.

Example for RDSB3SERVER1:

```sql
USE master;
GO

CREATE DATABASE RDSB3DATABASE11;
GO

CREATE DATABASE RDSB3DATABASE12;
GO

CREATE DATABASE RDSB3DATABASE13;
GO

The required recovery models were then configured using
ALTER DATABASE.

ALTER DATABASE RDSB3DATABASE11 SET RECOVERY FULL;
GO

ALTER DATABASE RDSB3DATABASE12 SET RECOVERY BULK_LOGGED;
GO

ALTER DATABASE RDSB3DATABASE13 SET RECOVERY SIMPLE;
GO

The same configuration pattern was applied to RDSB3SERVER2 and
RDSB3SERVER3.

Verification

The database configuration was verified using sys.databases.

All nine databases were confirmed to be ONLINE with their required
recovery models.

