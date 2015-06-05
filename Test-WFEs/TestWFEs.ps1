[System.Net.ServicePointManager]::DnsRefreshTimeout = 0
#Backup the HOSTS file, prior to making changes
Copy-Item $ENV:windir\System32\drivers\etc\hosts $ENV:windir\System32\drivers\etc\hosts-BACKUP
#List of sites to test
$Sites = Get-Content SitesList.txt
#List of WFEs to test
$WFEs = "192.168.1.50","192.168.1.30"

ForEach ($WFE in $WFEs)
{
    ForEach ($Site in $Sites)
    {
    $URL = $Site.Split(",")
    $WFE + " " + $URL[0].Split("/")[2] | Out-File -Encoding default $ENV:windir\System32\drivers\etc\hosts
        Try {
        $PageRequest = Invoke-WebRequest -Uri $URL[0] -UseDefaultCredentials -UseBasicParsing
        If ($PageRequest.RawContent.Contains($URL[1])){Write-Host $URL[0] "-" $WFE "Successful" -ForegroundColor Green}
        Else {Write-Host $URL[0] "-" $WFE "Failed!" -ForegroundColor Red}
            }

        Catch {
        Write-Host $URL[0] "-" $WFE "Failed!" -ForegroundColor Red
        }
        Finally {
        }
    }
}

Copy-Item $ENV:windir\System32\drivers\etc\hosts-BACKUP $ENV:windir\System32\drivers\etc\hosts