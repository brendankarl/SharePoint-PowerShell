#Specify four script blocks for the four batches of upgrades to perform
$Batch1 = {
asnp *SharePoint* -ea 0
$CDB = Get-SPContentDatabase
$Count = $CDB.Count
$BatchSize = [Decimal]::Round(($Count/4))
$CDB[0..($BatchSize -1)] | Upgrade-SPContentDatabase -Confirm:$false
}

$Batch2 = {
asnp *SharePoint* -ea 0
$CDB = Get-SPContentDatabase
$Count = $CDB.Count
$BatchSize = [Decimal]::Round(($Count/4))
$CDB[$BatchSize..($BatchSize * 2)] | Upgrade-SPContentDatabase -Confirm:$false
}

$Batch3 = {
asnp *SharePoint* -ea 0
$CDB = Get-SPContentDatabase
$Count = $CDB.Count
$BatchSize = [Decimal]::Round(($Count/4))
$CDB[($BatchSize * 2 + 1)..($BatchSize * 3)] | Upgrade-SPContentDatabase -Confirm:$false
}

$Batch4 = {
asnp *SharePoint* -ea 0
$CDB = Get-SPContentDatabase
$Count = $CDB.Count
$BatchSize = [Decimal]::Round(($Count/4))
$CDB[($BatchSize * 3 + 1)..($Count -1)] | Upgrade-SPContentDatabase -Confirm:$false
}

#Start the four upgrade jobs in parallel
Start-Job -ScriptBlock $Batch1
Start-Job -ScriptBlock $Batch2
Start-Job -ScriptBlock $Batch3
Start-Job -ScriptBlock $Batch4

#Report the status - re-run as needed
Get-Job
#Reports the job output
Get-Job | Receive-Job