Phase 12 — SQL Server Integration Services (SSIS) Data Transfer
Objective

The objective of this phase was to configure and execute an SSIS ETL package that transfers employee data between two SQL Server instances.

The implemented data flow was:

Source:

- RDSB3SERVER2 → RDSB3DATABASE22 → dbo.EmployeeData
  
SSIS Package:

- RDSB3DataTransfer.dtsx

Destination:

- RDSB3SERVER3 → RDSB3DATABASE33 → dbo.EmployeeData

12.1 SSIS Development Environment Setup

Visual Studio Community 2026 was installed and configured for SQL Server development.

The Data storage and processing workload, including SQL Server Data Tools (SSDT), was installed. Because the Integration Services project template was not initially available, the Microsoft SQL Server Integration Services Projects 2022+ version 2.2 extension was downloaded and installed.

After installation, Visual Studio successfully displayed the Integration Services Project template.

An SSIS project was created with:

Project Name: RDSB3SSIS

Solution Name: RDSB3SSIS

The default package was renamed to:

RDSB3DataTransfer.dtsx

12.2 Source Data Preparation

The source data was stored in RDSB3DATABASE22 on RDSB3SERVER2.

The following source table was created:

USE RDSB3DATABASE22;

GO

CREATE TABLE dbo.EmployeeData
(

    EmployeeID INT IDENTITY(1,1) PRIMARY KEY,
    FirstName VARCHAR(50) NOT NULL,
    LastName VARCHAR(50) NOT NULL,
    Department VARCHAR(50) NOT NULL,
    Salary DECIMAL(10,2) NOT NULL,
    HireDate DATE NOT NULL
    
);

GO

Five test records were inserted representing employees from IT, Finance, Operations, and HR.

The source table contained 5 rows before the SSIS transfer.

12.3 OLE DB Connection Managers

Two OLE DB connection managers were configured.

Source connection:

- Server: WALLIS\RDSB3SERVER2

- Database: RDSB3DATABASE22

- Provider: Microsoft OLE DB Driver 19 for SQL Server

- Authentication: Windows Integrated Security

- Trust Server Certificate: True

Destination connection:

- Server: WALLIS\RDSB3SERVER3

- Database: RDSB3DATABASE33

- Provider: Microsoft OLE DB Driver 19 for SQL Server

- Authentication: Windows Integrated Security

- Trust Server Certificate: True

During configuration, the initial connection test produced an SSL certificate trust error:

>> The certificate chain was issued by an authority that is not trusted.

This was resolved for the development environment by setting:

> Trust Server Certificate = True

Both connections subsequently tested successfully.

12.4 Data Flow Task Configuration

A Data Flow Task was added to the SSIS package and named:

Transfer EmployeeData SERVER2 to SERVER3

Inside the Data Flow, an OLE DB Source and OLE DB Destination were configured.

The source component was named:

EmployeeData - SERVER2 Source

It used:

WALLIS\RDSB3SERVER2

    ↓
RDSB3DATABASE22

    ↓
dbo.EmployeeData

The source preview successfully returned all five EmployeeData records, confirming that SSIS could read the source data.

12.5 Destination Configuration

The destination component was named:

EmployeeData - SERVER3 Destination

It used:

WALLIS\RDSB3SERVER3

    ↓
RDSB3DATABASE33

    ↓
dbo.EmployeeData

The destination table was created through the OLE DB Destination Editor using the source metadata:

CREATE TABLE [dbo].[EmployeeData] (

    [EmployeeID] int,
    [FirstName] varchar(50),
    [LastName] varchar(50),
    [Department] varchar(50),
    [Salary] numeric(10,2),
    [HireDate] date
    
);

The destination was configured using:

>> Data Access Mode: Table or view - fast load

12.6 Column Mapping

All six source columns were mapped directly to their corresponding destination columns:

| Source Column | Destination Column |
| ------------- | ------------------ |
| EmployeeID    | EmployeeID         |
| FirstName     | FirstName          |
| LastName      | LastName           |
| Department    | Department         |
| Salary        | Salary             |
| HireDate      | HireDate           |


No transformation was required because the source and destination schemas were compatible.

12.7 Package Execution

The completed SSIS data flow was:

EmployeeData - SERVER2 Source

             │
             │  5 rows
             ▼
EmployeeData - SERVER3 Destination

The package was executed from Visual Studio.

Both the OLE DB Source and OLE DB Destination returned successful execution indicators, and the data path reported:

>> 5 rows

Visual Studio also reported:

>>> Package execution completed with success.

This confirmed successful execution of the SSIS package.

Evidence screenshot:

> 16_SSIS_Data_Transfer_5_Rows_Success.png (inside the docs/screenshots/phase-12 folder)

15.8 Destination Verification

After execution, the destination was independently verified through SQL Server Management Studio on RDSB3SERVER3.

The following query was executed:

USE RDSB3DATABASE33;

GO

SELECT *
FROM dbo.EmployeeData

ORDER BY EmployeeID;

GO

The query returned:

| EmployeeID | FirstName | LastName | Department |   Salary | HireDate   |
| ---------: | --------- | -------- | ---------- | -------: | ---------- |
|          1 | James     | Smith    | IT         | 72000.00 | 2024-01-15 |
|          2 | Maria     | Garcia   | Finance    | 68000.00 | 2023-06-10 |
|          3 | David     | Johnson  | Operations | 65000.00 | 2024-03-20 |
|          4 | Sarah     | Williams | HR         | 62000.00 | 2023-11-05 |
|          5 | Michael   | Brown    | IT         | 75000.00 | 2022-08-17 |


All 5 source records were present on SERVER3, confirming successful transfer and data integrity for the test dataset.

Evidence screenshot:

>> 17_SSIS_Destination_Data_Verified_SERVER3.png(Inside screenshots/phase-12 folder)

Phase Result — SUCCESS ✅

The SSIS package successfully transferred data across two independent SQL Server instances:

WALLIS\RDSB3SERVER2

└── RDSB3DATABASE22

    └── dbo.EmployeeData
    
            │
            │ OLE DB Source
            ▼
      RDSB3DataTransfer.dtsx
            │
            │ OLE DB Destination
            ▼
WALLIS\RDSB3SERVER3

└── RDSB3DATABASE33

    └── dbo.EmployeeData

The package transferred 5 of 5 records successfully, and the destination data was independently verified in SSMS.

>>> screenshots for this phase inside docs/screenshots/phase-12 folder
