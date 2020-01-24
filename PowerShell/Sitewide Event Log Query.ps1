<#
.SYNOPSIS
  Scans computers on the network for specified log events

.DESCRIPTION
  Pulls available computers from the PVS database and scans the specified event logs for the specified event ID

  *Script should be stored in Y:\Scripts\ along with the required Logging_Functions.ps1 script
  *For log results, there should be a folder Y:\Scripts\Results\EventLogQuery Results\

.PARAMETER <Parameter_Name>
    N/A

.INPUTS
  None at the moment, but changing the variables $log, $eventID, and $startTime are required

.OUTPUTS
  Log file listing occurences of specified events at each YCSD site, and excel documents with event info for each site

  Location: Y:\Scripts\Results\EventLogQuery Results

.NOTES
  Version:        1.0
  Author:         Matt Varnell
  Creation Date:  3/3/2016
  Purpose/Change: Initial script development
  
.EXAMPLE
  <Example goes here. Repeat this attribute for more than one example>
#>
 
#---------------------------------------------------------[Configuration Section]--------------------------------------------------------
 
#Set Error Action to Silently Continue
$ErrorActionPreference = "SilentlyContinue"
 
#Dot Source required Function Libraries
. "Y:\Scripts\Logging_Functions.ps1"

#Configure the Remote PVS Server Variables
$PVSConsolePath = "C:\Program Files\Citrix\Provisioning Services Console"
$MCLIExe = "MCLI.exe"
$PVSServer = #PVSServerPlaceholder

#Configure the SQL Server, Database Name and Query
$SQLServer = #SQLServerPlaceholder
$SQLDBName = #SQLDBNamePlaceholder
$SQLQuery = #SQLQueryPlaceholder (Pulls list of all division computers)

#Create a New Database Connection
$SQLConnection = New-Object System.Data.SqlClient.SqlConnection
$SQLConnection.ConnectionString = "Server = $SQLServer; Database = $SQLDBName; Integrated Security = True"

#Configure a New SQL Command
$SQLCmd = New-Object System.Data.SqlClient.SqlCommand
$SQLCmd.CommandText = $SQLQuery
$SQLCmd.Connection = $SQLConnection

$SQLAdapter = New-Object System.Data.SqlClient.SqlDataAdapter
$SQLAdapter.SelectCommand = $SqlCmd

$DataSet = New-Object System.Data.DataSet
$Results = $SQLAdapter.Fill($DataSet)

#Count of Active Machines in PVS
$Result = $DataSet.Tables[0].Rows.Count 

$SQLConnection.Close()


$Date = $Date = (Get-Date).ToShortDateString()
$LineBreak = "`r`n"
 
#----------------------------------------------------------[Declarations]----------------------------------------------------------
 
#Script Version
$sScriptVersion = "1.0"
 
#Log File Info
$sLogPath = "\\Path\Results\EventLogQuery Results\"
$sLogName = "EventLogQuery-$(get-date -f yyyy-MM-dd).txt"
$sLogFile = Join-Path -Path $sLogPath -ChildPath $sLogName

#Event Log Info (Modify this to alter script results)
$log = "Application" 
$eventID = @(1015)
$startTime = (Get-Date).AddDays(-20)

#Email Server Settings - MAY MODIFY LATER TO SEND EMAIL RATHER THAN SAVE TO PERSONAL DRIVE
#$EmailSMTPServer = 
#$EmailSendTo = 
#$EmailFrom = 
#$EmailSubject = "Event Log Query Results - [ $Date ]"
#$EmailBody = "There were $Result computer(s) checked. $LineBreak $LineBreak See the attached log file ($sLogName) for more details."
#$EmailAttachment = $sLogFile
 
#-----------------------------------------------------------[Functions]------------------------------------------------------------

