Phase 12 — SQL Server Integration Services (SSIS)

Part B: SSIS Project Build and Deployment to SSISDB

After successfully creating and executing the SSIS package that transferred the EmployeeData records from RDSB3DATABASE22 on RDSB3SERVER2 to RDSB3DATABASE33 on RDSB3SERVER3, the final step was to build and deploy the SSIS project to the SQL Server Integration Services Catalog.

12.10 Build the SSIS Project

The RDSB3SSIS project was built in Visual Studio to generate a deployable Integration Services Project Deployment File (.ispac).

The build completed successfully with:

Build: 1 succeeded, 0 failed, 0 skipped
Build complete -- 0 errors, 0 warnings

The generated deployment file was:

RDSB3SSIS.ispac

This confirmed that the SSIS project was internally consistent and ready for deployment.

Evidence: 17_SSIS_Project_Build_Success.png

12.11 Create the Integration Services Catalog

Before deployment, the target SQL Server instance was checked for an Integration Services catalog.

Target server:

WALLIS\RDSB3SERVER3

Although the Integration Services Catalogs node was available, an SSISDB catalog had not yet been created. The Catalog Creation Wizard was therefore used to create it.

CLR Integration was enabled as required by the wizard, and the catalog database was created as:

SSISDB

A password was also configured to protect the SSISDB encryption key.

After creation, SSMS displayed:

Integration Services Catalogs

└── SSISDB

This prepared RDSB3SERVER3 to host deployed SSIS projects.

12.12 Create the SSIS Deployment Folder

A dedicated folder was created inside the SSISDB catalog:

RDSB3SSIS

This folder provides the logical container for the project's deployed packages and associated SSIS objects.

The resulting catalog structure was:

SSISDB

└── RDSB3SSIS

12.13 Configure the Deployment Destination

The Integration Services Deployment Wizard was used to deploy the project using the SSIS in SQL Server deployment target.

The destination configuration was:

- Server:         WALLIS\RDSB3SERVER3

- Authentication: Windows Authentication

- Catalog:        SSISDB

- Folder:         RDSB3SSIS

- Project:        RDSB3SSIS

The final deployment path was:

/SSISDB/RDSB3SSIS/RDSB3SSIS

The deployment source was the previously generated:

RDSB3SSIS.ispac

12.14 Deploy the SSIS Project

After reviewing the source and destination configuration, the project was deployed to RDSB3SERVER3.

The Integration Services Deployment Wizard reported Passed for all deployment operations:

| Deployment operation             | Result |
| -------------------------------- | ------ |
| Loading project                  | Passed |
| Connecting to destination server | Passed |
| Changing protection level        | Passed |
| Deploying project                | Passed |


This confirmed that the RDSB3SSIS project was successfully registered in the Integration Services catalog.

Evidence: 18_SSIS_Project_Deployment_Success.png

12.15 Verify the Deployed Project in SSMS

The final deployment was verified directly through SQL Server Management Studio on RDSB3SERVER3.

The following hierarchy was visible:

Integration Services Catalogs

└── SSISDB

    └── RDSB3SSIS
        └── Projects
            └── RDSB3SSIS
                └── Packages
                    └── RDSB3DataTransfer.dtsx

The presence of RDSB3DataTransfer.dtsx under the deployed RDSB3SSIS project confirmed that the package was successfully stored in the SQL Server Integration Services Catalog.

Evidence: 19_SSISDB_Deployed_Project_Verification.png

Phase 12 Final Result

Phase 12 successfully implemented an end-to-end SSIS data integration and deployment workflow. The RDSB3DataTransfer.dtsx package extracted the EmployeeData dataset from RDSB3DATABASE22 on RDSB3SERVER2 and loaded all 5 records into RDSB3DATABASE33 on RDSB3SERVER3. The transferred records were independently verified in SSMS.

The RDSB3SSIS project was subsequently built with 0 errors and 0 warnings, an SSISDB catalog and RDSB3SSIS deployment folder were created on RDSB3SERVER3, and the project was successfully deployed to /SSISDB/RDSB3SSIS/RDSB3SSIS. Final verification in SSMS confirmed that RDSB3DataTransfer.dtsx was present in the deployed project's Packages collection.

Phase 12 Status: COMPLETE — SSIS package creation, ETL execution, data verification, project build, SSISDB configuration, deployment, and post-deployment verification were all successfully completed.

>>> This phase completes our Project!!
