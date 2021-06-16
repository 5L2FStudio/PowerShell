$Server = ".\SQL2019"
$Database = "AdventureWorks2019"
$Query = @"
SELECT top 3 * FROM 
[Person].[Person] 
"@

function QueryDB1 ($Server = "localhost", $DBName = "master", $Query )
{
    $connection = new-object System.Data.SqlClient.SQLConnection("Data Source=$Server;Integrated Security=SSPI;Initial Catalog=$DBName")
    $cmd = new-object System.Data.SqlClient.SqlCommand($Query, $connection);

    $connection.Open();
    $reader = $cmd.ExecuteReader();

    $result = @();
    while ($reader.Read()) {
        $row = @{ }
        for ($i = 0; $i -lt $reader.FieldCount; $i++)
        {
            $row[$reader.GetName($i)]=$reader.GetValue($i)
        }
        $result += new-object psobject -property $row
    }
    $connection.Close();
    $result
}

$QueryResult = QueryDB1 $Server $Database $Query

$QueryResult | Format-Table *