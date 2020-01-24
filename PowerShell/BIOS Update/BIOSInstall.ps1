<#
.SYNOPSIS
  Updates BIOS, HD formatting, and boot methods to UEFI

.DESCRIPTION
  Used for initial configuration of computer models to meet current YCSD standards
  Pulls computer data to dynamically determine proper BIOS version/settings, formats HD if needed
  Assigns proper production vDisk through PVS after configuration is completed
  
  *Script should be stored in TBD
  *For log results, there should be a folder TBD

.OUTPUTS
  Log file of events occuring during configuration on a per-machine basis

  Location: TBD

.NOTES
  Version:        1.3
  Author:         Matt Varnell and CJ Hafner
  Creation Date:  7/19/2018
  Last Modification: 7/29/2018
  Purpose/Change: Update Logging/Making Script Dynamic
  Last Modification: 7/30/2018
  Purpose/Change: Change Computer name index to correct for misnamed test computer. Change Bios install to use Start-Process
  Last Modification: 8/9/2018
  Purpose/Change: Change handing of hostname and BIOS versions. Bug fixes

#>

#===========================================================================
# Set Variables
#===========================================================================
$UpdateHost = $(hostname).ToUpper()
#Script home directory
$ScriptHome = "\\Path\biosConfig"

#Location of logs
$LogDir = "\\Path\svcpcupdate\biosupdate"

#Log name
$Log = "\\Path\svcpcupdate\biosupdate\$updatehost.txt"

#Determine machine hostname and use it to determine PVS Site and Store

$PVSSite =  if (($UpdateHost -match "#SubSite1") -or ($UpdateHost -match "#SubSite1") -or ($UpdateHost -match "#SubSite1") -or ($UpdateHost -match "#SubSite1") -or ($UpdateHost -match "#SubSite1")) { "#BaseSite1" }
            elseif (($UpdateHost -match "#SubSite2") -or ($UpdateHost -match "#SubSite2")) { "#BaseSite2" }
            elseif (($UpdateHost -match "#SubSite3") -or ($UpdateHost -match "#SubSite3")) { "#BaseSite3" }
            elseif ($UpdateHost -match "#SubSite4") { "#BaseSite4" }
            else { $UpdateHost.Substring(0,3) }
$PVSStore = "$PVSSite-PVS"
$PVSServer = "$PVSStore-01"

#Get BIOS version for comparison to target
$BiosVersion = $(Get-CimInstance -ClassName win32_bios | ft -HideTableHeaders SMBIOSBIOSVersion | Out-String).Trim()

#Setting strings for BIOS configuration
$Settings = "Intel(R) Virtualization Technology,Enabled","C State Support,C1","After Power Loss,Power Off","Wake on LAN,Primary","Boot Mode,UEFI","CSM,Disabled"

#===========================================================================
# Logging Functions
#===========================================================================

#Function to write to the log file
Function Write-Log {

    Param ([String]$LogString)

    Add-Content $Log -Value $LogString
}

#Begin log with basic user/computer information and start time
Write-Log "Beginning BIOS Update Script logging for $env:COMPUTERNAME"
Write-Log "User: $env:USERDOMAIN\$env:USERNAME"
$StartTime = Get-Date
Write-Log "Start Time: $StartTime"

#===========================================================================
# Determine Target BIOS, PVS Disk, and BIOS update file location
#===========================================================================

#Extract last section of device name after dash (7040, M93, etc)
$ComputerModel = $UpdateHost.Split("-")[-1]

#Import CSV of models and their corresponding BIOS and vDisk versions
$Specs = Import-Csv '\\Path\ModelSpecs.csv'

#Check if the computer is a supported model for the script
if ($Specs.Model -contains $ComputerModel){

    #Find the index and determine model specs
    $Index = $Specs.Model.IndexOf($ComputerModel)
    $BiosTarget = $Specs.BiosTarget[$Index]
    $PVSVDisk = $PVSSite + "-" + ($Specs.PVSVDisk[$Index])
    $BiosUpdateExe = $Specs.BiosUpdateExe[$Index]
}
else {
    Write-Log "Current computer model $ComputerModel is not supported, ending script"
    Throw "Model not supported"
}

Write-Log "Current BIOS version is: $BiosVersion"
Write-Log "Target BIOS version is: $BiosTarget"

#===========================================================================
# Main Script Body
#===========================================================================

