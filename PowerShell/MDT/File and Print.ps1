#################
### LOG SETUP ###
#################

# Check For MDT Event Log
$MDTLogs = Get-EventLog -LogName Application -Source "MDT Logs" -Newest 1 -ErrorAction SilentlyContinue

if ($MDTLogs -eq $null) {
    
    # Create Log If Not Found
    New-EventLog -LogName Application -Source "MDT Logs"
}

## Set Firewall to allow File and Print from Trusted IP ranges

$name = Get-NetFirewallrule -DisplayName "File and Printer*" | Where-Object {$_.Profile -eq "Domain"}

$ips = @("IP Firewall Range Placeholders)

foreach($r in $name)
{
    $r | Set-NetFirewallRule -RemoteAddress $ips
}
Enable-NetFirewallRule -DisplayName "File and Printer*"

Write-EventLog -LogName Application -Source "MDT Logs" -EntryType Information -EventId 0100 -Message "File and Print Firewall Rules"
