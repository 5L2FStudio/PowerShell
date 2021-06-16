Import-Module SQLPS

$Server = ".\SQL2019"
$Database = "AdventureWorks2019"
$Query = @"
SELECT [BusinessEntityID]
,[PersonType]
,[NameStyle]
,[Title]
,[FirstName]
,[MiddleName]
,[LastName]
,[Suffix]
,[EmailPromotion]
,[AdditionalContactInfo]
FROM 
[Person].[Person] 
"@

$TargetTable = "[Person].[PersonMock]"

$connection = new-object System.Data.SqlClient.SQLConnection("Data Source=$Server;Integrated Security=SSPI;Initial Catalog=$Database")
$cmd = new-object System.Data.SqlClient.SqlCommand($Query, $connection);
$connection.Open();
$reader = $cmd.ExecuteReader();

Invoke-Sqlcmd -ServerInstance $Server -Database $Database -Query "TRUNCATE TABLE $TargetTable"

try {
    $RedoConnectionString = "Data Source=$Server;Integrated Security=SSPI;Initial Catalog=$Database"
    $BulkCopy = new-object System.Data.SqlClient.SqlBulkCopy($RedoConnectionString,[System.Data.SqlClient.SqlBulkCopyOptions]::Keepidentity);
    $BulkCopy.DestinationTableName = "[Person].[PersonMock]"
    $BulkCopy.WriteToServer($reader);
}
catch [System.Exception]{
    $ex = $_.Exception;
    Write-Host $ex.Message
}
finally {
    $connection.Close();    
}

