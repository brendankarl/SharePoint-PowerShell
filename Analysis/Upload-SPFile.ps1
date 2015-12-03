#Specify Variables
$SiteURL = "http://intranet.contoso.com"
$FileName = "D:\Documents\Presentation.pptx"
$DocLibName = "Shared Documents"
$LogDirectory = "C:\Logs\"

#Add references to SharePoint client assemblies
Add-Type -Path "C:\Microsoft.SharePoint.Client.dll"
Add-Type -Path "C:\Microsoft.SharePoint.Client.Runtime.dll"

#Create log file for the month if it doesn't already exist
$Date = Get-Date -Format "dd/MM/yyyy"
$Time = Get-Date -Format "HH:mm:ss"
$LogHeaders = "Date" + "," + "Time" + "," + "Success" + "," + "Document Upload Time (s)"
$LogFile = $LogDirectory + "SharePoint Document Upload Performance - " + (Get-Date -Format "MMMM yyyy") + ".csv"
If ((Test-Path $LogFile) -eq $false)
{
$LogHeaders | Out-File -Encoding Default -Append -FilePath $LogFile
}

Try {
#Bind to site collection
$ctx = New-Object Microsoft.SharePoint.Client.ClientContext($SiteURL)

$Web = $ctx.Web
$List = $Web.Lists.GetByTitle($DocLibName)
}
Catch {
Write-Host "Unable to open list" $SiteURL -ForegroundColor Red
}

$TimeTaken = Measure-Command {
Try {
#Upload file
$ctx.ExecuteQuery()
$File = Get-Item $FileName
Write-Host "Uploading:" $File.Name -ForegroundColor Green
$FileStream = New-Object IO.FileStream($File.FullName,[System.IO.FileMode]::Open)
$Upload = [Microsoft.SharePoint.Client.File]::SaveBinaryDirect($ctx,"/$DocLibName/" + $file.Name,$FileStream,$true)
$FileStream.Close()
$Success = "True"
}
Catch {
Write-Host "Unable to upload file" $File.Name  -ForegroundColor Red
$Success = "False"
}
}

$TotalSeconds = [INT]$TimeTaken.TotalSeconds
Write-Host "-Upload took" $TotalSeconds "Seconds" -ForegroundColor Yellow
$Date + "," + $Time + "," + $Success + "," + $TotalSeconds | Out-File -Encoding Default -Append -FilePath $LogFile