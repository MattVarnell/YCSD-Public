<#
	.SYNOPSIS
		Script to shut down division computers based on hostname and site.
	.DESCRIPTION
		 Extracts a list of computers from the PVS database, filters based on hostname, and shuts them down depending on time.
	.Notes
		.Authors
            Matt Varnell
		    Jason Brousseau
        .Dependencies
            Logging_Functions.ps1 Library
            $sLogPath directory exists
            Proper Exchange server settings
		. Last Updated 3/18/2019
			Added to e-mail list.
#>

#------------------------------------ Configuration Section ----------------------------------------

#Get site code values and script status settings
$School = Import-Csv "\\Path\Schools_Enabled_Disabled.csv" -Header School,Status

#Set Error Action to Silently Continue
$ErrorActionPreference = "SilentlyContinue"

#Dot Source required Function Libraries
. "\\Path\Logging_Functions.ps1"

#Configure the message to send during shutdown
$ShutdownCmt = "YCSD computers are scheduled to shut down. You have five minutes to save your work. If you are leaving for the night, please turn off your monitor. If you need to continue working, you may restart the computer after the shut down is complete."

#Configure the Remote PVS Server Variables
$PVSConsolePath = "C:\Program Files\Citrix\Provisioning Services Console"
$MCLIExe = "MCLI.exe"
$Delay = "300" #Set the shutdown delay timer in seconds

#Script Version
$sScriptVersion = "3.0"

#Log File Info
$sLogPath = "\\Path\Temp"
$sLogName = "YCSDComputerShutdownLog-$(get-date -f yyyy-MM-dd_HH-MM).txt"
$sLogFile = Join-Path -Path $sLogPath -ChildPath $sLogName

#Date settings for shutdown timing
$DateTimeNow = Get-Date 
$DateTimeEarly = Get-Date -Hour 21 -Minute 59
$DateTimeMidnight = Get-Date -Hour 23 -minute 50

#Line break variable for log formatting
$LineBreak = "`r`n"

#Variable to store total count of machines targeted
$TotalDevices = 0

#----------------------------- Configure Shared Site PVS Servers Below -----------------------------
$site1PVS1 = #SitePVSPlaceholder
$site1PVS2 = #SitePVSPlaceholder


$site2PVS1 = #SitePVSPlaceholder
$site2PVS2 = #SitePVSPlaceholder

$site3PVS1 = #SitePVSPlaceholder
$site3PVS2 = #SitePVSPlaceholder

$site4PVS1 = #SitePVSPlaceholder
$site4PVS2 = #SitePVSPlaceholder


#---------------------------- Functions ------------------------------------------------------------

#Determines which site PVS server is responding, and which to use
#Inputs:
## $Server1 - (Site)-PVS-01
## $Server2 - (Site)-PVS-02
#Output:
## $ServerToUse - The PVS server to be used for the site shutdowns
function TestPVS($Server1, $Server2){

    if (Test-Connection $Server1 -Count 1 -Quiet) {
        Write-Host "$Server1 will be used"
        $ServerToUse = $Server1
    }
    elseif (Test-Connection $Server2 -Count 1 -Quiet) {
        Write-Host "$Server2 will be used"
        $ServerToUse = $Server2
    }
    else {
        Write-Host "No PVS server available"
        $ServerToUse = $null
    }

    return $ServerToUse
}

#Pulls list of computers booted on-site based on SQL query
#Inputs:
## $Query - The SQL query to be used to determine which computers are shut down
#Output:
## $DataSet - A table of the computers to be shut down, referenced by $DataSet.Tables[0].Rows
function GetDataSet($Query) {

    #Configure the SQL Server, Database Name and Query
    $SQLServer = #SQLServerPlaceholder
    $SQLDBName = #SQLDBPlaceholder

    #Create a New Database Connection
    $SQLConnection = New-Object System.Data.SqlClient.SqlConnection
    $SQLConnection.ConnectionString = "Server = $SQLServer; Database = $SQLDBName; Integrated Security = True"

    #Configure a New SQL Command
    $SQLCmd = New-Object System.Data.SqlClient.SqlCommand
    $SQLCmd.CommandText = $Query
    $SQLCmd.Connection = $SQLConnection

    #Configure an SQL Adapter
    $SQLAdapter = New-Object System.Data.SqlClient.SqlDataAdapter
    $SQLAdapter.SelectCommand = $SqlCmd

    #Populate the $DataSet variable with results from the query
    $DataSet = New-Object System.Data.DataSet
    $Results = $SQLAdapter.Fill($DataSet)

    #Close SQL connection
    $SQLConnection.Close()

    return $DataSet

}

