Phase 10 — SQL Server Log Shipping

Objective

Configure SQL Server Log Shipping for RDSB3DATABASE23, with RDSB3SERVER2 serving as the primary server and RDSB3SERVER1 serving as the secondary server.

| Component          | Configuration     |
| ------------------ | ----------------- |
| Primary Server     | `RDSB3SERVER2`    |
| Primary Database   | `RDSB3DATABASE23` |
| Secondary Server   | `RDSB3SERVER1`    |
| Secondary Database | `RDSB3DATABASE23` |
| Secondary State    | `NORECOVERY`      |
| Backup Frequency   | Every 15 minutes  |
| Copy Frequency     | Every 15 minutes  |
| Restore Frequency  | Every 15 minutes  |

1. Primary Database Preparation

The primary database RDSB3DATABASE23 was initially configured with the SIMPLE recovery model. It was changed to FULL recovery to support transaction log backups required for Log Shipping.

USE master;

GO

ALTER DATABASE RDSB3DATABASE23

SET RECOVERY FULL;

GO

The configuration was verified as:

RDSB3DATABASE23 | ONLINE | FULL

Screenshot: LogShipping_01_Primary_FULL_Recovery.png

2. Initial Full Backup

A full backup of the primary database was created on RDSB3SERVER2:

BACKUP DATABASE RDSB3DATABASE23

TO DISK = 'C:\SQLBackups\LogShipping\RDSB3DATABASE23_FULL.bak'

WITH INIT, STATS = 10;

GO

The backup completed successfully.

Screenshot: LogShipping_02_Initial_Full_Backup.png

3. Secondary Database Initialization

The full backup was restored to RDSB3SERVER1 as RDSB3DATABASE23 using NORECOVERY.

RESTORE DATABASE RDSB3DATABASE23

FROM DISK = 'C:\SQLBackups\LogShipping\RDSB3DATABASE23_FULL.bak'

WITH

    MOVE 'RDSB3DATABASE23'
        TO 'C:\Program Files\Microsoft SQL Server\MSSQL17.RDSB3SERVER1\MSSQL\DATA\RDSB3DATABASE23.mdf',
    MOVE 'RDSB3DATABASE23_log'
        TO 'C:\Program Files\Microsoft SQL Server\MSSQL17.RDSB3SERVER1\MSSQL\DATA\RDSB3DATABASE23_log.ldf',
    NORECOVERY,
    STATS = 10;
    
GO

The secondary database remained in Restoring state so that subsequent transaction log backups could be applied.

Screenshot: LogShipping_03_Secondary_Restore_NORECOVERY.png

4. Log Shipping Configuration

Log Shipping was enabled on the primary database.

The transaction-log backup location was configured as:

Network path: \\Wallis\TLogs

Local path:   C:\SQLBackups\LogShipping\TLogs

The Log Shipping backup job was configured to execute every 15 minutes.

The secondary was configured as:

WALLIS\RDSB3SERVER1

RDSB3DATABASE23

Because the database had already been manually restored using NORECOVERY, the configuration option “No, the secondary database is initialized” was selected.

Transaction logs copied by the secondary server were stored in:

C:\SQLBackups\LogShipping\CopiedLogs

The secondary database was configured to remain in No recovery mode, with both the Copy and Restore jobs scheduled every 15 minutes.

SQL Server successfully saved both the primary and secondary Log Shipping configurations with 0 errors and 0 warnings.

Screenshot: LogShipping_04_Configuration_Success.png

5. SQL Server Agent Jobs

Three SQL Server Agent operations provide the Log Shipping pipeline:

Backup Job — RDSB3SERVER2

LSBackup_RDSB3DATABASE23

The job creates transaction-log (.trn) backups in the TLogs directory.

Screenshot: LogShipping_05_Backup_Job_Success.png

Copy Job — RDSB3SERVER1

LSCopy_localhost\RDSB3SERVER2_RDSB3DATABASE23

The job copies transaction-log backups from:

\\Wallis\TLogs

to:

C:\SQLBackups\LogShipping\CopiedLogs

The SQL Server Agent account SQLAgent$RDSB3SERVER1 was granted the required folder permissions. After correcting the permissions and creating the CopiedLogs directory, the Copy job completed successfully.

Screenshot: LogShipping_06_Copy_Job_Success.png

Restore Job — RDSB3SERVER1

LSRestore_localhost\RDSB3SERVER2_RDSB3DATABASE23

The Restore job successfully applied the copied transaction-log backups to the secondary database while maintaining NORECOVERY.

Screenshot: LogShipping_07_Restore_Job_Success.png

6. Final Verification

The Log Shipping monitor metadata was queried on RDSB3SERVER1:

SELECT

    secondary_database,
    last_copied_file,
    last_copied_date,
    last_restored_file,
    last_restored_date
    
FROM msdb.dbo.log_shipping_monitor_secondary

WHERE secondary_database = 'RDSB3DATABASE23';

The results confirmed that transaction-log files were being successfully copied and restored:

Secondary Database: RDSB3DATABASE23
Last Copied:        2026-09-15 23:35:19
Last Restored:      2026-09-15 23:36:52

Screenshot: LogShipping_08_Final_Verification.png

RDSB3SERVER2

RDSB3DATABASE23

      │
      │ Transaction Log Backup
      ▼
\\Wallis\TLogs

      │
      │ Copy Job
      ▼
RDSB3SERVER1

C:\SQLBackups\LogShipping\CopiedLogs

      │
      │ Restore Job
      ▼
      
RDSB3DATABASE23

(NORECOVERY)


>>> All screenshots can be found in : docs/screenshots/phase10

