# DHCP Printer Reservation Creation

#ScopeID      - Base IP of the Scope on the DHCP Server
#IPAddress    - Static IP wanted for the reservation
#ClientID     - MAC of the client device
#Name         - Name of the device in the reservation
#Description  - Reservation description
#ComputerName - Server hosting the DHCP service

$ErrorActionPreference = "Stop"


Class Printer {

    [Reservation]$printerReservation
    [ModelOfPrinter]$model
    [String]$printServer
    [String]$ipAddress
    [String]$site
    [String]$roomNumber

    ###############################################################################################################################
    # Polls the user for the printer model                                                                                        #
    ###############################################################################################################################

    GetPrinterModel() {
        
        $ModelList = [System.Enum]::GetValues([ModelOfPrinter])
        $count = 1

        Write-Host "What model is this printer?"

        foreach ($i in $ModelList){
            Write-Host $count": $i"
            $count++
        }

        $this.model = $(Read-Host "Input Selection")-1
    }

    ###############################################################################################################################
    # Polls the user for which print server to add the printer to
    ###############################################################################################################################

    GetPrinterServer() {
        
        $PrintServerList = Get-ADGroupMember -Identity "YCSD Print Servers" | Select-Object name | Sort-Object name
        $count = 1

        Write-Host "Which print server will this printer be installed on?"

        foreach ($i in $PrintServerList){
            Write-Host $count": $($i.name)"
            $count++
        }

        $this.printServer = $($PrintServerList[$(Read-Host "Input Selection")-1].name)

        $this.site = $this.printServer.Substring(0,3)
    }

    ###############################################################################################################################
    # Has the user print a test page to get printer IP                                                                            #
    ###############################################################################################################################

    GetPrinterIP() {
            
        Write-Host "Connect the printer to the network, and print a test page to get the IP address." -ForegroundColor Green
    
        Read-Host "Press enter to continue" | Out-Null

        $this.ipAddress = Read-Host "What is the new printer's IP address?"
        
    }

    ###############################################################################################################################
    # Polls the user for printer room                                                                                             #
    ###############################################################################################################################

    GetPrinterRoom() {
        $this.roomNumber = Read-Host "What is the room number where the printer is being installed?"
    }

}

Enum ModelOfPrinter {

    Ricoh320
    Brother8910
    TestPrint3650
    AnotherPrint210

}

