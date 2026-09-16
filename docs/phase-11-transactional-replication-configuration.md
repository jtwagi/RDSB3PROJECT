Phase 14 — Transactional Replication Configuration

Objective

Configure SQL Server transactional replication for RDSB3DATABASE11 using the following working topology:

RDSB3SERVER1(
Publisher)

RDSB3DATABASE11

      │
      ▼
RDSB3SERVER2(
Distributor)

distribution

      │
      ▼
RDSB3SERVER3(
Subscriber)

RDSB3DATABASE11_REPLICA

>> Note: The provided requirement states that RDSB3DATABASE11 should replicate “from RDSB3SERVER1 to RDSB3SERVER3,” while another bullet identifies RDSB3SERVER1 as the Subscriber. The implemented topology uses RDSB3SERVER3 as Subscriber, consistent with the stated SERVER1 → SERVER3 data flow.

14.1 Configure the Distributor

RDSB3SERVER2 was configured as the Distributor using the Configure Distribution Wizard.

Configuration:

| Setting               | Value               |
| --------------------- | ------------------- |
| Distributor           | `RDSB3SERVER2`      |
| Distribution database | `distribution`      |
| Snapshot share        | `\\Wallis\ReplData` |
| Remote Publisher      | `RDSB3SERVER1`      |


The ReplData directory was shared so replication agents could access publication snapshots.

The Distribution Wizard completed successfully with:

5 Success / 0 Errors / 0 Warnings

Evidence: 01_Distributor_Configuration_Success.png

14.2 Prepare the Publication Database

The source database was:

RDSB3SERVER1.RDSB3DATABASE11

Because the database initially contained no user tables eligible for replication, a test table with a primary key was created:

USE RDSB3DATABASE11;
GO

CREATE TABLE dbo.ReplicationTest
(

    ReplicationID INT IDENTITY(1,1) PRIMARY KEY,
    TestMessage VARCHAR(100) NOT NULL,
    CreatedDate DATETIME2 DEFAULT SYSDATETIME()
    
);
GO

INSERT INTO dbo.ReplicationTest (TestMessage)
VALUES

    ('Replication Test Record 1'),
    ('Replication Test Record 2'),
    ('Replication Test Record 3');
    
GO

SELECT *
FROM dbo.ReplicationTest;

GO

The three records provided an initial dataset for validating snapshot initialization.

Evidence: 03_Publisher_ReplicationTest_Data.png

14.3 Create the Transactional Publication

A transactional publication was created on RDSB3SERVER1.

Configuration:

| Setting              | Value                 |
| -------------------- | --------------------- |
| Publisher            | `RDSB3SERVER1`        |
| Publication database | `RDSB3DATABASE11`     |
| Publication          | `RDSB3Publication11`  |
| Publication type     | Transactional         |
| Article              | `dbo.ReplicationTest` |
| Distributor          | `RDSB3SERVER2`        |
| Row filtering        | None                  |
| Initial snapshot     | Create immediately    |


The publication configuration completed successfully:

5 Success / 0 Errors / 0 Warnings

A reusable SQL configuration script was also generated:

C:\Users\josep\Documents\CreatePublication.sql

Evidence: 04_Transactional_Publication_Success.png

14.4 Snapshot Agent Security Troubleshooting

The initial Snapshot Agent execution failed with:

Login failed for user

'NT Service\SQLAgent$RDSB3SERVER2'.

The Snapshot Agent was running through the Distributor and needed permission to connect to the publication database on SERVER1.

The following permissions were therefore configured on RDSB3SERVER1:

USE master;

GO

CREATE LOGIN [NT SERVICE\SQLAgent$RDSB3SERVER2]

FROM WINDOWS;

GO

USE RDSB3DATABASE11;

GO

CREATE USER [NT SERVICE\SQLAgent$RDSB3SERVER2]

FOR LOGIN [NT SERVICE\SQLAgent$RDSB3SERVER2];

GO

ALTER ROLE db_owner

ADD MEMBER [NT SERVICE\SQLAgent$RDSB3SERVER2];

GO


After correcting the permissions, the Snapshot Agent was restarted and reported:

>> [100%] A snapshot of 1 article(s) was generated.

This confirmed that the schema and initial data were successfully prepared for subscriber initialization.

Evidence: 05_Snapshot_Agent_Success.png

14.5 Configure the Subscriber

A push subscription was created, with the Distribution Agent running at RDSB3SERVER2.

The Subscriber was configured as:

