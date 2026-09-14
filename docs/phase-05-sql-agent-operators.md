# Phase 5 — SQL Server Agent Operators

## Objective

Configure SQL Server Agent operators across the three RDSB3 SQL Server
instances and integrate SQL Server Agent with the Database Mail profile
configured in Phase 4.

The operators provide notification targets for SQL Server Agent jobs,
alerts, and maintenance-plan execution results.

## Operator Configuration

| Instance | Operator |
|---|---|
| RDSB3SERVER1 | RDSB3OPERATOR11 |
| RDSB3SERVER1 | RDSB3OPERATOR12 |
| RDSB3SERVER1 | RDSB3OPERATOR13 |
| RDSB3SERVER2 | RDSB3OPERATOR21 |
| RDSB3SERVER2 | RDSB3OPERATOR22 |
| RDSB3SERVER2 | RDSB3OPERATOR23 |
| RDSB3SERVER3 | RDSB3OPERATOR31 |
| RDSB3SERVER3 | RDSB3OPERATOR32 |
| RDSB3SERVER3 | RDSB3OPERATOR33 |

Each operator was enabled and configured with an email address.

## SQL Server Agent Mail Configuration

SQL Server Agent was configured on each instance to use Database Mail.

Configuration:

- Mail system: Database Mail
- Mail profile: RDSB3DBMPRO
- Mail profile enabled: Yes

After configuring the mail profile, SQL Server Agent was restarted on
each instance so the new configuration would take effect.

## Verification

The operators were verified through the `msdb` system tables:

```sql
USE msdb;
GO

SELECT
    name AS OperatorName,
    enabled AS IsEnabled,
    email_address AS EmailAddress
FROM dbo.sysoperators
ORDER BY name;
```

An `IsEnabled` value of `1` confirmed that each operator was active.

## Evidence
Folder: docs/screenshots/phase-05 
## Result

Nine SQL Server Agent operators were successfully configured across
the three SQL Server instances.

SQL Server Agent was also integrated with the RDSB3DBMPRO Database
Mail profile, preparing the environment for automated job and
maintenance-plan email notifications.
