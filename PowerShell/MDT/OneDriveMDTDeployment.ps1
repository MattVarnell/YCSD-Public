# Install OneDrive through MDT
#  Preliminary variable needs to be updated for the product version
#  MDT Deployment will handle path and root folder

Write-Verbose "Setting Arguments" -Verbose
$StartDTM = (Get-Date)
 
$Vendor = "Microsoft"
$Product = "OneDrive"
$PackageName = "OneDriveSetup"
$InstallerType = "exe"
$Version = "19.222.1110.6"
$LogPS = "c:\temp\$Vendor $Product $Version PS Wrapper.log"
$UnattendedArgs = '/allusers /S /v/qn'
Start-Transcript $LogPS
write-host "Started transcript"
 
Function Block-oneclient.sfx.ms {

    $hosts = 'C:\Windows\System32\drivers\etc\hosts'

    $is_blocked = Get-Content -Path $hosts |
    Select-String -Pattern ([regex]::Escape("oneclient.sfx.ms"))

    If(-not $is_blocked) {
       Add-Content -Path $hosts -Value "127.0.0.1 oneclient.sfx.ms"
    }

}
 
Function Block-g.live.com {

    $hosts = 'C:\Windows\System32\drivers\etc\hosts'

    $is_blocked = Get-Content -Path $hosts |
    Select-String -Pattern ([regex]::Escape("g.live.com"))

    If(-not $is_blocked) {
       Add-Content -Path $hosts -Value "127.0.0.1 g.live.com"
    }

}
Block-g.live.com
Block-oneclient.sfx.ms
Write-Host "Finished block section"
Set-Location $Version
 
Write-Verbose "Starting Installation of $Vendor $Product $Version" -Verbose
(Start-Process "$PackageName.$InstallerType" $UnattendedArgs -Wait -Passthru).ExitCode
 
Write-Verbose "Customization" -Verbose

## Disable AutoUpdate Service
Stop-Service -Name "OneDrive Updater Service"
Set-Service -Name "OneDrive Updater Service" -StartupType Disabled
Write-Host "Disabled Updater Service"


Get-ScheduledTask -TaskName "OneDrive Per-Machine Standalone Update Task" | Disable-ScheduledTask
Write-Host "Disabled Scheduled Task"
##
## Create Registry Configuration
##

$CreateRegistry =
@("Files On Demand Enabled DWORD - Enable Files on Demand.", "'HKLM\SOFTWARE\Policies\Microsoft\OneDrive' /v FilesOnDemandEnabled /t REG_DWORD /d 0x1 /f"),
("GPO Set Update Ring DWORD - Set Update Ring.", "'HKLM\SOFTWARE\Policies\Microsoft\OneDrive' /v GPOSetUpdateRing /t REG_DWORD /d 0x0 /f"),
("KFM Silent OptIn DWORD - Set VHDX Dynamic mode", "'HKLM\SOFTWARE\Policies\Microsoft\OneDrive' /v KFMSilentOptIn /t REG_SZ /d 1de098ab-3c87-44c6-afb7-f70c62c23c1c /f"),
("KFM Silent Opt In With Notification DWORD - Disable KFM Silent Opt In With Notification", "'HKLM\SOFTWARE\Policies\Microsoft\OneDrive' /v KFMSilentOptInWithNotification /t REG_DWORD /d 0x0 /f"),
("Silent Account Config DWORD - Enable Silent Account Config", "'HKLM\SOFTWARE\Policies\Microsoft\OneDrive' /v SilentAccountConfig /t REG_DWORD /d 0x1 /f")

#Creating Registry Objects
foreach ($CreateRegistryObject in $CreateRegistry) {
    Write-Host Creating registry object $CreateRegistryObject[0] -ForegroundColor Cyan
    $item = Invoke-Expression ("reg add " + $CreateRegistryObject[1])
    Write-EventLog -LogName Application -Source "MDT Logs" -EntryType Information -EventId 0101 -Message "$item $CreateRegistryObject[0]" | Out-String
    Write-Host "Created Registry Object"
}

Write-Host "Finished Creating Registry"

Write-Verbose "Stop logging" -Verbose
$EndDTM = (Get-Date)
Write-Verbose "Elapsed Time: $(($EndDTM-$StartDTM).TotalSeconds) Seconds" -Verbose
Write-Verbose "Elapsed Time: $(($EndDTM-$StartDTM).TotalMinutes) Minutes" -Verbose
Stop-Transcript