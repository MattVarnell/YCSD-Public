get-service wuauserv | Set-Service -StartupType Disabled
get-service wuauserv | Stop-Service