| Setting                     | Value                      |
| --------------------------- | -------------------------- |
| Subscriber                  | `RDSB3SERVER3`             |
| Subscription database       | `RDSB3DATABASE11_REPLICA`  |
| Subscription type           | Push                       |
| Distribution Agent location | Distributor                |
| Agent schedule              | Run continuously           |
| Initialization              | Immediately using snapshot |


A new database named:

RDSB3DATABASE11_REPLICA

was created specifically on RDSB3SERVER3.

14.6 Distribution Agent Security

The Distribution Agent was configured to:

- Run under the SQL Server Agent service account.
- Connect to the Distributor by impersonating the process account.
- Connect to the Subscriber by impersonating the process account.

Because the Distribution Agent runs on SERVER2, its service identity required access to the subscription database on SERVER3.

On RDSB3SERVER3:

USE master;
GO

CREATE LOGIN [NT SERVICE\SQLAgent$RDSB3SERVER2]

FROM WINDOWS;

GO

USE RDSB3DATABASE11_REPLICA;

GO

CREATE USER [NT SERVICE\SQLAgent$RDSB3SERVER2]

FOR LOGIN [NT SERVICE\SQLAgent$RDSB3SERVER2];

GO

ALTER ROLE db_owner

ADD MEMBER [NT SERVICE\SQLAgent$RDSB3SERVER2];

GO

The commands completed successfully.

14.7 Create the Subscription

The New Subscription Wizard was completed using immediate snapshot initialization and a continuously running Distribution Agent.

The wizard reported:

2 Success / 0 Errors / 0 Warnings

A reusable subscription script was generated:

C:\Users\josep\Documents\NewSubscription.sql

Evidence: 06_Replication_Subscription_Creation_Success.png

14.8 Verify Initial Snapshot Replication

On RDSB3SERVER3, the subscription database was queried:

USE RDSB3DATABASE11_REPLICA;

GO


SELECT *

FROM dbo.ReplicationTest;

GO

The Subscriber contained the three original Publisher records:

| ReplicationID | TestMessage               |
| ------------: | ------------------------- |
|             1 | Replication Test Record 1 |
|             2 | Replication Test Record 2 |
|             3 | Replication Test Record 3 |

This demonstrated successful snapshot initialization.

Evidence: 07_Initial_Replication_Verified_SERVER3.png

14.9 Verify Live Transactional Replication

To demonstrate that replication continued after initialization, a new transaction was performed only on SERVER1:

USE RDSB3DATABASE11;

GO

INSERT INTO dbo.ReplicationTest (TestMessage)

VALUES ('Live Transactional Replication Test');

GO

SELECT *

FROM dbo.ReplicationTest;

GO

SERVER1 then contained:

>> 4 | Live Transactional Replication Test

Evidence: 08_New_Transaction_Publisher_SERVER1.png

Without manually inserting the row on SERVER3, the Subscriber was queried:

USE RDSB3DATABASE11_REPLICA;

GO

SELECT *

FROM dbo.ReplicationTest

ORDER BY ReplicationID;

GO

>> SERVER3 automatically contained:

4 | Live Transactional Replication Test

This provided direct evidence that transactions were successfully propagating through:

SERVER1 Publisher

        ↓
SERVER2 Distributor

        ↓
SERVER3 Subscriber

Evidence: 09_Live_Transactional_Replication_Verified_SERVER3.png

14.10 Replication Monitor Verification

SQL Server Replication Monitor was used for final operational verification.

RDSB3Publication11 reported:

| Metric      | Result        |
| ----------- | ------------- |
| Status      | **Running**   |
| Performance | **Excellent** |
| Latency     | **00:00:00**  |
| Subscriber  | SERVER3       |


Evidence: 10_Replication_Monitor_Running.png

Final Result

Transactional replication was successfully configured and validated.

The completed topology is:

RDSB3SERVER1(
Publisher)

RDSB3DATABASE11

dbo.ReplicationTest

       │
       │ Transactional Replication
       ▼
RDSB3SERVER2(
Distributor)

distribution

       │
       │ Push Subscription
       ▼
RDSB3SERVER3(
Subscriber)

RDSB3DATABASE11_REPLICA

dbo.ReplicationTest

Successful initial snapshot delivery established the Subscriber, and a subsequent test transaction inserted on SERVER1 automatically appeared on SERVER3. Replication Monitor additionally confirmed that the subscription was Running with Excellent performance and zero displayed latency.

>> All of the followin evidence screenshots can be found in folder: docs/screenshots/phase-11

01_Distributor_Configuration_Success.png
04_Transactional_Publication_Success.png
05_Snapshot_Agent_Success.png
06_Replication_Subscription_Creation_Success.png
09_Live_Transactional_Replication_Verified_SERVER3.png
10_Replication_Monitor_Running.png
