#Bind to Web App
$WebApp = Get-SPWebApplication "http://sp2010"
#Configure Auth Setting
$ProxyCreds = New-Object -TypeName "Microsoft.SharePoint.Administration.SPWebConfigModification" -ArgumentList "useDefaultCredentials", "configuration/system.net/defaultProxy"
$ProxyCreds.Sequence = 0
$ProxyCreds.Owner = "Proxy for RSS Feeds"
$ProxyCreds.Type = "1"
$ProxyCreds.Value = "True"
$WebApp.WebConfigModifications.Add($ProxyCreds)
#Add Proxy Section and Required Settings
$Proxy = New-Object -TypeName "Microsoft.SharePoint.Administration.SPWebConfigModification" -ArgumentList "proxy", "configuration/system.net/defaultProxy"
$Proxy.Sequence = 0
$Proxy.Owner = "Proxy for RSS Feeds"
$Proxy.Type = "0"
$Proxy.Value = "<proxy usesystemdefault='False' proxyaddress='http://proxy:8080' bypassonlocal='True'></proxy>"
$WebApp.WebConfigModifications.Add($Proxy)
$WebApp.Update()
$WebApp.Parent.ApplyWebConfigModifications()

#Remove Proxy Settings
$ProxySettings = $Webapp.WebConfigModifications | Where {$_.Owner -eq "Proxy for RSS Feeds"}
Foreach ($ProxySetting in $ProxySettings)
{
$WebApp.WebConfigModifications.Remove($ProxySetting)
$WebApp.Update()
$WebApp.Parent.ApplyWebConfigModifications()
}