#Shuts down devices at specified site using MCLI
#Inputs:
## $Server - The PVS server to be used for the MCLI calls
## $Computers - List of computers on site that will be shut down
#Output:
## $Result - Total number of computers on-site to be shut down
function ShutdownSite($Server, $Computers) {
   
    Begin {
        
        $Result = $Computers.Tables[0].Rows.Count                             #Count of all devices on-site to be shut down
        $SiteName = $Computers.Tables[0].Rows[0].deviceName.Substring(0,3)    #Pulls site code from list of computers
        Log-Write -LogPath $sLogFile -LineValue $LineBreak
        Log-Write -LogPath $sLogFile -LineValue "There were $Result computer(s) running at $SiteName`:"
        Log-Write -LogPath $sLogFile -LineValue $LineBreak
    }

    Process {

        Try {

            #Processes for each computer at the site
            Foreach ($Row in $Computers.Tables[0].Rows) {

                $CompName = $Row.Item('deviceName')    #Extract hostname for the device

                #If device is responsive...
                if (Test-Connection $CompName -Count 1 -Quiet) {

                    Log-Write -LogPath $sLogFile -LineValue "***************  $CompName is running!  ***************"
                    Log-Write -LogPath $sLogFile -LineValue "Sending 5 minute delayed shut down command to $CompName"

                    #PVS MCLI command invoked to shut down the target device
                    Invoke-Command -ComputerName $Server -ScriptBlock {
                        cd $($args[0]); cmd.exe /c $($args[1]) RunWithReturn Shutdown -p deviceName=$($args[2]) message=$($args[3]) delay=$($args[4])
                    } -ArgumentList $PVSConsolePath, $MCLIExe, $CompName, $ShutdownCmt, $Delay > $NULL
                }
                else {
                    Log-Write -LogPath $sLogFile -LineValue "Failed to connect to $CompName. Is it running?"
                }
            }
        }
        #Catch errors, will be detailed in the log
        Catch {
            Log-Error -LogPath $sLogFile -ErrorDesc $_.Exception -ExitGracefully $True
            Break
        }
    }

    End {

        #If true...
        if ($?) {                       
            return $Result
        }
    }
}

#---------------------------------------------------------------------------------------------------

#Start Shutdown Script log
Log-Start -LogPath $sLogPath -LogName $sLogName -ScriptVersion $sScriptVersion

#Loop through each site extracted from the CSV
ForEach($s in $School) {
    
    #Extract data from $School variable
    $SiteCode = $s.School
    $Status = $s.Status

    #SQL query to be used for site devices, excludes XA servers and VDI machines
    $SQLQuery = #SQLQueryPlaceholder
    
    #Avoids shutting down machines if they're disabled in the CSV (pre midnight task)
    if ($Status -eq '0' -and $DateTimeNow.TimeOfDay -lt $DateTimeMidnight.TimeOfDay) {
        Write-Warning "$SiteCode is currently disabled."
    }
    #Will run the shutdown commands on any site that's enabled at all times, and will run on all sites (including disabled) at midnight scheduling
    elseif ($Status -eq '1' -or ($Status -eq '0' -and $DateTimeNow.TimeOfDay -ge $DateTimeMidnight.TimeOfDay)) {

        Write-Host "$SiteCode is currently enabled."

        #Switch to handle sites with shared PVS servers for collections
        switch($SiteCode) {
            
            "#SITE" {
                
                Write-Warning "$SiteCode uses a shared PVS server."

                $PVSServer = TestPVS $site2PVS1 $site2PVS2

                $CompList = GetDataSet $SQLQuery

                $TotalDevices += ShutdownSite $PVSServer $CompList

            }
			
            "#SITE" {

                Write-Warning "$SiteCode uses a shared PVS server."

                $PVSServer = TestPVS $site3PVS1 $site3PVS2

                $CompList = GetDataSet $SQLQuery

                $TotalDevices += ShutdownSite $PVSServer $CompList
            }

            #SITE won't shut down until the 10PM scheduled task
            "#SITE" {

                #If the time is before 10PM, don't run the task
                if ($DateTimeNow.TimeOfDay -lt $DateTimeEarly.TimeOfDay) {
                    Write-Warning "Could not run command on MNT. Time does not match."
                }
                #Post-10PM the task will run as normal using the specialized Farm query
                else {
                    Write-Warning "$SiteCode uses a shared PVS server."

                    $PVSServer = TestPVS $site3PVS1 $site3PVS2

                    $SQLQuery = #SQLQueryPlaceholder

                    $CompList = GetDataSet $SQLQuery

                    $TotalDevices += ShutdownSite $PVSServer $CompList
                }
            }
			
            "#SITE" {

                Write-Warning "$SiteCode uses a shared PVS server."

                $PVSServer = TestPVS $site3PVS1 $site3PVS2

                $CompList = GetDataSet $SQLQuery

                $TotalDevices += ShutdownSite $PVSServer $CompList
            }

            "#SITE" {

                Write-Warning "$SiteCode uses a shared PVS server."

                $PVSServer = TestPVS $site1PVS1 $site1PVS2

                $CompList = GetDataSet $SQLQuery

                $TotalDevices += ShutdownSite $PVSServer $CompList
            }

            "#SITE" {

                Write-Warning "$SiteCode uses a shared PVS server."

                $PVSServer = TestPVS $site1PVS1 $site1PVS2

                $CompList = GetDataSet $SQLQuery

                $TotalDevices += ShutdownSite $PVSServer $CompList
            }

            "#SITE" {

                Write-Warning "$SiteCode uses a shared PVS server."

                $PVSServer = TestPVS $site3PVS1 $site3PVS2

                $CompList = GetDataSet $SQLQuery

                $TotalDevices += ShutdownSite $PVSServer $CompList
            }

            "#SITE" {

                Write-Warning "$SiteCode uses a shared PVS server."

                $PVSServer = TestPVS $site4PVS1 $site4PVS2

                $CompList = GetDataSet $SQLQuery

                $TotalDevices += ShutdownSite $PVSServer $CompList
            }

            "Principal Desktops" {

                Write-Warning "$SiteCode uses a shared PVS server."

                $PVSServer = TestPVS $site2PVS1 $site2PVS2

                $SQLQuery = #SQLQueryPlaceholder

                $CompList = GetDataSet $SQLQuery

                $TotalDevices += ShutdownSite $PVSServer $CompList
            }

            #Catch-all statement for any devices not using a shared PVS site
            default {

                $PVS1 = "$SiteCode`#PVSServer"
                $PVS2 = "$SiteCode`#PVSServer"

                $PVSServer = TestPVS $PVS1 $PVS2

                $CompList = GetDataSet $SQLQuery

                $TotalDevices += ShutdownSite $PVSServer $CompList
            }
        }
    }
}

