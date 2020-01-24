# Imports all MDT-deployed settings regarding Scheduled Tasks, Services, and Registry Settings from a CSV

# Default Errors to Stop Script
$ErrorActionPreference = "Stop"

#################
### LOG SETUP ###
#################

# Check For MDT Event Log
$MDTLogs = Get-EventLog -LogName Application -Source "MDT Logs" -Newest 1 -ErrorAction SilentlyContinue

if ($MDTLogs -eq $null) {
    
    # Create Log If Not Found
    New-EventLog -LogName Application -Source "MDT Logs"
}

##################
### CSV IMPORT ###
##################

$csv = Import-Csv -Path '\\Path\Image Logging\Checklist.csv'

$reg = @()
$svc = @()
$task = @()

foreach ($item in $csv) {

    switch ($item.Type) {
        "Reg" { $reg += $item; break }
        "Svc" { $svc += $item; break }
        "Task" { $task += $item; break}
        default { 
            Write-Host "$($item.Comments) has an unrecognized type of $($item.Type)"
            }
    }
}


#########################
### REGISTRY HANDLING ###
#########################

reg load HKLM\DEFAULT C:\Users\Default\NTUSER.DAT

foreach ($item in $reg) {
    
    try {

        $itemPath = $item.Path
        $itemPath = $itemPath.Replace("HKLM:\","HKLM\")
        $itemPath = $itemPath.Replace("HKCU:\","HKCU\")
        
        $value = $item.Value

        if ($value -eq "") { 

            Invoke-Expression "reg delete '$($itemPath)' /v '$($item.Name)' /f"
            Write-EventLog -LogName Application -Source "MDT Logs" -EntryType Information -EventId 0100 -Message "Deleted Reg key for $itemPath\$($item.Name)"

        }
        else {
            
            # Matching for no-value IPM keys
            if ($item.Name -match "IPM") {
                Invoke-Expression "reg add '$($itemPath)' /v '$($item.Name)' /t REG_$($item.KeyType) /f"
            }
            # All other registry keys
            else {
                Invoke-Expression "reg add '$($itemPath)' /v '$($item.Name)' /t REG_$($item.KeyType) /d '$($item.Value)' /f"
            }
            Write-EventLog -LogName Application -Source "MDT Logs" -EntryType Information -EventId 0100 -Message "Reg added/modified for $itemPath\$($item.Name)"
        }
    }
    catch {
        Write-EventLog -LogName Application -Source "MDT Logs" -EntryType Error -EventId 0100 -Message "Error occured modifying registry for $itemPath\$($item.Name)"
    }

    
}

reg unload HKLM\DEFAULT


#########################
### SERVICES HANDLING ###
#########################

foreach ($item in $svc) {

    try {
        Set-Service $item.Path -StartupType Disabled
        Stop-Service $item.Path -Force
        Write-EventLog -LogName Application -Source "MDT Logs" -EntryType Information -EventId 0100 -Message "Disabled service $($item.Path)"
    }
    catch {
        Write-EventLog -LogName Application -Source "MDT Logs" -EntryType Error -EventId 0100 -Message "Error occured disabling service $($item.Path)"
    }   
}


###############################
### SCHEDULED TASK HANDLING ###
###############################

foreach ($item in $task) {

    try {
        Get-ScheduledTask $item.Path | Disable-ScheduledTask
        Write-EventLog -LogName Application -Source "MDT Logs" -EntryType Information -EventId 0100 -Message "Disabled task $($item.Path)"
    }
    catch {
        Write-EventLog -LogName Application -Source "MDT Logs" -EntryType Error -EventId 0100 -Message "Error occured disabling task $($item.Path)"
    }   
}