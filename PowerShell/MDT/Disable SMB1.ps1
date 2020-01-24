
## Check for Event log source, Create it if not found
$MDTLogs = Get-EventLog -LogName Application -Source "MDT Logs" -Newest 1 -ErrorAction SilentlyContinue

if ($MDTLogs -lt 1) {
    New-EventLog -LogName Application -Source "MDT Logs"
}

## Disable SMB1:
Write-Host "Disabling SMB1 Support..." -ForegroundColor Yellow
dism /online /Disable-Feature /FeatureName:SMB1Protocol /NoRestart
Write-Host ""
Write-Host ""
Write-EventLog -LogName Application -Source "MDT Logs" -EntryType Information -EventID 0100 -Message "SMB1 disabled"
## SMB Modifications for performance:
Write-Host "Changing SMB Parameters..."
Write-Host ""
New-ItemProperty -Path 'HKLM:\SYSTEM\CurrentControlSet\Services\LanmanWorkstation\Parameters' -Name 'DisableBandwidthThrottling' -PropertyType DWORD -Value '1' | Out-Null
New-ItemProperty -Path 'HKLM:\SYSTEM\CurrentControlSet\Services\LanmanWorkstation\Parameters' -Name 'DisableLargeMtu' -PropertyType DWORD -Value '0' | Out-Null
New-ItemProperty -Path 'HKLM:\SYSTEM\CurrentControlSet\Services\LanmanWorkstation\Parameters' -Name 'FileInfoCacheEntriesMax' -PropertyType DWORD -Value '8000' | Out-Null
New-ItemProperty -Path 'HKLM:\SYSTEM\CurrentControlSet\Services\LanmanWorkstation\Parameters' -Name 'DirectoryCacheEntriesMax' -PropertyType DWORD -Value '1000' | Out-Null
New-ItemProperty -Path 'HKLM:\SYSTEM\CurrentControlSet\Services\LanmanWorkstation\Parameters' -Name 'FileNotFoundcacheEntriesMax' -PropertyType DWORD -Value '1' | Out-Null
New-ItemProperty -Path 'HKLM:\SYSTEM\CurrentControlSet\Services\LanmanWorkstation\Parameters' -Name 'MaxCmds' -PropertyType DWORD -Value '8000' | Out-Null
New-ItemProperty -Path 'HKLM:\SYSTEM\CurrentControlSet\Services\Tcpip\Parameters' -Name 'EnableWsd' -PropertyType DWORD -Value '0' | Out-Null
Write-EventLog -LogName Application -Source "MDT Logs" -EntryType Information -EventID 501 -Message "DisableBandwidthThrottling set to 1"
Write-EventLog -LogName Application -Source "MDT Logs" -EntryType Information -EventID 501 -Message "DisableLargeMtu set to 0"
Write-EventLog -LogName Application -Source "MDT Logs" -EntryType Information -EventID 501 -Message "FileInfoCacheEntriesMax set to 8000"
Write-EventLog -LogName Application -Source "MDT Logs" -EntryType Information -EventID 501 -Message "DirectoryCacheEntriesMax set to 1000"
Write-EventLog -LogName Application -Source "MDT Logs" -EntryType Information -EventID 501 -Message "FileNotFoundcacheEntriesMax set to 1"
Write-EventLog -LogName Application -Source "MDT Logs" -EntryType Information -EventID 501 -Message "MaxCmds set to 8000"

Write-EventLog -LogName Application -Source "MDT Logs" -EntryType Information -EventId 0100 -Message "SMB Settings"