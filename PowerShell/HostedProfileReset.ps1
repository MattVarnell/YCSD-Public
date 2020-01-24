#===========================================================================
# Script Variables
#===========================================================================

#Paths to hosted profiles
$xa12path = "\\Path\Profiles\XA\XA2012"
$xa16path = "\\Path\Profiles\XA\XA2016"
$xafinpath = "\\Path\Profiles\XAProfiles"

#Define the list of DDCs
$DDCServer1 = #DDCServer1
$DDCServer2 = #DDCServer2

#===========================================================================
# Script Functions
#===========================================================================

#Determine which DDC to use for script session
Function TestDDC($DDCServer1, $DDCServer2){

    if (Test-Connection $DDCServer1 -Count 1 -Quiet) {
        Write-Host "$DDCServer1 will be used"
        $ServerToUse = $DDCServer1
    }
    elseif (Test-Connection $DDCServer2 -Count 1 -Quiet) {
        Write-Ouput "$DDCServer2 will be used"
        $ServerToUse = $DDCServer2
    }
    else {
        Write-Host "No DDC server available"
        $ServerToUse = $null
    }

    return $ServerToUse
}

#Creates a GUI with menu options to guide the profile reset process
Function Reset-ProfileMenu {

    #Clear screen and present the options menu
    cls
    Write-Host "==========Reset Hosted App User Profiles========"
    Write-Host "Press '1' to reset Hosted Application Profiles"
    Write-Host "Press '2' to reset AutoCAD 2019 Profiles"
    Write-Host "Press '3' to reset Munis Profiles"
    Write-Host "Press 'H' for Help"
    Write-Host "Press 'Q' to Quit"
    Write-Host "================================================"

    #Prompt the user for input and continue until a valid option is entered
    Do { 
    
        $MenuInput = Read-Host "Please make a selection"
  
        #Switch statement to handle setting variables and running functions depending on selection
        switch ($MenuInput) {
            
            #Reset Hosted App Profiles
            '1' {

                $dGroupName = "2012"
                $XA12Servers = Invoke-Command -Session $PSSession -ScriptBlock { Add-PSSnapin Citrix*; Get-BrokerMachine -MaxRecordCount 100000 | Where-Object { $_.DesktopGroupName -match "2012" -and $_.HostedMachineName -notmatch "Testing" -and $_.HostedMachineName -notmatch "#SITE" } | Select-Object -ExpandProperty HostedMachineName }
                $servers = $xa12servers
                $path = $xa12path
                    
                cls
                'You selected: Reset Hosted Application Profiles'

                #Prompt for a username to target for profile reset
                do {
                    $user = Read-Host "Please enter a username" 
                } 
                until ($user -ne "")

                #Profile reset function calls
                End-Sessions -servers $xa12servers -username $user
                Start-Sleep -s 2 #Sleep to allow logoff time
                Reset-NetProfile -servers $xa12Servers -path $xa12path -username "$user"
            }
            #Reset Autocad 2019 Profiles
            '2' {

                $dGroupName = "2016"
                $XA16Servers = Invoke-Command -Session $PSSession -ScriptBlock { Add-PSSnapin Citrix*; Get-BrokerMachine -MaxRecordCount 100000 | Where-Object { $_.DesktopGroupName -match "2016" -and $_.HostedMachineName -notmatch "Testing" -and $_.HostedMachineName -notmatch "#SITE" } | Select-Object -ExpandProperty HostedMachineName }
                $servers = $xa16servers
                $path = $xa16path

                cls
                'You selected: Reset AutoCAD 2019 Profiles'

                #Prompt for a username to target for profile reset
                do {
                    $user = Read-Host "Please enter a username"
                }
                until ($user -ne "")

                #Profile reset function calls
                End-Sessions -servers $xa16servers -username $user
                Start-Sleep -s 2 #Sleep to allow logoff time
                Reset-NetProfile -servers $xa16Servers -path $xa16path -username "$user"
            }
            #Reset Munis Profile
            '3' {

                $dGroupName = "2008"
                $XAFinServers = Invoke-Command -Session $PSSession -ScriptBlock { Add-PSSnapin Citrix*; Get-BrokerMachine -MaxRecordCount 100000 | Where-Object { $_.DesktopGroupName -match "2008" -and $_.HostedMachineName -notmatch "Testing" -and $_.HostedMachineName -notmatch "#SITE" -and $_.HostedMachineName -match "XAFIN" } | Select-Object -ExpandProperty HostedMachineName }
                $servers = $xafinservers
                $path = $xafinpath

                cls
                'You selected: Reset Munis Profiles'

                #Prompt for a username to target for profile reset
                do {
                    $user = Read-Host "Please enter a username"
                }
                until ($user -ne "")

                #Profile reset function calls
                End-Sessions -servers $servers -username $user
                Start-Sleep -s 2 #Sleep to allow logoff time
                Reset-NetXAFINProfile -servers $xafinservers -path $xafinpath -username "$user"
            }
            #Help Menu
            'h' {

                cls

                #Describe applications affected by each profile type
                Write-Host "'Hosted Applications' includes apps such as: Photoshop, Niagara, Dreamweaver, Google Sketchup"
                Write-Host "'AutoCAD 2019 Profiles' includes apps such as: Inventor, AutoCAD, Dameware"
                Write-Host "'Munis Profiles' only include Munis or AS/400"
                Write-Host "================================================"

                #Exit the help menu and return to the original selection screen
                Read-Host "Press Enter to exit Help" | Out-Null
                cls
                Reset-ProfileMenu
            }
            #Quit Script
            'q' { return }
            Default {
                Write-Host "Invalid Entry. Please select a valid entry" -ForegroundColor "Red"
            }
        }
    }
    Until($MenuInput -eq '1' -or $MenuInput -eq '2' -or $MenuInput -eq '3' -or $MenuInput -eq 'h' -or $MenuInput -eq 'q')
}

