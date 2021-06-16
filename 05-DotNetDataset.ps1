$Server = ".\SQL2019"
$Database = "AdventureWorks2019"
$Query = @"
SELECT top 3 * FROM 
[Person].[Person] 
"@

function QueryDB2 ($Server = "localhost", $DBName = "master", $Query )
{
    $connection = new-object System.Data.SqlClient.SQLConnection("Data Source=$Server;Integrated Security=SSPI;Initial Catalog=$DBName")
    $cmd = new-object System.Data.SqlClient.SqlCommand($Query, $connection);

    $connection.Open();

    $adapter = new-object System.Data.SqlClient.SqlDataAdapter $cmd
    $dataset = new-object System.Data.Dataset    
    $adapter.Fill($dataset) | Out-Null
    $connection.Close();
    $dataset.Tables[0]
}

$QueryResult = QueryDB2 $Server $Database $Query

$QueryResult | Format-Table *