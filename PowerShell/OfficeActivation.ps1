$ComputerName = Read-host "Enter the Computer Name"

# Copy PSExec, PSKill to Local Computer C:\Temp
If (-not (Test-Path -Path C:\Temp)) {

    Write-Host Creating C:\Temp directory on local computer.
    New-Item -ItemType Directory -Path C:\Temp
    Copy-Item \\Path\PsExec.exe C:\temp\
    Copy-Item \\Path\PsKill.exe C:\temp\

}
Else { 

    If (-not (Test-Path -Path C:\Temp\PSExec.exe)) { Copy-Item \\Path\PsExec.exe C:\temp\ }
    If (-not (Test-Path -Path C:\Temp\PSKill.exe)) { Copy-Item \\Path\PsKill.exe C:\temp\ }

}

# Test remote computer for connectivity. If successful, continue. Otherwise, report the computer is down.
If (-not (Test-Connection -ComputerName $ComputerName -quiet -Count 2)) {
    Write-Warning "$ComputerName is down. Is the computer name correct?"
}
Else {

    # Copy Office Activation Batch file to remote computer
    Copy-Item \\Path\Office\PSO365DBA.bat \\$ComputerName\C$\Temp\PSO365DBA.bat 
    Write-Output "Checking for existing OPPTransition.exe process running on $ComputerName."

    # Check to see if OPPTransition is running on the remote computer
    C:\Temp\PSKill.exe \\$ComputerName OPPTransition.exe 2>$null

    # Send activation commands to remote computer by using O365DBA.bat file copied earlier
    Write-Output "Sending Activation Commands for Office 365 ProPlus on $ComputerName"
    C:\Temp\PSExec.exe \\$ComputerName "C:\Temp\PSO365DBA.bat" 2>$null

    Read-Host -Prompt "Press Enter to Exit"

} 