<#
#Debug log write to verify time comparison values
Log-Write -LogPath $sLogFile -LineValue $LineBreak
Log-Write -LogPath $sLogFile -LineValue "DateTimeNow - DateTimeMidnight: $DateTimeNow - $DateTimeMidnight"
Log-Write -LogPath $sLogFile -LineValue $LineBreak
Log-Write -LogPath $sLogFile -LineValue "Comparison of DateTimeNow > DateTimeMidnight: $($DateTimeNow -ge $DateTimeMidnight)"
Log-Write -LogPath $sLogFile -LineValue $LineBreak
Log-Write -LogPath $sLogFile -LineValue "DateTimeNow.TimeOfDay - DateTimeMidnight.TimeOfDay: $($DateTimeNow.TimeOfDay) - $($DateTimeMidnight.TimeOfDay)"
Log-Write -LogPath $sLogFile -LineValue $LineBreak
Log-Write -LogPath $sLogFile -LineValue "Comparison of DateTimeNow.TimeOfDay > DateTimeMidnight.TimeOfDay: $($DateTimeNow.TimeOfDay -ge $DateTimeMidnight.TimeOfDay)"
#>

#Write final count of devices shut down and notify that the script has finished
Log-Write -LogPath $sLogFile -LineValue $LineBreak
Log-Write -LogPath $sLogFile -LineValue $LineBreak
Log-Write -LogPath $sLogFile -LineValue "There were $TotalDevices computer(s) running between all sites."
Log-Write -LogPath $sLogFile -LineValue $LineBreak
Log-Write -LogPath $sLogFile -LineValue "End of Script Processing."

#Finish log file
Log-Finish -LogPath $sLogFile -NoExit $True


#Email Server Settings
$Date = (Get-Date).ToShortDateString()
$EmailSMTPServer = #SMTPServerPlaceholder
$EmailSendTo = #EmailSendToPlaceholder
$EmailFrom = #EmailFromPlaceholder
$EmailSubject = "YCSD Computer Shutdown Log - [ $Date ]"
$EmailBody = "There were $TotalDevices computer(s) running. $LineBreak $LineBreak See the attached log file ($sLogName) for more details."
$EmailAttachment = $sLogFile

#Send Log via E-mail
Send-MailMessage -From $EmailFrom -To $EmailSendTo -Subject $EmailSubject -Body $EmailBody -Attachments $EmailAttachment -SmtpServer $EmailSMTPServer

#Clear the log from temp
Remove-Item $sLogFile

#Resets the CSV to the default settings for the next day
if($DateTimeNow.TimeOfDay -ge $DateTimeMidnight.TimeOfDay) {
    Copy-Item -Path "\\Path\Schools_Enabled_Disabled_Default.csv" -Destination "\\Path\Schools_Enabled_Disabled.csv"
}