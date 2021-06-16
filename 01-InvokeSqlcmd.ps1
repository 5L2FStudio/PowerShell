Import-Module SQLPS

$Query = @"
SELECT top 3 * FROM 
[Person].[Person] 
"@

$Result = Invoke-Sqlcmd -ServerInstance ".\SQL2019" -Database "AdventureWorks2019" -Query $Query;

$Result | Format-Table *