#Delete network profile
Function Reset-NetProfile {

    param(  [Parameter(Mandatory=$true)]
            [string[]]$servers,
            [string]$path,
            [string]$username)

    #Delete the *.old version of the profile if it exists
    if (Test-Path $path\$user.old) {
        Remove-Item $path\$user.old -Recurse -Force
        }

    #Rename current user profile to *.old
    if (Test-Path $path\$user) {

            #Deletes all local profiles of the user from servers in the worker group
            Write-Host "Waiting 15 seconds to unlock '$user' profile before attemping removal" -ForegroundColor Cyan
            Start-Sleep -s 15
            Remove-LocalProfile -servers $servers -username $user

            #Rename the network profile path to *.old
            Write-Host "Renaming Network Profile: $path\$user to $user.old" -ForegroundColor Cyan
            Start-Sleep -s 15
            Rename-Item $path\$user "$user.old"
            Start-Sleep -s 5
            Write-Host "Deleting $path\$user.old" -ForegroundColor Cyan
            Remove-Item $path\$user.old -Recurse -Force
      
    }
    else {
        Write-Host "User profile: $user not found on $path." -ForegroundColor "DarkYellow"
    }
}

#Delete network v2 profile
Function Reset-NetXAFINProfile {

    param(  [Parameter(Mandatory=$true)]
            [string[]]$servers,
            [string]$path,
            [string]$username)

    #Delete the *.old version of the profile if it exists
    if(Test-Path $path\v2-$user.old) {
        Remove-Item $path\v2-$user.old -Recurse -Force
        }

    #Rename current user profile to *.old
    if(Test-Path $path\v2-$user) {

            # Deletes all local profiles of the user from servers in the worker group
            Write-Host "Waiting 15 seconds to unlock '$user' profile before attemping removal" -ForegroundColor Cyan
            Start-Sleep -s 15
            Remove-LocalProfile -servers $servers -username $user

            #Rename the network profile path to *.old
            Write-Host "Renaming Network Profile: $path\v2-$user to $user.old" -ForegroundColor Cyan
            Start-Sleep -s 15
            Rename-Item $path\v2-$user "v2-$user.old"
            Start-Sleep -s 5
            Write-Host "Deleting $path\v2-$user.old" -ForegroundColor Cyan
            Remove-Item $path\v2-$user.old -Recurse -Force
      
    }
    else {
        Write-Host "User profile: v2-$user not found on $path." -ForegroundColor "DarkYellow"
    }
}

