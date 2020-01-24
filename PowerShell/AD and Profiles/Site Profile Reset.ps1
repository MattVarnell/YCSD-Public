$profShare1 = #DataCenterShare1
$profShare2 = #DataCenterShare2

$noProfileList = @()
$cannotRenameProfileList = @()

#Build array from any number of OUs depending on reset schedule
$accounts = ((Get-ADUser -Filter * -SearchBase "#OU1" | Where-Object {$_.Enabled -eq $true} | select SamAccountName).SamAccountName)
$accounts += ((Get-ADUser -Filter * -SearchBase "#OU2" | Where-Object {$_.Enabled -eq $true} | select SamAccountName).SamAccountName)




foreach ($account in $accounts) {

    if(Test-Path "$profShare1\$account") {
        $profilePath = "$profShare1\$account"
        Write-Host "Profile Found"
        try {
            Rename-Item $profilePath "$profilePath.old" -ErrorAction Stop
        }
        catch [System.IO.IOException] {
            Write-Host "Profile [$account] is still in use, verify user is logged off in all locations" -ForegroundColor Red
            $cannotRenameProfileList += $account
        }
        catch {
            Write-Host "Cannot rename [$account]" -ForegroundColor Red
            $cannotRenameProfileList += $account
        }
    }
    elseif(Test-Path "$profShare2\$account") {
        $profilePath = "$profShare2\$account"
        Write-Host "Profile Found"
                try {
            Rename-Item $profilePath "$profilePath.old" -ErrorAction Stop
        }
        catch [System.IO.IOException] {
            Write-Host "Profile [$account] is still in use, verify user is logged off in all locations" -ForegroundColor Red
            $cannotRenameProfileList += $account
        }
        catch {
            Write-Host "Cannot rename [$account]" -ForegroundColor Red
            $cannotRenameProfileList += $account
        }
    }
    else {
        Write-Host "No profile found for [$account]" -ForegroundColor Red
        $noProfileList += $account
    }
}

# Run this section to cycle through and reset profiles that were in use during the first iteration and unable to be renamed
# Can be run multiple times until process is complete

<#

$stillNotRenamed = @()

foreach ($account in $cannotRenameProfileList) {

    if(Test-Path "$profShare1\$account") {
        $profilePath = "$profShare1\$account"
        Write-Host "Profile Found"
        try {
            Rename-Item $profilePath "$profilePath.old" -ErrorAction Stop
        }
        catch [System.IO.IOException] {
            Write-Host "Profile [$account] is still in use, verify user is logged off in all locations" -ForegroundColor Red
            $stillNotRenamed += $account
        }
        catch {
            Write-Host "Cannot rename [$account]" -ForegroundColor Red
            $stillNotRenamed += $account
        }
    }
    elseif(Test-Path "$profShare2\$account") {
        $profilePath = "$profShare2\$account"
        Write-Host "Profile Found"
                try {
            Rename-Item $profilePath "$profilePath.old" -ErrorAction Stop
        }
        catch [System.IO.IOException] {
            Write-Host "Profile [$account] is still in use, verify user is logged off in all locations" -ForegroundColor Red
            $stillNotRenamed += $account
        }
        catch {
            Write-Host "Cannot rename [$account]" -ForegroundColor Red
            $stillNotRenamed += $account
        }
    }
    else {
        Write-Host "No profile found for [$account]" -ForegroundColor Red
        $noProfileList += $account
    }
}

$cannotRenameProfileList = $stillNotRenamed

#>