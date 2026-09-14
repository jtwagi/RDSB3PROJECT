# Phase 4 — SQL Server Database Mail Configuration

## Objective

Configure SQL Server Database Mail across all three RDSB3 SQL Server
instances to enable SQL Server to send email notifications.

Database Mail was configured using Gmail as the SMTP provider.

## Configuration

The following Database Mail configuration was used on all three
SQL Server instances:

| Setting | Value |
|---|---|
| Profile Name | RDSB3DBMPRO |
| Account Name | RDSB3DBMACC |
| SMTP Server | smtp.gmail.com |
| SMTP Port | 587 |
| Secure Connection | Enabled |
| Authentication | Basic Authentication |
| Credential | Google App Password |

The Gmail address and App Password are intentionally excluded from
the repository.

## Enable Database Mail

Database Mail extended stored procedures were enabled using:

```sql
USE master;
GO

EXEC sp_configure 'show advanced options', 1;
RECONFIGURE;
GO

EXEC sp_configure 'Database Mail XPs', 1;
RECONFIGURE;
GO
```

The configuration was verified using:

```sql
EXEC sp_configure 'Database Mail XPs';
GO
```

A `run_value` of `1` confirmed that Database Mail was enabled.

## Database Mail Profile

A Database Mail profile named:

`RDSB3DBMPRO`

was created on each SQL Server instance.

The SMTP account associated with the profile was:

`RDSB3DBMACC`

The profile was configured to communicate with Gmail's SMTP service
over port 587 using a secure connection.

## Troubleshooting

During the initial RDSB3SERVER1 configuration, test messages failed
with the following SMTP error:

`5.7.0 Authentication Required`

The Database Mail event log was examined to identify the underlying
SMTP authentication failure.

The issue occurred because Gmail required an application-specific
credential rather than an independently generated or regular account
password.

A Google App Password was generated for SQL Server Database Mail and
configured as the SMTP credential.

After updating the credential, Database Mail successfully
authenticated with Gmail and delivered the test messages.

This troubleshooting process demonstrated the use of the Database
Mail logs for diagnosing SMTP and authentication failures.

## Verification

Mail delivery status was verified through the `msdb` Database Mail
system tables:

```sql
USE msdb;
GO

SELECT TOP 5
    sent_status,
    subject,
    recipients,
    send_request_date,
    sent_date
FROM dbo.sysmail_allitems
ORDER BY send_request_date DESC;
```

A `sent_status` value of `sent` confirmed successful message delivery.

Evidenece: Folder: docs/screenshots/phase-04/


Database Mail was successfully configured and tested across all three
SQL Server instances.

Each instance can now send email through the configured SMTP service,
providing the email infrastructure required for later SQL Server Agent
notifications and administrative alerts.