#Format any raw disk partitions for NTFS and assign drive D: and Cache label
Get-Disk | Where partitionstyle -eq 'raw' | Initialize-Disk -PartitionStyle MBR -PassThru | New-Partition -DriveLetter D -UseMaximumSize | Format-Volume -FileSystem NTFS -NewFileSystemLabel "Cache" -Confirm:$false

#Check To see if Bios is current
if ($ComputerModel -eq "M93") { $isBiosCurrent = $true }
else {
    $isBiosCurrent = $BiosTarget -eq $BiosVersion
}

#If BIOS is current, configure with current YCSD standard settings
if ($isBiosCurrent) {

    Write-Log "BIOS is up to date"
    Write-Log "Proceeding with BIOS configuration"
    
    #Call BIOS configuration script
    #If computer is the M93 model...
    if ($ComputerModel -eq "M93") {

        #Check for a success value return on all possible BIOS settings and use corresponding encryption file
        if ((gwmi -Class Lenovo_SaveBiosSettings -Namespace root\wmi).SaveBiosSettings("#Password,ascii,us").return -eq "Success"){
            
            #Set correct password based on SaveBiosSettings result
            $password = "#Password"
            #Change each BIOS setting one at a time
            foreach ($Setting in $Settings) {
                (gwmi -Class Lenovo_SetBiosSetting -Namespace root\wmi).SetBiosSetting($Setting)
            }
            #Save BIOS settings
            (gwmi -Class Lenovo_SaveBiosSettings -Namespace root\wmi).SaveBiosSettings("$password,ascii,us")

        }
        elseif ((gwmi -Class Lenovo_SaveBiosSettings -Namespace root\wmi).SaveBiosSettings("#Password,ascii,us").return -eq "Success"){
            
            #Set correct password based on SaveBiosSettings result
            $password = "#Password"
            #Change each BIOS setting one at a time
            foreach ($Setting in $Settings) {
                (gwmi -Class Lenovo_SetBiosSetting -Namespace root\wmi).SetBiosSetting($Setting)
            }
            #Save BIOS settings
            (gwmi -Class Lenovo_SaveBiosSettings -Namespace root\wmi).SaveBiosSettings("$password,ascii,us")

        }
        else {
            Write-Log "BIOS password doesn't match any current known passwords"
        }
    }
    #... Otherwise run the Dell version of the BIOS configuration
    else {
        powershell.exe -executionpolicy bypass $scripthome\BIOSConfig.ps1
    }

    Write-Log "UEFI Conversion done"
    Write-Log "Configuring UEFI boot disk"
    
    #Run commands on corresponding PVS server to update with correct vDisk
    Write-Log "Connecting to $PVSServer"
    Invoke-command -ComputerName $PVSServer -ArgumentList $UpdateHost,$PVSSite,$PVSStore,$PVSVDisk {

        Function Write-Log{
            [cmdletbinding()]
            Param(
                [Parameter(ValueFromPipeline=$true,Mandatory=$true)] [ValidateNotNullOrEmpty()]
                [string] $Message    
            )

            $Message     
        }

        Import-Module "C:\Program Files\Citrix\Provisioning Services Console\Citrix.PVS.SnapIn.dll"

        Get-PvsDeviceinfo -DeviceName $args[0] | ft DiskLocatorName -HideTableHeaders
        
        Write-Log "$args[0] Current device"

        $DiskID = Get-PvsDiskLocator -DiskLocatorName $args[3] -Sitename $args[1] -StoreName $args[2] |ft -HideTableHeaders DiskLocatorId | Out-String

        Add-PvsDiskLocatorToDevice -DiskLocatorId $DiskID -DeviceName $args[0] -RemoveExisting

        Write-Log "$DiskID UEFI image is assigned"

	} | Out-File -Append $Log -Encoding ASCII 

    Write-Log "Rebooting $env:COMPUTERNAME"

    #Reboot machine onto new image
    Restart-Computer -ComputerName $UpdateHost

}
#If BIOS isn't current, update BIOS
else {

    Write-Log "BIOS requires an update. Proceeding with BIOS upgrade"

    cd \\Path\netlogon\biosconfig\$ComputerModel
    Start-Process .\$BiosUpdateExe "/p=#Password /s /r /l=>>$LogDir\$UpdateHost-bios.txt"

}

$EndTime = Get-Date
$ElapsedTime = $($EndTime - $StartTime).ToString("hh\:mm\:ss")
Write-Log "End Time: $EndTime"
Write-Log "Time Elapsed: $ElapsedTime"