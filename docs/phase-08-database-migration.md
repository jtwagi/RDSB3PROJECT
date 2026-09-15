Phase 8 — Database Migration

Objective

The purpose of this phase was to migrate the specified databases using the SQL Server backup-and-restore method. The project requires the following migrations:

| Migration | Source                      | Destination | Final Database     |
| --------- | --------------------------- | ----------- | ------------------ |
| 1         | `RDSB3DATABASE13` — SERVER1 | SERVER3     | `RDSB3DATABASE13`  |
| 2         | `RDSB3DATABASE23` — SERVER2 | SERVER2     | `RDSB3DATABASE23M` |
| 3         | `RDSB3DATABASE31` — SERVER3 | SERVER3     | `RDSB3DATABASE31M` |

Procedure Performed

Migration 1 — RDSB3DATABASE13

A full backup of RDSB3DATABASE13 was created on RDSB3SERVER1. The backup was then restored while connected to RDSB3SERVER3. During the restore, the database files were relocated to the SERVER3 SQL Server data directory to prevent SQL Server from attempting to use the original SERVER1 file paths.

Result: RDSB3DATABASE13 was successfully restored and verified as ONLINE with the SIMPLE recovery model.

Migration 2 — RDSB3DATABASE23

A full backup of RDSB3DATABASE23 was created on RDSB3SERVER2. The backup was restored on the same instance under the new database name RDSB3DATABASE23M. Separate .mdf and .ldf file names were specified for the migrated copy to prevent conflicts with the original database files.

Result: Both RDSB3DATABASE23 and RDSB3DATABASE23M were verified as ONLINE with the SIMPLE recovery model.

Migration 3 — RDSB3DATABASE31

A full backup of RDSB3DATABASE31 was created on RDSB3SERVER3. The backup was restored on the same instance as RDSB3DATABASE31M, with unique physical data and log file names.

Result: Both RDSB3DATABASE31 and RDSB3DATABASE31M were verified as ONLINE with the FULL recovery model.

Verification

The migrated databases were validated using:

SELECT

    name AS DatabaseName,
    state_desc AS Status,
    recovery_model_desc AS RecoveryModel
    
FROM sys.databases

WHERE name IN ('SourceDatabase', 'MigratedDatabase');

>>Evidence Screenshots:
 docs/screenshots/phase-08

