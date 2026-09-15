Phase 09 — Database Mirroring

Objective

Configure database mirroring for RDSB3DATABASE13 between:

| Role      | SQL Server Instance | Database          | Endpoint |
| --------- | ------------------- | ----------------- | -------- |
| Principal | `RDSB3SERVER1`      | `RDSB3DATABASE13` | TCP 5022 |
| Mirror    | `RDSB3SERVER3`      | `RDSB3DATABASE13` | TCP 5023 |

Configuration

The principal database was changed from SIMPLE to FULL recovery model, which is required for database mirroring.

A fresh full database backup and subsequent transaction log backups were created on RDSB3SERVER1. These backups were restored to RDSB3SERVER3 using:

WITH NORECOVERY

This left the mirror database in the required RESTORING state.

Because RDSB3DATABASE13 already existed on SERVER3 from Phase 08 migration testing, that copy was preserved as:

RDSB3DATABASE13_MIGRATION

The mirror was then initialized under the required database name RDSB3DATABASE13.

Mirroring Endpoints

Database mirroring endpoints were created and started:

RDSB3SERVER1 → RDSB3_Mirroring_Endpoint → TCP 5022
RDSB3SERVER3 → RDSB3_Mirroring_Endpoint → TCP 5023

Separate ports were necessary because both SQL Server instances are running on the same Windows machine.

Endpoint connectivity was verified, and the respective SQL Server service accounts were granted CONNECT permission on the partner endpoints.

Mirroring Partnership

The partners were configured using:

-- SERVER3 → Principal

ALTER DATABASE RDSB3DATABASE13

SET PARTNER = 'TCP://Wallis:5022';

-- SERVER1 → Mirror

ALTER DATABASE RDSB3DATABASE13

SET PARTNER = 'TCP://Wallis:5023';

Verification

The final mirroring configuration was verified through sys.database_mirroring.

RDSB3SERVER1

Role:         PRINCIPAL

State:        SYNCHRONIZED

Safety Level: FULL

Partner:      TCP://Wallis:5023

RDSB3SERVER3

Role:         MIRROR

State:        SYNCHRONIZED

Safety Level: FULL

Partner:      TCP://Wallis:5022

This confirms that the principal and mirror databases are successfully synchronized.

Evidence: docs/screenshots/phase-09
