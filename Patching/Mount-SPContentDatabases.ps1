asnp *SharePoint* -ea 0
$CDBs = Get-Content "D:\output.csv" | Select -Skip 1
Foreach ($CDB in $CDBs)
{
$CDBtoAdd = $CDB.Split(",")
Write-Host "Attaching " $CDBtoAdd[0] " to WebApp" $CDBtoAdd[4] -ForegroundColor Green
Mount-SPContentDatabase -Name $CDBtoAdd[0] -DatabaseServer $CDBtoAdd[1] -MaxSiteCount $CDBtoAdd[2] -WarningSiteCount $CDBtoAdd[3] -WebApplication $CDBtoAdd[4]
}