Function ScanEventLogs {
  Param()
  
  #Post script setup
  Begin {

    Log-Write -LogPath $sLogFile -LineValue "Scanning $Result computer(s) for specified Event Log errors"
    Log-Write -LogPath $sLogFile -LineValue $LineBreak

    #Initialize count variables to track event ID occurences by site
    $Site1Count = 0
    $Site2Count = 0
    $Site3Count = 0
    $Site4Count = 0
    $Site5Count = 0
    $Site6Count = 0
    $Site7Count = 0
    $Site8Count = 0
    $Site9Count = 0
    $Site10Count = 0
    $Site11Count = 0
    $Site12Count = 0
    $Site13Count = 0
    $Site14Count = 0
    $Site15Count = 0
    $Site16Count = 0
    $Site17Count = 0
    $Site18Count = 0
    $Site19Count = 0
    $Site20Count = 0
    $ShouldBeZeroCount = 0


  }
  
  #Main logic body
  Process {

    Try {
        
        #Each row in the table is an available computer in the PVS database
        ForEach ($Row in $DataSet.Tables[0].Rows) {

            #Pulls computer name and site from row data
            $CompName = $Row.Item('deviceName')
            $CompSite = $Row.Item('siteName')

            #If the $PreviousSite variable doesn't exist (start of script)...
            if (!$PreviousSite) {
                Log-Write -LogPath $sLogFile -LineValue "Starting site queries..."
            }
            #Otherwise, print out total count of event occurences at previously scanned site
            elseif ($PreviousSite -ne $CompSite) { 

                #Logic switch to print previous site count
                switch($PreviousSite){
                    "Site1" { Log-Write -LogPath $sLogFile -LineValue "$Site1Count machines affected by queried errors at $PreviousSite." }
                    "Site2" { Log-Write -LogPath $sLogFile -LineValue "$Site2Count machines affected by queried errors at $PreviousSite." }
                    "Site3" { Log-Write -LogPath $sLogFile -LineValue "$Site3Count machines affected by queried errors at $PreviousSite." }
                    "Site4" { Log-Write -LogPath $sLogFile -LineValue "$Site4Count machines affected by queried errors at $PreviousSite." }
                    "Site5" { Log-Write -LogPath $sLogFile -LineValue "$Site5Count machines affected by queried errors at $PreviousSite." }
                    "Site6" { Log-Write -LogPath $sLogFile -LineValue "$Site6Count machines affected by queried errors at $PreviousSite." }
                    "Site7" { Log-Write -LogPath $sLogFile -LineValue "$Site7Count machines affected by queried errors at $PreviousSite." }
                    "Site8" { Log-Write -LogPath $sLogFile -LineValue "$Site8Count machines affected by queried errors at $PreviousSite." }
                    "Site9" { Log-Write -LogPath $sLogFile -LineValue "$Site9Count machines affected by queried errors at $PreviousSite." }
                    "Site10" { Log-Write -LogPath $sLogFile -LineValue "$Site10Count machines affected by queried errors at $PreviousSite." }
                    "Site11" { Log-Write -LogPath $sLogFile -LineValue "$Site11Count machines affected by queried errors at $PreviousSite." }
                    "Site12" { Log-Write -LogPath $sLogFile -LineValue "$Site12Count machines affected by queried errors at $PreviousSite." }
                    "Site13" { Log-Write -LogPath $sLogFile -LineValue "$Site13Count machines affected by queried errors at $PreviousSite." }
                    "Site14" { Log-Write -LogPath $sLogFile -LineValue "$Site14Count machines affected by queried errors at $PreviousSite." }
                    "Site15" { Log-Write -LogPath $sLogFile -LineValue "$Site15Count machines affected by queried errors at $PreviousSite." }
                    "Site16" { Log-Write -LogPath $sLogFile -LineValue "$Site16Count machines affected by queried errors at $PreviousSite." }
                    "Site17" { Log-Write -LogPath $sLogFile -LineValue "$Site17Count machines affected by queried errors at $PreviousSite." }
                    "Site18" { Log-Write -LogPath $sLogFile -LineValue "$Site18Count machines affected by queried errors at $PreviousSite." }
                    "Site19" { Log-Write -LogPath $sLogFile -LineValue "$Site19Count machines affected by queried errors at $PreviousSite." }
                    "Site20" { Log-Write -LogPath $sLogFile -LineValue "$Site20Count machines affected by queried errors at $PreviousSite." }
                }
            }

            #If computer is reachable...
            if (Test-Connection $CompName -Count 1 -Quiet) {

                Write-Host "$CompName is running at $CompSite!"
                        
                #Performs the scan for each unique ID in $eventID array
                ForEach($id in $eventID) {

                    Write-Host "Checking if event $id exists on machine..." -ForegroundColor Cyan

                    #If $id is found on $CompName
                    if( Get-WinEvent -ComputerName $CompName -FilterHashTable @{ LogName = "$log"; ID= $id; StartTime = $startTime } ) { #If you need to specify a source, use providername="(Source)" in the -FilterHashTable

                        Write-Host "Event $id found" -ForegroundColor DarkCyan

                        #Pull the event log info on $id and export it to an Excel document for the $CompSite
                        Get-WinEvent -ComputerName $CompName -FilterHashTable @{ LogName = "$log"; ID= $id; StartTime = $startTime } | Select-Object @{Name='Site'; Expression={$_.MachineName.Substring(0,3).ToUpper()}},@{Name='Hostname'; Expression={$_.MachineName.ToUpper()}},Id,TimeCreated,Message | Export-CSV -Path ('\\Path\EventLogQuery Results\{0}-{1:yyyy_MM_dd}.csv' -f $CompSite,(Get-Date)) -NoTypeInformation -Append

                        #Logic switch to incrememt count for found events at $CompSite
                        switch($CompSite){
                            "Site1" { $Site1Count += 1 }
                            "Site2" { $Site2Count += 1 }
                            "Site3" { $Site3Count += 1 }
                            "Site4" { $Site4Count += 1 }
                            "Site5" { $Site5Count += 1 }
                            "Site6" { $Site6Count += 1 }
                            "Site7" { $Site7Count += 1 }
                            "Site8" { $Site8Count += 1 }
                            "Site9" { $Site9Count += 1 }
                            "Site10" { $Site10Count += 1 }
                            "Site11" { $Site11Count += 1 }
                            "Site12" { $Site12Count += 1 }
                            "Site13" { $Site13Count += 1 }
                            "Site14" { $Site14Count += 1 }
                            "Site15" { $Site15Count += 1 }
                            "Site16" { $Site16Count += 1 }
                            "Site17" { $Site17Count += 1 }
                            "Site18" { $Site18Count += 1 }
                            "Site19" { $Site19Count += 1 }
                            "Site20" { $Site20Count += 1 }
                            default { $ShouldBeZeroCount += 1 }
                        }
                    }
                }             
            }
            
            #Otherwise report that it cannot be reached 
            else {
                Write-Host "Failed to connect to $CompName. Is it running?"
            }

            #Set $PreviousSite to the current computers site for logic checking of a site change
            $PreviousSite = $CompSite
        }
    }
    
    #Catch any errors in script and report in log file, end script
    Catch {
      Log-Error -LogPath $sLogFile -ErrorDesc $_.Exception -ExitGracefully $false
      #Removing to prevent script exit on error: Break
      Continue
    }
  }
  
  #End script processing
  End{
    If($?){
      Log-Write -LogPath $sLogFile -LineValue "$YMSCount machines affected by queried errors at $PreviousSite."
      Log-Write -LogPath $sLogFile -LineValue $LineBreak
      Log-Write -LogPath $sLogFile -LineValue "End of Script Processing."
      Log-Write -LogPath $sLogFile -LineValue $LineBreak
      Log-Write -LogPath $sLogFile -LineValue "If this isn't zero, something's wrong: $ShouldBeZeroCount"
    }
  }
}
 
#-----------------------------------------------------------[Execution]------------------------------------------------------------

#Start log, run scan, finish log 
Log-Start -LogPath $sLogPath -LogName $sLogName -ScriptVersion $sScriptVersion
ScanEventLogs
Log-Finish -LogPath $sLogFile -NoExit $True


#Send Log via E-mail
#Send-MailMessage -From $EmailFrom -To $EmailSendTo -Subject $EmailSubject -Body $EmailBody -Attachments $EmailAttachment -SmtpServer $EmailSMTPServer


#Delete Log File from Script Directory
#Remove-Item $sLogFile