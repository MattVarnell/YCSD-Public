#$server = (Get-ADComputer -LDAPFilter "(name=*)") | Select-Object -expand Name
$comps= (Get-Content -Path \\Path\ErrorComps.txt)
$log = "Application" 
$eventID = @(501)
$startTime = (Get-Date).AddDays(-75)

ForEach ($c in $comps)

{

Try {

$ErrorActionPreference = "Stop";

    Write-Host `n

    Write-Host "Attempting to communicate with Computer: $c"

        $status = Test-Connection -ComputerName $c -Count 1

        if ($status.StatusCode -ne 0) {
            
            Write-Warning "Could not connect to $c. Please ensure the computer is valid and reachable."
            
            }
        
        if ($status.StatusCode -eq 0) {

            Write-Debug "$c Appears to be Online. Querying Event Log for the Past 24 Hours for specified event..."

            ForEach($id in $eventID) {
           
                if( Get-WinEvent -ComputerName $c -FilterHashTable @{ LogName = "$log"; ID= $id; StartTime = $startTime; } ) {
                    Get-WinEvent -ComputerName $c -FilterHashTable @{ LogName = "$log"; ID= $id; StartTime = $startTime; } | Select-Object Id,TimeCreated,Message | Export-CSV -Path ('Y:\Scripts\Results\FindErrorCode Results\{1:yyyy_MM_dd}-{0}.csv' -f $c,(Get-Date)) -NoTypeInformation -Append
                    }
                }

            Write-Host "$c Finished Successfully. Moving on." 
        }

}

Catch {
    
    Write-Host ('Error Message: "{0}"' -f $_.Exception.Message) -ForegroundColor Red    

      }
}
