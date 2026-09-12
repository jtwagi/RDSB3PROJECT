# Phase 3 — SQL Server Security: Logins and Database Users

## Objective

Configure server-level SQL Server logins and map each login to its
corresponding database across the three RDSB3 SQL Server instances.

This phase demonstrates the distinction between SQL Server
server-level logins and database-level users.

## Security Mapping

| Instance | Login | Database |
|---|---|---|
| RDSB3SERVER1 | RDSB3L11 | RDSB3DATABASE11 |
| RDSB3SERVER1 | RDSB3L12 | RDSB3DATABASE12 |
| RDSB3SERVER1 | RDSB3L13 | RDSB3DATABASE13 |
| RDSB3SERVER2 | RDSB3L21 | RDSB3DATABASE21 |
| RDSB3SERVER2 | RDSB3L22 | RDSB3DATABASE22 |
| RDSB3SERVER2 | RDSB3L23 | RDSB3DATABASE23 |
| RDSB3SERVER3 | RDSB3L31 | RDSB3DATABASE31 |
| RDSB3SERVER3 | RDSB3L32 | RDSB3DATABASE32 |
| RDSB3SERVER3 | RDSB3L33 | RDSB3DATABASE33 |

## Implementation

Server-level SQL logins were created on each SQL Server instance.

Example:

```sql
USE master;
GO

CREATE LOGIN RDSB3L11
WITH PASSWORD = '<YOUR_STRONG_PASSWORD>';
GO
```

> Passwords are intentionally excluded from the repository. Replace with your own password.

A corresponding database user was then created and mapped to each
login.

```sql
USE RDSB3DATABASE11;
GO

CREATE USER RDSB3L11 FOR LOGIN RDSB3L11;
GO
```

The same process was repeated for all nine login/database mappings.

## Verification

Server-level logins were verified through `sys.server_principals`.

```sql
SELECT
    name AS LoginName,
    type_desc AS LoginType,
    is_disabled AS IsDisabled
FROM sys.server_principals
WHERE name IN ('RDSB3L11', 'RDSB3L12', 'RDSB3L13');
```

Database users were verified through `sys.database_principals`.

```sql
SELECT
    DB_NAME() AS DatabaseName,
    name AS UserName
FROM sys.database_principals
WHERE name = 'RDSB3L11';
```

All nine SQL logins were confirmed to be enabled and successfully
mapped to their designated databases.

## Evidence
Find the screenshots in the docs/screenshots/phase-03 Folder.

## Result
Phase 3 was successfully completed. Nine SQL Server logins were
created across the three instances and mapped to their respective
databases.
