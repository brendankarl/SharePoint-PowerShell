# Set up event logging
$eventLog = Get-EventLog -List | Where-Object {$_.Log -eq 'Application'}
$eventLog.Source = "Custom Logging Event"

[void][System.Reflection.Assembly]::LoadWithPartialName("Microsoft.SharePoint")
$uls = [Microsoft.SharePoint.Administration.SPDiagnosticsService]::Local

# Get the current ULS log setting
$ulsColl = $uls.GetItems()
$ulsLog = $ulsColl | Where-Object {$_.Name -eq 'Unified Logging Service'}

# Set the amount of time to elevate the ULS log to verbose (in seconds)
$timeToElevate = 300 # e.g. 5 minutes 
$elevationMinutes = $timeToElevate / 60

# Get the current severity setting
$ulsSeverity = $ulsLog.TraceSeverity

if ($ulsSeverity -ne 'Verbose')
{
    $eventLog.WriteEntry("An event ID that is being monitored has just been created. ULS logging has been raised to Verbose for $elevationMinutes minutes.", "Warning", 1234)
    $ulsLog.TraceSeverity = 'Verbose'
    Start-Sleep -Seconds $timeToElevate
    $ulsLog.TraceSeverity = $ulsSeverity
    $eventLog.WriteEntry("The time to elevate ULS logging has expired. ULS logging has now been set to $ulsSeverity", "Information", 2345)
}

else 
{
    $eventLog.WriteEntry("Event logging script has just been executed. Not raising ULS level as it is already set to Verbose. Doing nothing :)", "Information", 3456)
}
