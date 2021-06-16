Import-Module SQLPS

# Invoke-Sqlcmd not support hierarchyid data type
# OrganizationNode hierarchyid
$Query = @"
SELECT 
    [BusinessEntityID], [NationalIDNumber], [LoginID], [OrganizationNode], [OrganizationLevel], [JobTitle], [BirthDate]
FROM [HumanResources].[Employee]
"@

$Result = Invoke-Sqlcmd -ServerInstance ".\SQL2019" -Database "AdventureWorks2019" -Query $Query;

$Result | Format-Table *

