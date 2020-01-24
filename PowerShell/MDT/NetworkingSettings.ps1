#################
### LOG SETUP ###
#################

# Check For MDT Event Log
$MDTLogs = Get-EventLog -LogName Application -Source "MDT Logs" -Newest 1 -ErrorAction SilentlyContinue

if ($MDTLogs -eq $null) {
    
    # Create Log If Not Found
    New-EventLog -LogName Application -Source "MDT Logs"
}

########################################
### NETWORKING SETTINGS MODIFICATION ###
########################################

# Create Temp Directory
New-Item -ItemType Directory -Path C:\Temp
Write-EventLog -LogName Application -Source "MDT Logs" -EntryType Information -EventId 0100 -Message "Created C:\Temp"

# Copy RunOnce Script To C:\Temp For Reboot Task
Copy-Item -Path "\\Path\MDT\Applications\YCSD Set File and Print Firewall Settings\Configuration Scripts\RunOnceNetworkSettings.ps1" "c:\Temp\RunOnceNetworkSettings.ps1"
Write-EventLog -LogName Application -Source "MDT Logs" -EntryType Information -EventId 0100 -Message "Copied RunOnce Script to C:\Temp"

# Disable SMB1 Support
dism /online /Disable-Feature /FeatureName:SMB1Protocol /NoRestart
Write-EventLog -LogName Application -Source "MDT Logs" -EntryType Information -EventId 0100 -Message "Disabled SMB1 Support"


########################################
### FILE AND PRINT FIREWALL SETTINGS ###
########################################

# Get list of domain firewall rules
$rules = Get-NetFirewallrule -DisplayName "File and Printer*" | Where-Object { $_.Profile -eq "Domain" }

# IPs to assign to rules list
$ips = @("Firewall IP Range PlaceholdeR")

foreach ($rule in $rules){
    $rule | Set-NetFirewallRule -RemoteAddress $ips
}

# Enable all file and printer rules
Enable-NetFirewallRule -DisplayName "File and Printer*"

Write-EventLog -LogName Application -Source "MDT Logs" -EntryType Information -EventId 0100 -Message "Set File and Print Firewall Rules"

###################################
### DISABLE NETBIOS OVER TCP/IP ###
###################################

# Get list of enabled NICs
$nics = gwmi win32_networkadapterconfiguration | where { $_.ipenabled -eq "1" }

# Disable Netbios for each NIC
foreach ($nic in $nics) {
    $nic.settcpipnetbios(2)
    Write-EventLog -LogName Application -Source "MDT Logs" -EntryType Information -EventId 0100 -Message "Disabled NetBIOS on adapter $($nic.Description)"
}

##################
### ENABLE RDP ###
##################

# Enable RDP Variables
$RDPEnable = 1
$RDPFirewallOpen = 1

# Extract RDP Object for modifications
$RDP = Get-WmiObject -Class Win32_TerminalServiceSetting -Namespace root\CIMV2\TerminalServices -Authentication PacketPrivacy

# Enable RDP and open the firewall to allow connections
$RDP.SetAllowTSConnections($RDPEnable,$RDPFirewallOpen)

Write-EventLog -LogName Application -Source "MDT Logs" -EntryType Information -EventId 0100 -Message "Enabled RDP"