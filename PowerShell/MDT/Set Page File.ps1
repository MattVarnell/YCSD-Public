## Check for Event log source, Create it if not found
$MDTLogs = Get-EventLog -LogName Application -Source "MDT Logs" -Newest 1 -ErrorAction SilentlyContinue

if ($MDTLogs -lt 1) {
    New-EventLog -LogName Application -Source "MDT Logs"
}

## Set Page File size
Set-CimInstance -Query "SELECT * FROM Win32_ComputerSystem" -Property @{AutomaticManagedPagefile = "False"}
Set-CimInstance -Query "SELECT * FROM Win32_PageFileSetting" -Property @{InitialSize = 8192; MaximumSize = 8192}

Write-EventLog -LogName Application -Source "MDT Logs" -EntryType Information -EventId 0100 -Message "Set Page File Size"