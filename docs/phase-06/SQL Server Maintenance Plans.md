Configured three SQL Server Maintenance Plans across the RDSB3 environment. 
RDSB3MP1 on RDSB3SERVER1 performs a full backup of RDSB3DATABASE11 every Sunday at 10:00 PM. RDSB3MP2 on RDSB3SERVER2 performs differential backups of RDSB3DATABASE22 every six hours. 
RDSB3MP3 on RDSB3SERVER3 performs transaction-log backups of RDSB3DATABASE33 every 15 minutes. 
Maintenance Cleanup Tasks were added to remove expired backup files, and SQL Server Agent notifications were configured to notify the designated operators when jobs complete. 
The maintenance jobs were manually tested and successfully generated backup files and email notifications. 
Backup integrity was also verified using SQL Server's backup verification functionality.
