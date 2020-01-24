$action = New-ScheduledTaskAction -Execute 'Powershell.exe' -Argument '-executionpolicy bypass -NoProfile -WindowStyle Hidden -command "& \\ycsd.york.va.us\shares\apps\zabbix\update-zabbix.ps1"'
#$action = New-ScheduledTaskAction -Execute 'Powershell.exe' -Argument '-executionpolicy bypass -NoProfile -WindowStyle Hidden -command "& \zabbix\update-zabbix.ps1"'
$trigger = New-ScheduledTaskTrigger -once -at 9am
$UserName = "chafner@ycsd.york.va.us"
$SecurePassword = $password = Read-Host -AsSecureString
$cred = New-Object System.Management.Automation.PSCredential -ArgumentList $UserName, $SecurePassword
$Password = $Cred.GetNetworkCredential().Password 
$servers = get-content "\\ycsd.york.va.us\shares\apps\zabbix\servers.txt"
$Task = "Upgrade Zabbix"
$level = "Highest"

foreach ($server in $servers)
{

invoke-command -computer $server -ScriptBlock { 
    Register-ScheduledTask -Action $using:action -Trigger $using:trigger -TaskName $using:task -Description $using:task -User $using:UserName -Password $using:Password -RunLevel $using:level
    Start-ScheduledTask -TaskName "Upgrade Zabbix"
                                               }



}
