c:
cd \
cd zabbix

zabbix_agentd.exe --config c:\zabbix\zabbix.conf --install

sc start "zabbix agent"
Powershell.exe New-NetFirewallRule -Name zabbix -DisplayName zabbix -Enabled true -Direction In -Action Allow -Program "C:\zabbix\zabbix_agentd.exe"

pause