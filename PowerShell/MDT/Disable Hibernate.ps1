## Check for Event log source, Create it if not found
$MDTLogs = Get-EventLog -LogName Application -Source "MDT Logs" -Newest 1 -ErrorAction SilentlyContinue

if ($MDTLogs -lt 1) {
New-EventLog -LogName Application -Source "MDT Logs"}

#Disabling hibernate.
 powercfg -h off
 Write-EventLog -LogName Application -Source "MDT Logs" -EntryType Information -EventId 0100 -Message "Disable Hibernate"