#################
### LOG SETUP ###
#################

# Check For MDT Event Log
$MDTLogs = Get-EventLog -LogName Application -Source "MDT Logs" -Newest 1 -ErrorAction SilentlyContinue

if ($MDTLogs -eq $null) {
    
    # Create Log If Not Found
    New-EventLog -LogName Application -Source "MDT Logs"
}

## Install Drivers

$Drivers = get-childitem "\\Path\mdt\Out-of-Box Drivers\Printer\" -Recurse -Filter *.inf

foreach ($Driver in $Drivers)
{
    $DriverFullPath = $Driver.DirectoryName + "\" + $Driver.Name
    Copy-Item -Path $Driver.DirectoryName -Destination C:\windows\INF -Recurse
    pnputil.exe -i -a $DriverFullPath
    Write-EventLog -LogName Application -Source "MDT Logs" -EntryType Information -EventId 0600 -Message $Driver.name
}