Class Reservation {

    [Array]$serverList
    [String]$DHCPServer
    [String]$DHCPScope
    [String]$DHCPScopeIP
    [String]$ReservationIPOld
    [String]$ReservationIPNew

    [String]$PrinterSite
    [String]$PrinterRoom
    [String]$PrinterModel

    ###############################################################################################################################
    # Pulls the list of DHCP servers on the network for each site                                                                 #
    ###############################################################################################################################

    GetDHCPServers() {
        $this.serverList = Get-DhcpServerInDC
    }

    ###############################################################################################################################
    # Sets the DHCPServer variable, which is the server which the reservation will be created on                                  #
    ###############################################################################################################################

    SetDHCPServer() {
        
        Write-Host "Which server would you like to create/import reservations for? (Number)"

        # Lists the DHCP servers for each site
        for($i=0; $i -le $this.serverList.Length-1; $i+=1) {
        
            Write-Host "$($i+1): " $this.serverList[$i].DnsName
        }

        $serverChoice = Read-Host "Input selection"

        # Sets the DHCPServer variable to be the DNS name of the DHCP server (Ex. ycsd-bhs.ycsd.york.va.us)
        $this.DHCPServer = $this.serverList[$serverChoice-1].DnsName
    }

    ###############################################################################################################################
    # Sets the DHCPScopeIP variable, which is the scope the reservation will be created in                                        #
    ###############################################################################################################################

    SetDHCPServerScope() {
        
        # Creates an array of DHCP server scopes
        $scopes = Get-DhcpServerv4Scope -ComputerName $this.DHCPServer
        $count = 1

        Write-Host "Which scope would you like to create/import reservations for? (Number)"

        # Lists the scopes for the selected site
        for($i=0; $i -le $scopes.Length-1; $i+=1) {
        
            if($scopes[$i].Name.Length -eq 3 -and $scopes[$i].Name -ne "VDI") {
                Write-Host "$($count): " $scopes[$i].Name "-" $scopes[$i].ScopeId.IPAddressToString
                $count +=1
            }
        }

        $scopeChoice = Read-Host "Input selection"

        # Sets the DHCPScopeIP variable to be the base IP of the scope (Ex. 192.168.16.0)
        $this.DHCPScopeIP = $scopes[$scopeChoice-1].ScopeId.IPAddressToString
    }

    ###############################################################################################################################
    # Finds the old printer's reservation and updates it with the new printer's MAC address                                       #
    ###############################################################################################################################

    ReplaceDHCPReservation() {

        $this.ReservationIPOld = Read-Host "What is the old printer's IP address?"

        Write-Host "Before continuing, please verify the new printer is plugged in and hooked up to the network." -ForegroundColor Green
    
        Read-Host "Press enter to continue" | Out-Null

        $this.ReservationIPNew = Read-Host "What is the replacement printer's IP address?"

        # Finds the new printer's lease based on the IP address
        $newPrinterLease = Get-DhcpServerv4Lease -ComputerName $this.DHCPServer -IPAddress $this.ReservationIPNew

        # Changes the old printer's reservation to use the new printer's MAC address
        Set-DhcpServerv4Reservation -ComputerName $this.DHCPServer -IPAddress $this.ReservationIPOld -ClientId $newPrinterLease.ClientId
    }

    ###############################################################################################################################
    # Finds the old printer's reservation and updates it with the new printer's hostname and MAC address                          #
    ###############################################################################################################################

    UpdateDHCPReservation() {

        $this.ReservationIPOld = Read-Host "What is the old printer's IP address?"

        Write-Host "Before continuing, please verify the new printer is plugged in and hooked up to the network." -ForegroundColor Green
    
        Read-Host "Press enter to continue" | Out-Null

        $this.ReservationIPNew = Read-Host "What is the replacement printer's IP address?"
    
        # Creates the printer description for the DHCP reservation (since the printer model will change, unlike the replace)
        $PrinterSite = $this.DHCPServer.Substring(5,3)
        $PrinterRoom = Read-Host "What room is the new printer being installed in?"
        $PrinterModel = Read-Host "What is the model of the new printer? (Xerox, Ricoh, HP, etc)"
        $Description = "$PrinterSite-$PrinterRoom-$PrinterModel"

        # Finds the new printer's lease based on the IP address
        $newPrinterLease = Get-DhcpServerv4Lease -ComputerName $this.DHCPServer -IPAddress $this.ReservationIPNew

        # Changes the old printer's reservation to use the new printer's MAC address and description
        Set-DhcpServerv4Reservation -ComputerName $this.DHCPServer -IPAddress $this.ReservationIPOld -ClientId $newPrinterLease.ClientId -Name $Description.toLower()    

    }

    NewDHCPReservation() {

        Write-Host "Before continuing, please verify the new printer is plugged in and hooked up to the network." -ForegroundColor Green
    
        Read-Host "Press enter to continue" | Out-Null

        $this.ReservationIPNew = Read-Host "What is the printer's IP address?"

        # Creates the printer description for the new DHCP reservation
        $PrinterSite = $this.DHCPServer.Substring(5,3)
        $PrinterRoom = Read-Host "What room is the new printer being installed in?"
        $PrinterModel = Read-Host "What is the model of the new printer? (Xerox, Ricoh, HP, etc)"
        $Description = "$PrinterSite-$PrinterRoom-$PrinterModel"

        # Try to see if a lease exists (will occur if the printer is on the network), will end the script if no lease is found
        try {
            $newPrinterLease = Get-DhcpServerv4Lease -ComputerName $this.DHCPServer -IPAddress $this.ReservationIPNew
        }
        catch {
            Write-Host "Error finding DHCP lease for the new printer. Verify that printer is connected to the network and the IP address is typed correctly."
            Break
        }

        # Creates a new DHCP reservation for the previously found lease
        Add-DhcpServerv4Reservation -ComputerName $this.DHCPServer -ScopeId $this.DHCPServerScope -IPAddress $this.ReservationIPNew -ClientId $newPrinterLease.ClientId -Name $Description.toLower()

    }
}


function Main {

    $Printer = New-Object Printer
    $Reservation = New-Object Reservation
    
    Write-Host "What action would you like to perform? (Number)"
    Write-Host "1: Add a new printer"
    Write-Host "2: Replace an existing printer with the same model type"
    Write-Host "3: Replace an existing printer with a different model type"
    $choice = Read-Host  "Input selection: "

    Switch($choice){

        1 { 
            $Reservation.GetDHCPServers()
            $Reservation.SetDHCPServer()
            $Reservation.SetDHCPServerScope()
            $Reservation.NewDHCPReservation()
          }
        2 { 
            $Reservation.GetDHCPServers()
            $Reservation.SetDHCPServer()
            $Reservation.SetDHCPServerScope()
            $Reservation.ReplaceDHCPReservation()
          }
        3 { 
            $Reservation.GetDHCPServers()
            $Reservation.SetDHCPServer()
            $Reservation.SetDHCPServerScope()
            $Reservation.UpdateDHCPReservation()   
          }
        default { "You did not enter a valid choice, please restart the script." }
    }
}

$Printer = New-Object Printer

$Printer.GetPrinterServer()