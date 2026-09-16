# RDSB3PROJECT
# SQL Server DBA End-to-End Project

## Overview

This project demonstrates the implementation and administration of a multi-instance Microsoft SQL Server environment. Three SQL Server instances are used to simulate common DBA responsibilities, including database provisioning, security management, backup and recovery, maintenance automation, database migration, high availability, disaster recovery, replication, and ETL operations.

The project provides hands-on experience with SQL Server Management Studio (SSMS), SQL Server Agent, Database Mail, Maintenance Plans, and SQL Server Integration Services (SSIS).

## Environment

The lab consists of three SQL Server instances:

* `RDSB3SERVER1`
* `RDSB3SERVER2`
* `RDSB3SERVER3`

Each instance hosts multiple databases for administrative and disaster-recovery exercises.

## Key Tasks

The project includes:

* Installing and configuring multiple SQL Server instances
* Creating and managing databases
* Configuring FULL, BULK_LOGGED, and SIMPLE recovery models
* Creating SQL Server logins and database users
* Managing database permissions and roles
* Configuring SQL Server Database Mail
* Creating SQL Server Agent operators and notifications
* Automating FULL, differential, and transaction log backups
* Configuring backup cleanup and retention policies
* Creating database maintenance plans
* Running database integrity checks
* Reorganizing and rebuilding indexes
* Updating database statistics
* Performing database migrations
* Configuring database mirroring
* Configuring log shipping
* Configuring SQL Server replication
* Creating an SSIS package for cross-server data transfer
* Scheduling administrative tasks with SQL Server Agent

## Database Environment

Each SQL Server instance contains three project databases.

**RDSB3SERVER1**
`RDSB3DATABASE11`, `RDSB3DATABASE12`, `RDSB3DATABASE13`

**RDSB3SERVER2**
`RDSB3DATABASE21`, `RDSB3DATABASE22`, `RDSB3DATABASE23`

**RDSB3SERVER3**
`RDSB3DATABASE31`, `RDSB3DATABASE32`, `RDSB3DATABASE33`

## Technologies

* Microsoft SQL Server
* SQL Server Management Studio (SSMS)
* T-SQL
* SQL Server Agent
* SQL Server Database Mail
* SQL Server Maintenance Plans
* SQL Server Integration Services (SSIS)
* SQL Server Backup and Restore
* Database Mirroring
* Log Shipping
* SQL Server Replication

## Project Goal

The goal of this project is to build practical SQL Server DBA experience by managing a realistic multi-instance database environment and implementing common production administration, automation, backup, recovery, migration, and high-availability workflows.

## Status

COMPLETE ✅

The project is completed and documented phase by phase. Configuration scripts, validation queries, screenshots, troubleshooting notes, and implementation documentation can be found in the documents inside the docs folder.
