$Site = Get-SPSite "http://intranet.contoso.com"
$Output = "D:\SiteUsers.csv"
"Display Name" + "," + "Username" + "," | Out-File -Encoding Default -FilePath $Output

$UniquePerms = $Site.RootWeb.Users
$AllUsers += $UniquePerms

Foreach ($Web in $Site.AllWebs)
{
Write-Host "Processing:"$Web.URL -ForegroundColor Green
    Foreach ($Group in ($Web.Groups))
    {
    Write-Host "-Checking:"$Group.Name
    $Users = Get-SPUser -Web $Web.Url -Group $Group.Name
    $AllUsers += $Users
    }
}

$AllUsers = $AllUsers | Sort-Object | Get-Unique
Foreach ($User in $AllUsers)
{
$User.DisplayName.Replace(",","") + "," + $User.UserLogin | Out-File -Encoding Default -FilePath $Output -Append
}