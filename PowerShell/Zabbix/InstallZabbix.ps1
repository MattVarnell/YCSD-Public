
$source = "\\Path\apps\zabbix"
$Destination = "c:\zabbix"
$OSARCH = Get-WmiObject win32_operatingsystem | Select-Object osarchitecture
$zbxservice = get-service *zabb* -ErrorAction SilentlyContinue
$Site = $ENV:COMPUTERNAME.Substring(0,3)
#Enter-pssession <server name>
if ($zbxservice.length -gt 0)
 {
     get-service *zabb* | stop-service
     Get-ChildItem -Path $Destination -Recurse | Remove-Item -force -recurse
     Remove-Item $Destination -Force -Recurse
 }
 else
 {
     #continue
 }


 
if (!(Test-Path $Destination))
{
    Copy-Item $source\x64\zabbix -Destination $Destination -Recurse
}
else
{
    
   Remove-Item $Destination -Force -Recurse
   Copy-Item $source\x64\zabbix -Destination $Destination -Recurse
}
Copy-Item $source\$site\zabbix.conf -Destination $Destination -Recurse
c:\zabbix\zabbix_agentd.exe --config c:\zabbix\zabbix.conf --install
New-NetFirewallRule -Name zabbix -DisplayName zabbix -Enabled true -Direction In -Action Allow -Program "C:\zabbix\zabbix_agentd.exe"
get-service "zabbix agent" | start-service
Get-Service $