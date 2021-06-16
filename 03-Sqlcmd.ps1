$Server = ".\SQL2019"
$Database = "AdventureWorks2019"
$Query = @"
SELECT top 3 * FROM 
[Person].[Person] 
"@

$cmd = sqlcmd -S $Server -d $Database -Q $Query