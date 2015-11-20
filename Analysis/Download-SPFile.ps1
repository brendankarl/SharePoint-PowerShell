#File to download
$FileURL = "http://intranet/Shared Documents/Test.pptx"

#Directory to download file to
$DownloadDir = "C:\Download\"

#Log file 
$LogDirectory = "C:\Logs\"

#Create log file for the month if it doesn't already exist
$Date = Get-Date -Format "dd/MM/yyyy"
$Time = Get-Date -Format "HH:mm:ss"
$LogHeaders = "Date" + "," + "Time" + "," + "Success" + "," + "Document Download Time (s)"
$LogFile = $LogDirectory + "SharePoint Document Download Performance - " + (Get-Date -Format "MMMM yyyy") + ".csv"
If ((Test-Path $LogFile) -eq $false)
{
$LogHeaders | Out-File -Encoding Default -Append -FilePath $LogFile
}

Try {
Write-Host "Downloading:" ($FileURL.Split("/")[-1]) -ForegroundColor Green
$TimeTaken = Measure-Command {
Invoke-WebRequest -Uri $FileURL -OutFile ($DownloadDir + ($FileURL.Split("/")[-1])) -UseDefaultCredentials
$Success = "True"
}

$TotalSeconds = [INT]$TimeTaken.TotalSeconds
Write-Host "-Download took" $TotalSeconds "Seconds" -ForegroundColor Yellow
}
Catch
{
Write-Host "Error Downloading:" ($FileURL.Split("/")[-1]) -ForegroundColor Red
$Success = "False"
}

$Date + "," + $Time + "," + $Success + "," + $TotalSeconds | Out-File -Encoding Default -Append -FilePath $LogFile
