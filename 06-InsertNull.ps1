Import-Module SQLPS

$Server = ".\SQL2019"
$Database = "AdventureWorks2019"
$Query = @"
SELECT top 10 * FROM 
[Person].[Person] 
"@

$DBNULL = [System.DBNULL]::Value ;
$connection = new-object System.Data.SqlClient.SQLConnection("Data Source=$Server;Integrated Security=SSPI;Initial Catalog=$Database")
$cmd = new-object System.Data.SqlClient.SqlCommand($Query, $connection);
$connection.Open();
$reader = $cmd.ExecuteReader();
$title = "";
while ($reader.Read()) {
    IF ( ( $reader.GetValue(3) -eq $DBNULL ) -OR ( $reader.GetValue(3) -eq $NULL )){
        $title = "NULL"
    } else {
        $title = "'$($reader.GetValue(3))'"  
    }
 
    $InsertQuery = "insert into [Person].[PersonMock] values('$($reader.GetValue(0))','$($reader.GetValue(1))',"+
        "'$($reader.GetValue(2))',$title,'$($reader.GetValue(4))','$($reader.GetValue(5))',"+
        "'$($reader.GetValue(6))','$($reader.GetValue(7))','$($reader.GetValue(8))','$($reader.GetValue(9))');"
    
    #$InsertQuery | Out-File "D:\Temp\ErrorLog.txt" -Append
    Invoke-Sqlcmd -ServerInstance $Server -Database $Database -Query $InsertQuery        
}
$connection.Close();