#Deletes local profiles from the servers in the worker group
Function Remove-LocalProfile {

    param(  [Parameter(Mandatory=$true)]
            [string[]]$servers,
            [string]$username)
    
    #Cycle through each server in the worker group to check for local profiles
    foreach($server in $servers) {
    
        #Verify that the server is reachable
        if(Test-Connection -ComputerName $server -Count 1 -ea 0) {        
            
            Write-Information "Working on $server"
        
            #Boolean to check if profile is found on the server
            $profilefound = $false        
        
            #Get a list of all profiles on the server
            $profile = Get-WmiObject -Class Win32_UserProfile -Filter "localpath='c:\\users\\$user'" -Computer $server -ea 0
            

            #Search list of server local profiles to find target profile for deletion
            foreach ($p in $profile) {
                                            
                #Converts a SID into a username
                $objSID = New-Object System.Security.Principal.SecurityIdentifier($p.sid)   #Extracts SID from local profile           
                $objUser = $objSID.Translate([System.Security.Principal.NTAccount])         #Translate SID into Domain\User
                $profilename = $objUser.value.split("\")[1]                                 #Splits string into Domain and User, assigns User value
                
                #If the extracted username matches the target, delete profile
                if($profilename -eq $user) {
                                        
                    #Mark the profile as found to avoid the "No profiles" warning          
                    $profilefound = $true
                                
                    try {
                        Start-Sleep -s 5            
                        $profile.delete()            
                        Write-Host "Deleted profile '$user' successfully on $server" -ForegroundColor Cyan
                    } 
                    catch {            
                        Write-Host "Failed to delete the '$user' profile on $server" -ForegroundColor Red
                    }            
                }            
            }            
            
            #If no profile was found on the server, write to console
            if(!$profilefound) {            
                Write-Host "'$user' profile was not found on $server" -ForegroundColor DarkYellow
            }            
        }
        else {            
            write-verbose "Failed to connect to '$server'"            
        }            
    }
}

#Find and end hosted app sessions
Function End-Sessions {

    Param(  [Parameter(Mandatory=$true)]
            [string[]]$servers,
            [string]$username)

    #Boolean to check if a session to log off was found
    $sessionfound = $false

    #Pulls list of hosted sessions to end
    $session = Invoke-Command -Session $PSSession -ScriptBlock { param ($user, $dGroupName); Add-PSSnapin Citrix*; Get-BrokerSession -MaxRecordCount 100000 | Where-Object { $_.UserName -eq "#Domain1\$user" -or $_.UserName -eq "#Domain2\$user" -and $_.SessionType -eq "Application" -and $_.DesktopGroupName -match $dGroupName } } -ArgumentList $user, $dGroupName
    $endSession = Invoke-Command -Session $PSSession -ScriptBlock { param ($user, $dGroupName); Add-PSSnapin Citrix*; Get-BrokerSession -MaxRecordCount 100000 | Where-Object { $_.UserName -eq "#Domain1\$user" -or $_.UserName -eq "#Domain2\$user" -and $_.SessionType -eq "Application" -and $_.DesktopGroupName -match $dGroupName } | Stop-BrokerSession } -ArgumentList $user, $dGroupName
    $endXAFINSession = Invoke-Command -Session $PSSession -ScriptBlock { param ($user, $dGroupName); Add-PSSnapin Citrix*; Get-BrokerSession -MaxRecordCount 100000 | Where-Object { $_.UserName -eq "#Domain1\$user" -or $_.UserName -eq "#Domain2\$user" -and $_.SessionType -eq "Application" -and $_.DesktopGroupName -match $dGroupName -and $_.HostedMachineName -match "#FinServer" } | Stop-BrokerSession } -ArgumentList $user, $dGroupName
    
    #Verify correlated server worker group against worker group to perform reset on
    foreach($s in $session) {

        #Extract session values
        $servname = $s.HostedMachineName
        $app      = $s.ApplicationsinUse

        #If the application session's server is in the target worker group, log user off the app
        if($servers -match "#FinServer") {
            Write-Host "Closing active session(s) on $servname for '$user'" -ForegroundColor Cyan
            $endXAFINSession
        } 
        elseif($servers -contains $_.HostedMachineName) {
            Write-Host "Closing active session(s) on $servname for '$user'" -ForegroundColor Cyan
            $endSession
        }
    }
}

#===========================================================================
# Script Main Body
#===========================================================================

#Determine which server to use for DDC functions
$DDCServer = TestDDC $DDCServer1 $DDCServer2

# Create a single PowerShell session to the Remote DDC
$PSSession = New-PSSession -ComputerName $DDCServer

#Start Menu System
Reset-ProfileMenu

#Close Remote PowerShell Session
Remove-PSSession $PSSession