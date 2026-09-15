Phase 07 – Database Maintenance Plans
Objective

Configure automated database maintenance plans on all three SQL Server instances to perform database integrity checks, space maintenance, index optimization, and statistics updates.

Maintenance Plans Created
| SQL Server Instance | Maintenance Plan | Databases                                               |
| ------------------- | ---------------- | ------------------------------------------------------- |
| `RDSB3SERVER1`      | `RDSB3MPALL1`    | `RDSB3DATABASE11`, `RDSB3DATABASE12`, `RDSB3DATABASE13` |
| `RDSB3SERVER2`      | `RDSB3MPALL2`    | `RDSB3DATABASE21`, `RDSB3DATABASE22`, `RDSB3DATABASE23` |
| `RDSB3SERVER3`      | `RDSB3MPALL3`    | `RDSB3DATABASE31`, `RDSB3DATABASE32`, `RDSB3DATABASE33` |

Maintenance Tasks Configured
Each maintenance plan contains the following tasks, connected with success precedence constraints so that each task executes only after the previous task succeeds:

Check Database Integrity → Shrink Database → Reorganize Index → Rebuild Index → Update Statistics

Key configurations:

1. Check Database Integrity: Selected all three databases on the corresponding instance and included indexes.
2. Shrink Database: Configured to run when the database exceeds 50 MB, leaving 10% free space and returning freed space to the operating system.
3. Reorganize Index: Configured for tables and views, with large-object compaction enabled. Index optimization applies when fragmentation exceeds 15% and page count exceeds 1,000.
4. Rebuild Index: Configured for tables and views using the original free-space settings. Rebuild applies when fragmentation exceeds 30% and page count exceeds 1,000.
5. Update Statistics: Configured for all existing statistics using a Full Scan.

Schedule

All three maintenance plans were configured to execute:

Weekly → Sunday → 2:00 AM → No end date

SQL Server Agent automatically created the corresponding jobs:

- RDSB3MPALL1.Subplan_1
- RDSB3MPALL2.Subplan_1
- RDSB3MPALL3.Subplan_1

Testing and Verification

Each maintenance-plan job was manually executed through SQL Server Agent → Jobs → Start Job at Step. All three maintenance plans completed successfully.

>> screenshots in Folder: docs/screenshots/phase-07

Result: Success – 2 Total / 2 Success

This confirms that the maintenance plans are properly configured, scheduled, and executable across all three SQL Server instances.
