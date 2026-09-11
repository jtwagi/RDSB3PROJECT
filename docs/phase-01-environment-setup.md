Phase 1 — SQL Server Environment Setup & Instance Installation
1. Objective

Set up the SQL Server environment required for the RDSB3 DBA project by installing and configuring three independent SQL Server instances on the same Windows machine:

RDSB3SERVER1
RDSB3SERVER2
RDSB3SERVER3

All three instances use the same Windows administrative account.

2. Software environment

I installed/configured:

Microsoft SQL Server 2025
Edition: Enterprise Developer Edition (64-bit)
Version: 17.0.1000.7

SQL Server Management Studio (SSMS)
SQL Server Integration Services
SQL Server Replication
SQL Server Agent

I already had SSMS installed before starting this phase.

My Laptop already contained the following instances:

MSSQLSERVER      -- existing default Developer instance
SQLEXPRESS       -- existing Express instance

I left both existing instances intact and created the three project instances separately.

3. SQL Server installation method

I launched the SQL Server 2025 Enterprise Developer installer with administrative privileges and used the custom/installation-center workflow.

For each project server i selected:

Perform a new installation of SQL Server 2025

rather than adding features to an existing instance.

Edition selected:

Enterprise Developer

The Azure Extension was not needed for this local DBA lab environment.

4. Features installed

For each project instance, I selected:

☑ Database Engine Services
    ☑ SQL Server Replication

Integration Services had already been installed as a shared SQL Server feature, so it did not need to be reinstalled for every named instance.

Replication was deliberately included because a later project requirement calls for configuring replication between the RDSB3 servers.

5. Instance configuration

Three named instances were created.

Instance 1
Name: RDSB3SERVER1
ID:   RDSB3SERVER1

Instance 2
Name: RDSB3SERVER2
ID:   RDSB3SERVER2

Instance 3
Name: RDSB3SERVER3
ID:   RDSB3SERVER3

Therefore the SSMS connection names are:

localhost\RDSB3SERVER1
localhost\RDSB3SERVER2
localhost\RDSB3SERVER3

This directly implements the three-instance requirement in the project specification.

6. SQL Server service configuration

For the new instances, I configured:

SQL Server Database Engine    Automatic
SQL Server Agent              Automatic
SQL Server Browser            Disabled

The default SQL Server virtual service accounts were retained.

I also enabled:

☑ Grant Perform Volume Maintenance Tasks privilege

This enables Instant File Initialization for database data files. The DBA best-practices material specifically recommends Instant File Initialization because it can speed operations including database creation, restore and data-file growth.

7. Authentication and administrator configuration

I selected:

Windows Authentication Mode

and added the current Windows account as a SQL Server administrator:

WALLIS\josep

I repeated this configuration across the project instances, satisfying the requirement that the instances use the same Windows login/admin account.

8. Installation verification

After installation, SQL Server Setup reported successful installation of:

Database Engine Services    Succeeded
SQL Server Replication      Succeeded

I then connected to each named instance independently through SSMS.

The verification query used was:

SELECT
    @@SERVERNAME AS ServerName,
    SERVERPROPERTY('InstanceName') AS InstanceName,
    SERVERPROPERTY('Edition') AS Edition,
    SERVERPROPERTY('ProductVersion') AS ProductVersion;

For example, RDSB3SERVER1 returned:

ServerName:      Wallis\RDSB3SERVER1
InstanceName:    RDSB3SERVER1
Edition:         Enterprise Developer Edition (64-bit)
ProductVersion:  17.0.1000.7

I subsequently verified RDSB3SERVER2 and RDSB3SERVER3 as well.

9. Final Phase 1 environment

The project topology is now:

                    WINDOWS MACHINE: WALLIS
                           │
           ┌───────────────┼───────────────┐
           │               │               │
           ▼               ▼               ▼
    RDSB3SERVER1     RDSB3SERVER2     RDSB3SERVER3
           │               │               │
    SQL Server 2025  SQL Server 2025  SQL Server 2025
    Enterprise Dev   Enterprise Dev   Enterprise Dev
           │               │               │
    SQL Agent         SQL Agent         SQL Agent
    Replication       Replication       Replication

Phase 1 status: COMPLETE ✅
