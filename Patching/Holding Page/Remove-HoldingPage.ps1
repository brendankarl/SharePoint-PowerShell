#==================================================================
# DISCLAIMER:
#
# This sample is provided as is and is not meant for use on a
# production environment. It is provided only for illustrative
# purposes. The end user must test and modify the sample to suit
# their target environment.
#
# Microsoft can make no representation concerning the content of
# this sample. Microsoft is providing this information only as a
# convenience to you. This is to inform you that Microsoft has not
# tested the sample and therefore cannot make any representations
# regarding the quality, safety, or suitability of any code or
# information found here.
#
#===================================================================

#Load SharePoint assembly
$Assemblies = [System.Reflection.Assembly]::LoadWithPartialName("Microsoft.SharePoint")

#Check if the script is running on MOSS 2007
If (Test-Path "C:\Program Files\Common Files\Microsoft Shared\Web Server Extensions\12"){$Mode="2007"}

#Grab all Web Apps
$WebApps = [Microsoft.SharePoint.Administration.SPWebService]::ContentService.WebApplications

#Retrieve Servers 
$Farm = [Microsoft.SharePoint.Administration.SPFarm]::Local
$SPServers = $Farm.Servers | Where {$_.Role -eq "Application"} | Foreach {$_.Name}

Foreach ($WebApp in $WebApps)
{
Foreach ($URL in $WebApp.AlternateUrls)
    {
    If ($Mode = "2007")
    {
    $WebRoot = ($WebApp.GetIisSettingsWithFallback($URL.URLZone)).Path.FullName -replace ":","$"
    }
    Else
    {
    $WebRoot = ($WebApp.GetIisSettingsWithFallback($URL.Zone)).Path.FullName -replace ":","$"
    }
    Write-Host "Removing the Holding Page for" $WebApp.Name "- Zone:" $Url.URLZone -ForegroundColor Green
    Foreach ($Server in $SPServers)
        {
        Write-Host "-Updating" $Server -ForegroundColor Green
        Remove-Item "\\$Server\$Webroot\app_offline.htm"
        }
    }
}