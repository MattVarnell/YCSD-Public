#################
### LOG SETUP ###
#################

# Check For MDT Event Log
$MDTLogs = Get-EventLog -LogName Application -Source "MDT Logs" -Newest 1 -ErrorAction SilentlyContinue

if ($MDTLogs -eq $null) {
    
    # Create Log If Not Found
    New-EventLog -LogName Application -Source "MDT Logs"
}


# Enable RDP:
$RDPEnable = 1
$RDPFirewallOpen = 1
$RDP = Get-WmiObject -Class Win32_TerminalServiceSetting -Namespace root\CIMV2\TerminalServices -Authentication PacketPrivacy
$Result = $RDP.SetAllowTSConnections($RDPEnable,$RDPFirewallOpen)
if ($Result.ReturnValue -eq 0){
   Write-Host "Remote Connection settings changed sucessfully" -ForegroundColor Cyan
   Write-EventLog -LogName Application -Source "MDT Logs" -EntryType Information -EventId 0100 -Message "RDP Enabled"

} else {
   Write-Host ("Failed to change Remote Connections setting(s), return code "+$Result.ReturnValue) -ForegroundColor Red
   Write-EventLog -LogName Application -Source "MDT Logs" -EntryType Information -EventId 0100 -Message "Failed to enable RDP"

   exit
}