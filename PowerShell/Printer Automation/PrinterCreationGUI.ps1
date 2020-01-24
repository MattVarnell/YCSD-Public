#ERASE ALL THIS AND PUT XAML BELOW between the @" "@
$inputXML = @"
<Window x:Name="MainWindow" x:Class="WpfApplication2.Window1"
        xmlns="http://schemas.microsoft.com/winfx/2006/xaml/presentation"
        xmlns:x="http://schemas.microsoft.com/winfx/2006/xaml"
        xmlns:d="http://schemas.microsoft.com/expression/blend/2008"
        xmlns:mc="http://schemas.openxmlformats.org/markup-compatibility/2006"
        xmlns:local="clr-namespace:WpfApplication2"
        mc:Ignorable="d"
        Title="Print Server Manager" Height="500" Width="700" FontSize="14" ResizeMode="NoResize" Focusable="False" Topmost="True">
    <Grid x:Name="NewGrid">
        <Grid.RowDefinitions>
            <RowDefinition/>
        </Grid.RowDefinitions>
        <Grid.ColumnDefinitions>
            <ColumnDefinition Width="230*"/>
            <ColumnDefinition Width="230*"/>
            <ColumnDefinition Width="230*"/>
        </Grid.ColumnDefinitions>
        <Label x:Name="DHCPLabel" Content="DHCP Server" HorizontalAlignment="Left" Margin="10,95,0,0" VerticalAlignment="Top" Height="29" Width="89"/>
        <Label x:Name="ScopeLabel" Content="DHCP Scope" HorizontalAlignment="Left" Margin="10,95,0,0" VerticalAlignment="Top" Grid.Column="1" Height="29" Width="88"/>
        <Label x:Name="PrintServerLabel" Content="Print Server" HorizontalAlignment="Left" Height="29" Margin="8,95,0,0" VerticalAlignment="Top" Width="123" Grid.Column="2"/>
        <Label x:Name="PrinterModelLabel" Content="Printer Model" HorizontalAlignment="Left" Height="25" Margin="10,163,0,0" VerticalAlignment="Top" Width="100"/>
        <Label x:Name="DriverLabel" Content="Printer Driver" HorizontalAlignment="Left" Height="25" Margin="10,163,0,0" VerticalAlignment="Top" Width="107" Grid.Column="1"/>
        <Label x:Name="RoomLabel" Content="Printer Name" HorizontalAlignment="Left" Height="25" Margin="10,235,0,0" VerticalAlignment="Top" Width="125"/>
        <TextBox x:Name="RoomTextBox" HorizontalAlignment="Left" Height="27" Margin="10,260,0,0" TextWrapping="Wrap" Text="Enter {Site}-{Room/Location}" Width="213" FontSize="12" VerticalAlignment="Top" VerticalContentAlignment="Center" BorderThickness="2" TabIndex="9" IsEnabled="False"/>
        <Label x:Name="NewIPLabel" Content="New Printer IP" HorizontalAlignment="Left" Height="25" Margin="11,235,0,0" VerticalAlignment="Top" Width="106" Grid.Column="1"/>
        <TextBox x:Name="NewIPTextBox" HorizontalAlignment="Left" Height="27" Margin="10,260,0,0" TextWrapping="Wrap" Text="Enter new printer IP address" VerticalAlignment="Top" Width="214" FontSize="12" Grid.Column="1" VerticalContentAlignment="Center" BorderThickness="2" TabIndex="10" IsEnabled="False"/>
        <RadioButton x:Name="NewRadio" Content="Add a New Printer" HorizontalAlignment="Left" Margin="10,10,0,0" VerticalAlignment="Top" FontSize="13" Height="16" Width="250" BorderThickness="2" Grid.ColumnSpan="2" GroupName="ToolSelect" TabIndex="1"/>
        <RadioButton x:Name="UpdateRadio" Content="Update Printer with a Different Model" HorizontalAlignment="Left" Margin="10,52,0,0" VerticalAlignment="Top" FontSize="13" Grid.ColumnSpan="2" Height="16" Width="250" BorderThickness="2" GroupName="ToolSelect" TabIndex="3"/>
        <RadioButton x:Name="ReplaceRadio" Content="Replace Printer with the Same Model" HorizontalAlignment="Left" Margin="10,31,0,0" VerticalAlignment="Top" FontSize="13" Grid.ColumnSpan="2" Height="16" Width="250" BorderThickness="2" GroupName="ToolSelect" TabIndex="2"/>
        <CheckBox x:Name="VerifyCheckBox" Content="This information is correct" HorizontalAlignment="Left" Margin="8,350,0,0" VerticalAlignment="Top" FontSize="13" RenderTransformOrigin="0.5,0.5" Grid.Column="2" Height="36" Width="213" Padding="4,-2,0,0" BorderThickness="2" TabIndex="12" IsEnabled="False"/>
        <Button x:Name="CreateButton" Content="Create" HorizontalAlignment="Left" Height="69" Margin="8,390,0,0" VerticalAlignment="Top" Width="213" Grid.Column="2" TabIndex="13" BorderThickness="2" FontWeight="Bold" FontSize="18" IsEnabled="False"/>
        <Border x:Name="TextBlockBorder" BorderBrush="Black" BorderThickness="2" HorizontalAlignment="Left" Height="109" Margin="10,350,0,0" VerticalAlignment="Top" Width="447" Grid.ColumnSpan="2">
            <TextBlock x:Name="GuideTextBlock" HorizontalAlignment="Left" Height="108" Margin="-1,-1,-3,-2" TextWrapping="Wrap" VerticalAlignment="Top" Width="447" FontSize="12" Padding="5,2"/>
        </Border>
        <Label x:Name="OldIPLabel" Content="Old Printer IP" Grid.Column="2" HorizontalAlignment="Left" Height="30" Margin="8,235,0,0" VerticalAlignment="Top" Width="110"/>
        <TextBox x:Name="OldIPTextBox" Grid.Column="2" HorizontalAlignment="Left" Height="27" Margin="8,260,0,0" TextWrapping="Wrap" VerticalAlignment="Top" Width="213" FontSize="12" Text="Enter old printer IP address" VerticalContentAlignment="Center" BorderThickness="2" TabIndex="11" IsEnabled="False"/>
        <Label x:Name="GuideBoxLabel" Grid.ColumnSpan="2" Content="This section will guide you through the printer setup process:" HorizontalAlignment="Left" Height="30" Margin="10,325,0,0" VerticalAlignment="Top" Width="400" FontSize="12" FontWeight="Bold"/>
        <ComboBox x:Name="DHCPComboBox" HorizontalAlignment="Left" Height="27" Margin="10,118,0,0" VerticalAlignment="Top" Width="213" TabIndex="4" BorderThickness="2" IsReadOnly="True" IsEnabled="False"/>
        <ComboBox x:Name="ScopeComboBox" Grid.Column="1" HorizontalAlignment="Left" Height="27" Margin="11,118,0,0" VerticalAlignment="Top" Width="213" BorderThickness="2" IsReadOnly="True" TabIndex="5" IsEnabled="False"/>
        <ComboBox x:Name="PrintServerComboBox" Grid.Column="2" HorizontalAlignment="Left" Height="27" Margin="8,118,0,0" VerticalAlignment="Top" Width="213" BorderThickness="2" IsReadOnly="True" TabIndex="6" IsEnabled="False"/>
        <ComboBox x:Name="PrinterModelComboBox" HorizontalAlignment="Left" Height="27" Margin="10,188,0,0" VerticalAlignment="Top" Width="213" BorderThickness="2" IsReadOnly="True" TabIndex="7" IsEnabled="False"/>
        <ComboBox x:Name="DriverComboBox" Grid.Column="1" HorizontalAlignment="Left" Height="27" Margin="10,188,0,0" VerticalAlignment="Top" Width="214" TabIndex="8" IsReadOnly="True" IsEnabled="False" BorderThickness="2"/>
        <Image x:Name="RoomImageCheck" HorizontalAlignment="Left" Height="16" Margin="205,239,0,0" VerticalAlignment="Top" Width="16" Source="Y:\Scripts\ScriptCheck.png" Visibility="Hidden"/>
        <Image x:Name="NewIPImageCheck" HorizontalAlignment="Left" Height="16" Margin="208,239,0,0" VerticalAlignment="Top" Width="16" Source="Y:\Scripts\ScriptCheck.png" Grid.Column="1" Visibility="Hidden"/>
        <Image x:Name="OldIPImageCheck" HorizontalAlignment="Left" Height="16" Margin="205,239,0,0" VerticalAlignment="Top" Width="16" Source="Y:\Scripts\ScriptCheck.png" Grid.Column="2" Visibility="Hidden"/>
        <Image x:Name="RoomImageX" HorizontalAlignment="Left" Height="16" Margin="205,239,0,0" VerticalAlignment="Top" Width="16" Source="Y:\Scripts\ScriptX.png" Visibility="Hidden"/>
        <Image x:Name="NewIPImageX" HorizontalAlignment="Left" Height="16" Margin="208,239,0,0" VerticalAlignment="Top" Width="16" Source="Y:\Scripts\ScriptX.png" Grid.Column="1" Visibility="Hidden"/>
        <Image x:Name="OldIPImageX" HorizontalAlignment="Left" Height="16" Margin="205,239,0,0" VerticalAlignment="Top" Width="16" Source="Y:\Scripts\ScriptX.png" Grid.Column="2" Visibility="Hidden"/>
        <Label x:Name="ReservationNameLabel" Content="" Grid.Column="2" HorizontalAlignment="Left" Margin="5,282,0,0" VerticalAlignment="Top" Width="213" FontSize="12"/>
        <Button x:Name="UndoButton" Content="Undo Action" Grid.Column="2" HorizontalAlignment="Left" Height="69" Margin="8,10,0,0" VerticalAlignment="Top" Width="213" BorderThickness="2" FontSize="18" FontWeight="Bold" Visibility="Hidden"/>
    </Grid>
</Window>
"@       
 
$inputXML = $inputXML -replace 'mc:Ignorable="d"','' -replace "x:N",'N'  -replace '^<Win.*', '<Window'
 
[void][System.Reflection.Assembly]::LoadWithPartialName('presentationframework')
[xml]$XAML = $inputXML
#Read XAML
 
    $reader=(New-Object System.Xml.XmlNodeReader $xaml)
  try{$Form=[Windows.Markup.XamlReader]::Load( $reader )}
catch{Write-Host "Unable to load Windows.Markup.XamlReader. Double-check syntax and ensure .net is installed."}
 
#===========================================================================
# Load XAML Objects In PowerShell
#===========================================================================
 
$xaml.SelectNodes("//*[@Name]") | %{Set-Variable -Name "WPF$($_.Name)" -Value $Form.FindName($_.Name)}
 
Function Get-FormVariables{
if ($global:ReadmeDisplay -ne $true){Write-host "If you need to reference this display again, run Get-FormVariables" -ForegroundColor Yellow;$global:ReadmeDisplay=$true}
write-host "Found the following interactable elements from our form" -ForegroundColor Cyan
get-variable WPF*
}
 
Get-FormVariables

#===========================================================================
# Script variables
#===========================================================================

# Handle scopes array to pull IP and other values
$Script:DHCPScopes = $null

$Script:SelectedDHCP = $null
$Script:SelectedScope = $null
$Script:SelectedPrintServer = $null
$Script:RoomNumber   = $null
$Script:NewPrinterIP = $null
$Script:OldPrinterIP = $null

$Script:Site = $null

$Script:NewPrinterLease = $null
$Script:OldPrinterReservation = $null

$Script:NewPrinter = $null
$Script:OldPrinter = $null

$Script:PrintModelArray = @()
$Script:PrintShorthandArray = @()
$Script:PrintDriverArray = @()

$Script:PrintModel = $null
$Script:PrintDriver = $null
$Script:PrinterName = $null
$Script:PrinterComment = $null

$Script:NewPrinterReservation = $null
$Script:ReservationDescription = $null
$Script:PrinterPort = $null

$Script:SecurityPrinter = $null
$Script:SitesList = #SitesPlaceholder

# Pull domain\name of user running the script for logging features
$User = "$env:userdomain\$env:username"

#===========================================================================
# Script functions
#===========================================================================

Function GetReservationDescription {

    $StrippedRoom = $Script:RoomNumber -replace "^[a-z]{2,3}\-",""
    $SpaceCreated = $StrippedRoom -replace "\-+"," "
    $WordUppercase = (Get-Culture).TextInfo.ToTitleCase($SpaceCreated)
    $Script:ReservationDescription = "$WordUppercase - $Script:PrintModel"
}

Function GetPrinterComment {

    if($Script:ReservationDescription -match "^[0-9]") {
        $Script:PrinterComment = $Script:ReservationDescription -replace "(^[0-9].*)",'Room $0'
    }
    else {
        $Script:PrinterComment = $Script:ReservationDescription
    }
}

Function ClearFields {
    
    param([Int]$ClearScope)

    switch($ClearScope) {

        {$ClearScope -ge 6} {
            $WPFDHCPComboBox.SelectedIndex = 0
            $WPFDHCPComboBox.IsEnabled = $false
            }
        {$ClearScope -ge 5} {
            $WPFScopeComboBox.Items.Clear()
            $WPFScopeComboBox.IsEnabled = $false            
            }
        {$ClearScope -ge 4} {
            $WPFPrintServerComboBox.Items.Clear()
            $WPFPrintServerComboBox.IsEnabled = $false
            }
        {$ClearScope -ge 3} { 
            $WPFPrinterModelComboBox.Items.Clear()
            $WPFPrinterModelComboBox.IsEnabled = $false
            }
        {$ClearScope -ge 2} {
            $WPFDriverComboBox.Items.Clear()
            $WPFDriverComboBox.IsEnabled = $false
            }
        {$ClearScope -ge 1} {
            $WPFRoomTextBox.Text = "Enter {Site}-{Room/Location}"
            $WPFRoomTextBox.IsEnabled = $false
            $WPFNewIPTextBox.Text = "Enter new printer IP address"
            $WPFNewIPTextBox.IsEnabled = $false
            $WPFOldIPTextBox.Text = "Enter old printer IP address"
            $WPFOldIPTextBox.IsEnabled = $false
            $WPFVerifyCheckBox.IsChecked = $false
            $WPFVerifyCheckBox.IsEnabled = $false
            $WPFRoomImageCheck.Visibility = "Hidden"
            $WPFRoomImageX.Visibility = "Hidden"
            $WPFNewIPImageCheck.Visibility = "Hidden"
            $WPFNewIPImageX.Visibility = "Hidden"
            $WPFOldIPImageCheck.Visibility = "Hidden"
            $WPFOldIPImageX.Visibility = "Hidden"
            $WPFReservationNameLabel.Content = ""
            }
        {$ClearScope -ge 0} {
            $WPFCreateButton.IsEnabled = $false
            $WPFVerifyCheckBox.IsChecked = $false
            $WPFVerifyCheckBox.IsEnabled = $false
            $WPFUndoButton.Visibility = "Hidden"
            }
    }
}

Function CreateClicked {

    $WPFCreateButton.IsEnabled = $false
    $WPFVerifyCheckBox.IsEnabled = $false
    $WPFOldIPTextBox.IsEnabled = $false
    $WPFNewIPTextBox.IsEnabled = $false
    $WPFRoomTextBox.IsEnabled = $false
    $WPFDriverComboBox.IsEnabled = $false
    $WPFPrinterModelComboBox.IsEnabled = $false
    $WPFPrintServerComboBox.IsEnabled = $false
    $WPFScopeComboBox.IsEnabled = $false
    $WPFDHCPComboBox.IsEnabled = $false
    $WPFUndoButton.visibility = "Visible"

}

Function GetScopes {

    # Clear existing scope values
    $WPFScopeComboBox.Items.Clear()

    # Pull in list of applicable scopes from the selected DHCP server
    $Script:DHCPScopes = @(Get-DhcpServerv4Scope -ComputerName $Script:SelectedDHCP | Where-Object {$_.Name.Length -eq 3 -and $_.Name -ne "VDI"})

    # Populate the scope combo box with the corresponding scopes
    $WPFScopeComboBox.Items.Add("")
    foreach($Scope in $DHCPScopes) {
        $WPFScopeComboBox.Items.Add($Scope.Name)
        $WPFScopeComboBox.SelectedIndex = 0
    }
}

Function GetPrintServers {

    # Clear existing print server values
    $WPFPrintServerComboBox.Items.Clear()

    # Pull list of print servers from the AD group membership
    $PrintServerList = Get-ADGroupMember -Identity "YCSD Print Servers" | Where-Object {$_.Name -like "$($Script:SelectedScope.Name)-PRINT2"}

    $WPFPrintServerComboBox.Items.Add("")
    foreach($PrintServer in $PrintServerList) {
        $WPFPrintServerComboBox.Items.Add($PrintServer.Name)
        $WPFPrintServerComboBox.SelectedIndex = 0
    }
}

Function ImportModelDriverList {

    # CLEAR EXISTING PRINT MODEL VALUES
    $WPFPrinterModelComboBox.Items.Clear()
    $Script:PrintModelArray = @()
    $Script:PrintShorthandArray = @()
    $Script:PrintDriverArray = @()

    $ModelDriverList = Import-Csv \\Path\PrinterScriptList.csv

    foreach($Set in $ModelDriverList) {
        $Script:PrintModelArray += $Set.ModelName
        $Script:PrintShorthandArray += $Set.Shorthand
        $Script:PrintDriverArray += $Set.DriverName
    }

    $WPFPrinterModelComboBox.Items.Add("")
    foreach($Model in $PrintModelArray) {
        $WPFPrinterModelComboBox.Items.Add($Model)
        $WPFPrinterModelComboBox.SelectedIndex = 0
    }
}

Function VerifyRoom {

    $ValidFormat = $WPFRoomTextBox.Text -match '^[a-z]+(\-([a-z]+|[0-9]+))*$'
    $WPFRoomTextBox.Text -match '(^[a-z]+)'
    $ValidSite = $Script:SitesList.Contains($Matches[0])

    if($ValidFormat -and $ValidSite) {
        $Script:Site = $Matches[0]
        $WPFRoomImageX.Visibility = "Hidden"
        $WPFRoomImageCheck.Visibility = "Visible"
        $Script:RoomNumber = $WPFRoomTextBox.Text.ToLower()
        return $true
    }
    else {
        $WPFRoomImageCheck.Visibility = "Hidden"
        $WPFRoomImageX.Visibility = "Visible"
        return $false
    }
}

Function VerifyNewIP {

    $ValidLease = $null

    # VARIABLE TO MATCH THE FIRST TWO OCTETS OF SCOPE
    $IPSubOctets = $Script:SelectedScope.ScopeId.IPAddressToString -replace "\d+\.\d+$",""  
    $NewIPValid = $WPFNewIPTextBox.Text -match "$IPSubOctets(25[0-5]|2[0-4][0-9]|[01]?[0-9][0-9]?)\.(25[0-5]|2[0-4][0-9]|[01]?[0-9][0-9]?)$"

     # VALIDATION SYMBOL CHECK FOR NEWIPVALID VARIABLE    
    if($NewIPValid) {
        
        # CHECK FOR EXISTING LEASE AT THE NEW IP FIELD ADDRESS
        $ValidLease = Get-DhcpServerv4Lease -ComputerName $Script:SelectedDHCP -IPAddress $WPFNewIPTextBox.Text -ErrorAction SilentlyContinue

        # IF THE LEASE EXISTS, MARK AS VALID
        if($ValidLease -ne $null) {
            $WPFNewIPImageX.Visibility = "Hidden"
            $WPFNewIPImageCheck.Visibility = "Visible"
            $Script:NewPrinterIP = $WPFNewIPTextBox.Text
            # POPULATE SCRIPT VARIABLES FOR NEW LEASE
            $Script:NewPrinterLease = $ValidLease
            return $true
            }
        else {
            $WPFNewIPImageCheck.Visibility = "Hidden"
            $WPFNewIPImageX.Visibility = "Visible"
            return $false
            }
        }
    else {
        $WPFNewIPImageCheck.Visibility = "Hidden"
        $WPFNewIPImageX.Visibility = "Visible"
        return $false
        }
}

Function VerifyOldIP {

    $ValidReservation = $null

    # VARIABLE TO MATCH THE FIRST TWO OCTETS OF SCOPE
    $IPSubOctets = $Script:SelectedScope.ScopeId.IPAddressToString -replace "\d+\.\d+$",""
    $OldIPValid = $WPFOldIPTextBox.Text -match "$IPSubOctets(25[0-5]|2[0-4][0-9]|[01]?[0-9][0-9]?)\.(25[0-5]|2[0-4][0-9]|[01]?[0-9][0-9]?)$"

    if($WPFOldIPTextBox.IsVisible -eq $false) {
        return $true
    }

    if($OldIPValid) { 
        
        # CHECK FOR EXISTING RESERVATION AT THE OLD IP FIELD ADDRESS
        $ValidReservation = Get-DhcpServerv4Reservation -ComputerName $Script:SelectedDHCP -IPAddress $WPFOldIPTextBox.Text -ErrorAction SilentlyContinue

        # UPDATES THE RESERVATIONNAMELABEL WITH THE NAME IF INPUT IS VALID
        if($ValidReservation -ne $null) {
            $Script:OldPrinter = Get-Printer -ComputerName $Script:SelectedPrintServer | Where-Object {$_.PortName -eq $WPFOldIPTextBox.Text}
            $WPFReservationNameLabel.Content = "Name: $($Script:OldPrinter.Name)"
            }
        else {
            $WPFReservationNameLabel.Content = ""
            }

        # IF THE RESERVATION EXISTS, MARK AS VALID
        if($ValidReservation -ne $null){ # -and ($ValidReservation.Name -eq $Script:RoomNumber)) COMMENTED OUT TO TEST FUNCTIONALITY WITHOUT FORCING RESERVATION NAME MATCHING
            $WPFOldIPImageX.Visibility = "Hidden"
            $WPFOldIPImageCheck.Visibility = "Visible"
            $Script:OldPrinterIP = $WPFOldIPTextBox.Text
            # POPULATE SCRIPT VARIABLES FOR OLD RESERVATION
            $Script:OldPrinterReservation = $ValidReservation
            return $true
            }
        else {
            $WPFOldIPImageCheck.Visibility = "Hidden"
            $WPFOldIPImageX.Visibility = "Visible"
            return $false
            }
        }
    else {
        $WPFOldIPImageCheck.Visibility = "Hidden"
        $WPFOldIPImageX.Visibility = "Visible"
        return $false
        }
}

Function VerifyInputData {

    # VARIABLES TO CHECK IF ALL INPUT IS VALID AND IN DHCP
    $RoomContinue = VerifyRoom
    $NewIPContinue = VerifyNewIP
    $OldIPContinue = VerifyOldIP

    if($RoomContinue -and $NewIPContinue -and $OldIPContinue) {

        $Script:PrinterName = "$Script:RoomNumber".ToLower()
        
        # IF NEW PRINTER RADIO IS SELECTED
        if($WPFNewRadio.IsChecked -eq $true) {
            $WPFGuideTextBlock.Text = "A new printer with the following information will be created on $Script:SelectedPrintServer`nNew Printer IP: $Script:NewPrinterIP`nNew Printer Model: $Script:PrintModel`nNew Printer Name: $Script:PrinterName"
            }

        # IF REPLACE PRINTER RADIO IS SELECTED
        if($WPFReplaceRadio.IsChecked -eq $true) {
            # POPULATE SCRIPT VARIABLE FOR OLDPRINTER WITH THE ORIGINAL PRINTER OBJECT
            $Script:OldPrinter = Get-Printer -ComputerName $Script:SelectedPrintServer | Where-Object {$_.PortName -eq $Script:OldPrinterIP}
            $WPFGuideTextBlock.Text = "The DHCP reservation for printer [$($Script:OldPrinter.Name)] will be updated for the new printer's MAC address`nNew Printer IP: $Script:NewPrinterIP`nNew Printer MAC: $($Script:NewPrinterLease.ClientId)`nVerify this information is correct, and select the checkbox to the right before clicking to create"
            }

        # IF UPDATE PRINTER RADIO IS SELECTED
        if($WPFUpdateRadio.IsChecked -eq $true) {
            $Script:OldPrinter = Get-Printer -ComputerName $Script:SelectedPrintServer | Where-Object {$_.PortName -eq $Script:OldPrinterIP}
            $WPFGuideTextBlock.Text = "The printer [$($Script:OldPrinter.Name)] will be replaced by printer [$Script:PrinterName]`nVerify this information is correct, and select the checkbox to the right before clicking to create"
            }

        # ENABLE CREATE BUTTON
        $WPFVerifyCheckBox.IsEnabled = $true
    }
}

Function NewReservation {
    GetReservationDescription
    Add-DhcpServerv4Reservation -ComputerName $Script:SelectedDHCP -ScopeId $Script:SelectedScope.ScopeId -IPAddress $Script:NewPrinterIP -ClientId $Script:NewPrinterLease.ClientId -Name $Script:PrinterName -Description $Script:ReservationDescription
    $Script:NewPrinterReservation = Get-DhcpServerv4Reservation -ComputerName $Script:SelectedDHCP -IPAddress $Script:NewPrinterIP
}

Function NewPrinter {
    GetPrinterComment
    $Script:SecurityPrinter = Get-Printer -ComputerName "sbo-print2" -Name "SecuritySettings-$Script:Site" -Full
    Add-PrinterPort -Name $Script:NewPrinterIP -ComputerName $Script:SelectedPrintServer -PrinterHostAddress $Script:NewPrinterIP
    $Script:PrinterPort = Get-PrinterPort -ComputerName $Script:SelectedPrintServer -Name $Script:NewPrinterIP
    Add-Printer -Name $Script:PrinterName -Comment $Script:PrinterComment -DriverName $Script:PrintDriver -PortName $Script:NewPrinterIP -ComputerName $Script:SelectedPrintServer -ShareName $Script:PrinterName -Shared
    Set-Printer -ComputerName $Script:SelectedPrintServer -Name $Script:PrinterName -PermissionSDDL $Script:SecurityPrinter.PermissionSDDL
    $Script:NewPrinter = Get-Printer -ComputerName $Script:SelectedPrintServer -Name $Script:PrinterName
}

Function UpdateReservation {
    Set-DhcpServerv4Reservation -ComputerName $Script:SelectedDHCP -IPAddress $Script:OldPrinterReservation.IPAddress -ClientId $Script:NewPrinterLease.ClientId -Name $Script:PrinterName
}

Function UpdatePrinter {
    GetPrinterComment
    $Script:PrinterPort = Get-PrinterPort -ComputerName $Script:SelectedPrintServer -Name $Script:OldPrinterIP
    $Script:SecurityPrinter = Get-Printer -ComputerName $Script:SelectedPrintServer -Full | Where-Object {$_.PortName -eq $script:PrinterPort.Name}
    Remove-Printer -ComputerName $Script:SelectedPrintServer -Name $Script:SecurityPrinter.Name
    Add-Printer -Name $Script:PrinterName -Comment $Script:PrinterComment -DriverName $Script:PrintDriver -PortName $Script:PrinterPort.Name -ComputerName $Script:SelectedPrintServer -ShareName $Script:PrinterName -Shared
    Set-Printer -ComputerName $Script:SelectedPrintServer -Name $Script:PrinterName -PermissionSDDL $Script:SecurityPrinter.PermissionSDDL
    $Script:NewPrinter = Get-Printer -ComputerName $Script:SelectedPrintServer -Name $Script:PrinterName -Full
}
 
#===========================================================================
# Actually make the objects work
#===========================================================================

# Populate the GuideTextBlock with initial instructions
$WPFGuideTextBlock.Text = "Please select the radio button for your desired operation. `n`nIf you are replacing or updating a printer, print a test page from the currently installed printer to find it's IP address."

# Populate the DHCPComboBox with the list of DHCP servers
$ServerList = Get-DhcpServerInDC
$WPFDHCPComboBox.Items.Add("")
foreach ($Server in $ServerList){
    $WPFDHCPComboBox.Items.Add($Server.DnsName)
}

###################
# ADD NEW PRINTER #
###################
$WPFNewRadio.Add_Checked({

    # Standard data field clearing
    ClearFields(6)

    # Adjust field visibility for different script functions
    $WPFOldIPLabel.Visibility = "Hidden"
    $WPFOldIPTextBox.Visibility = "Hidden"
    $WPFPrinterModelLabel.Visibility = "Visible"
    $WPFPrinterModelComboBox.Visibility = "Visible"
    $WPFDriverLabel.Visibility = "Visible"
    $WPFDriverComboBox.Visibility = "Visible"

    # Enable the dropdown box and update the GuideTextBlock with the next set of instructions
    $WPFGuideTextBlock.Text = "Please select a DHCP server from the drop down box. `n- This should correspond to the school you're installing the printer for."
    $WPFDHCPComboBox.IsEnabled = $true
    })

###########################
# UPDATE EXISTING PRINTER #
###########################
$WPFUpdateRadio.Add_Checked({

    # Standard data field clearing
    ClearFields(6)

    # Adjust field visibility for different script functions
    $WPFOldIPLabel.Visibility = "Visible"
    $WPFOldIPTextBox.Visibility = "Visible"
    $WPFPrinterModelLabel.Visibility = "Visible"
    $WPFPrinterModelComboBox.Visibility = "Visible"
    $WPFDriverLabel.Visibility = "Visible"
    $WPFDriverComboBox.Visibility = "Visible"
    
    # Enable the dropdown box and update the GuideTextBlock with the next set of instructions
    $WPFGuideTextBlock.Text = "Please select a DHCP server from the drop down box. `n- This should correspond to the school you're installing the printer for."
    $WPFDHCPComboBox.IsEnabled = $true
})

############################
# REPLACE EXISTING PRINTER #
############################
$WPFReplaceRadio.Add_Checked({

    # Standard data field clearing
    ClearFields(6)

    # Adjust field visibility for different script functions
    $WPFOldIPLabel.Visibility = "Visible"
    $WPFOldIPTextBox.Visibility = "Visible"
    $WPFPrinterModelLabel.Visibility = "Hidden"
    $WPFPrinterModelComboBox.Visibility = "Hidden"
    $WPFDriverLabel.Visibility = "Hidden"
    $WPFDriverComboBox.Visibility = "Hidden"

    # Enable the dropdown box and update the GuideTextBlock with the next set of instructions
    $WPFGuideTextBlock.Text = "Please select a DHCP server from the drop down box. `n- This should correspond to the school you're installing the printer for."
    $WPFDHCPComboBox.IsEnabled = $true
})

###############################
# SELECT DHCP SERVER DROPDOWN #
###############################
$WPFDHCPComboBox.Add_SelectionChanged({

    # Standard data field clearing
    ClearFields(5)
    $WPFGuideTextBlock.Text = "Please select a DHCP server from the drop down box. `n- This should correspond to the school you're installing the printer for."

    if($WPFDHCPComboBox.SelectedIndex -gt 0) {

        # Set the DHCP variable
        $Script:SelectedDHCP = $WPFDHCPComboBox.SelectedValue

        # Populate and enable the scopes combo box
        GetScopes
        $WPFScopeComboBox.IsEnabled = $true

        # Update to the next step in the guide block
        $WPFGuideTextBlock.Text = "Please select a scope from the drop down box. `n- This should correspond to the print server you're installing the printer for."
    }
})

#########################
# SELECT SCOPE DROPDOWN #
#########################
$WPFScopeComboBox.Add_SelectionChanged({

    # Standard data field clearing
    ClearFields(4)
    $WPFGuideTextBlock.Text = "Please select a scope from the drop down box. `n- This should correspond to the print server you're installing the printer for."

    if($WPFScopeComboBox.SelectedIndex -gt 0) {

        # Set SelectedScope variable to the scope from the dropdown (-1 index is to make up for the blank space)
        $Script:SelectedScope = $Script:DHCPScopes[$WPFScopeComboBox.SelectedIndex-1]

        GetPrintServers
        $WPFPrintServerComboBox.IsEnabled = $true

        # Update to the next step in the guide block
        $WPFGuideTextBlock.Text = "Please select the print server you will be installing the printer on."
    }
})

################################
# SELECT PRINT SERVER DROPDOWN #
################################

$WPFPrintServerComboBox.Add_SelectionChanged({

    # Standard data field clearing
    ClearFields(3)
    $WPFGuideTextBlock.Text = "Please select the print server you will be installing the printer on." 
    
    if($WPFPrintServerComboBox.SelectedIndex -gt 0) {
        
        $Script:SelectedPrintServer = $WPFPrintServerComboBox.SelectedValue
        Write-Host "PrintServer $Script:SelectedPrintServer"

        #IF ADD PRINTER IS SELECTED
        if($WPFNewRadio.IsChecked) {

            ImportModelDriverList
            $WPFPrinterModelComboBox.IsEnabled = $true

            # Update to the next step in the guide block
            $WPFGuideTextBlock.Text = "Please select the model of printer you will be installing on the print server."
        }

        #IF REPLACE PRINTER IS SELECTED
        if($WPFReplaceRadio.IsChecked) {
            
            # Populate and enable the text fields combo boxes
            $WPFRoomTextBox.Clear()
            $WPFRoomTextBox.IsEnabled = $true
            $WPFNewIPTextBox.Text = $Script:SelectedScope.ScopeId.IPAddressToString -replace "\d+\.\d+$",""
            $WPFNewIPTextBox.IsEnabled = $true
            $WPFOldIPTextBox.Text = $Script:SelectedScope.ScopeId.IPAddressToString -replace "\d+\.\d+$",""
            $WPFOldIPTextBox.IsEnabled = $true

            # Update to the next step in the guide block
            $WPFRoomImageX.Visibility = "Visible"
            $WPFNewIPImageX.Visibility = "Visible"
            $WPFOldIPImageX.Visibility = "Visible"
            $WPFGuideTextBlock.Text = "Fill out the following fields (The IP address fields have been partially populated for your selected scope):`n- Printer Name ({Site}-{Room/Location}, i.e. tms-300 or tms-ap or tms-guid-copier)`n- New Printer IP`n- Old Printer IP (From the test page printed at the start)`nNote: At this point, you may connect the new printer to the network to find the IP."
        }

        #IF UPDATE PRINTER IS SELECTED
        if($WPFUpdateRadio.IsChecked) {
        
            ImportModelDriverList
            $WPFPrinterModelComboBox.IsEnabled = $true

            # Update to the next step in the guide block
            $WPFGuideTextBlock.Text = "Please select the model of printer you will be swapping out with the existing printer."
        }
    }
})

###############################
# SELECT PRINT MODEL DROPDOWN #
###############################

$WPFPrinterModelComboBox.Add_SelectionChanged({

    # Standard data field clearing
    ClearFields(2)
    $WPFGuideTextBlock.Text = "Please select the driver for the selected printer model."

    if($WPFPrinterModelComboBox.SelectedIndex -gt 0){

        # POPULATE THE PRINTMODEL AND PRINTDRIVER VARIABLES
        $Script:PrintModel = $WPFPrinterModelComboBox.SelectedValue
        $Script:PrintShorthand = $Script:PrintShorthandArray[$WPFPrinterModelComboBox.SelectedIndex-1]
        $Script:PrintDriver = $Script:PrintDriverArray[$WPFPrinterModelComboBox.SelectedIndex-1].ToString()

        # POPULATE THE DRIVERCOMBOBOX WITH THE PROPER DRIVERS

        $WPFDriverComboBox.Items.Add("")
        $WPFDriverComboBox.Items.Add($Script:PrintDriver)
        $WPFDriverComboBox.SelectedIndex = 0
        $WPFDriverComboBox.IsEnabled = $true
    }
})

################################
# SELECT PRINT DRIVER DROPDOWN #
################################

$WPFDriverComboBox.Add_SelectionChanged({

    # Standard data field clearing
    ClearFields(1)

    if($WPFDriverComboBox.SelectedIndex -gt 0) {

        #IF ADD PRINTER IS SELECTED
        if($WPFNewRadio.IsChecked) {

            # Populate and enable the text fields combo boxes
            $WPFRoomTextBox.Clear()
            $WPFRoomTextBox.IsEnabled = $true
            $WPFNewIPTextBox.Text = $Script:SelectedScope.ScopeId.IPAddressToString -replace "\d+\.\d+$",""
            $WPFNewIPTextBox.IsEnabled = $true

            # Update to the next step in the guide block
            $WPFRoomImageX.Visibility = "Visible"
            $WPFNewIPImageX.Visibility = "Visible"
            $WPFGuideTextBlock.Text = "Fill out the following fields (The IP address fields have been partially populated for your selected scope):`n- Printer Name ({Site}-{Room/Location}, i.e. tms-300 or tms-ap or tms-guid-copier)`n- New Printer IP`nNote: At this point, you may connect the new printer to the network to find the IP."
        }

        #IF UPDATE PRINTER IS SELECTED
        if($WPFUpdateRadio.IsChecked) {

            # Populate and enable the text fields combo boxes
            $WPFRoomTextBox.Clear()
            $WPFRoomTextBox.IsEnabled = $true
            $WPFNewIPTextBox.Text = $Script:SelectedScope.ScopeId.IPAddressToString -replace "\d+\.\d+$",""
            $WPFNewIPTextBox.IsEnabled = $true
            $WPFOldIPTextBox.Text = $Script:SelectedScope.ScopeId.IPAddressToString -replace "\d+\.\d+$",""
            $WPFOldIPTextBox.IsEnabled = $true
        }
    }
})

#########################
# FOCUS ON ROOM TEXTBOX #
#########################

$WPFRoomTextBox.Add_GotFocus({

    # PLACES FOCUS AFTER TEXT
    $WPFRoomTextBox.CaretIndex = $WPFRoomTextBox.Text.Length

})

########################
# TYPE IN ROOM TEXTBOX #
########################

$WPFRoomTextBox.Add_TextChanged({
    
    # STANDARD DATA FIELD CLEARING
    ClearFields(0)

    # RESET TEXT BLOCK IN CASE INFORMATION IS CHANGED TO INVALID
    $WPFGuideTextBlock.Text = "Fill out the following fields (The IP address fields have been partially populated for your selected scope):`n- Printer Name ({Site}-{Room/Location}, i.e. tms-300 or tms-ap or tms-guid-copier)`n- New Printer IP`n- Old Printer IP (From the test page printed at the start)`nNote: At this point, you may connect the new printer to the network to find the IP."
    VerifyInputData
})

##########################
# FOCUS ON NEWIP TEXTBOX #
##########################

$WPFNewIPTextBox.Add_GotFocus({
    # PLACES FOCUS AFTER TEXT
    $WPFNewIPTextBox.CaretIndex = $WPFNewIPTextBox.Text.Length
})

#########################
# TYPE IN NEWIP TEXTBOX #
#########################

$WPFNewIPTextBox.Add_TextChanged({

    # STANDARD DATA FIELD CLEARING
    ClearFields(0)

    # RESET TEXT BLOCK IN CASE INFORMATION IS CHANGED TO INVALID
    $WPFGuideTextBlock.Text = "Fill out the following fields (The IP address fields have been partially populated for your selected scope):`n- Printer Name ({Site}-{Room/Location}, i.e. tms-300 or tms-ap or tms-guid-copier)`n- New Printer IP`n- Old Printer IP (From the test page printed at the start)`nNote: At this point, you may connect the new printer to the network to find the IP."
    VerifyInputData
})

##########################
# FOCUS ON OLDIP TEXTBOX #
##########################

$WPFOldIPTextBox.Add_GotFocus({
    # PLACES FOCUS AFTER TEXT
    $WPFOldIPTextBox.CaretIndex = $WPFOldIPTextBox.Text.Length
})

#########################
# TYPE IN OLDIP TEXTBOX #
#########################

$WPFOldIPTextBox.Add_TextChanged({
    
    # STANDARD DATA FIELD CLEARING
    ClearFields(0)

    # RESET TEXT BLOCK IN CASE INFORMATION IS CHANGED TO INVALID
    $WPFGuideTextBlock.Text = "Fill out the following fields (The IP address fields have been partially populated for your selected scope):`n- Printer Name ({Site}-{Room/Location}, i.e. tms-300 or tms-ap or tms-guid-copier)`n- New Printer IP`n- Old Printer IP (From the test page printed at the start)`nNote: At this point, you may connect the new printer to the network to find the IP."
    VerifyInputData
})

########################
# CHECK VERIFYCHECKBOX #
########################

$WPFVerifyCheckBox.Add_Checked({
    $WPFCreateButton.IsEnabled = $true
})

##########################
# UNCHECK VERIFYCHECKBOX #
##########################

$WPFVerifyCheckBox.Add_Unchecked({
    $WPFCreateButton.IsEnabled = $false
})

######################
# CLICK CREATEBUTTON #
######################

$WPFCreateButton.Add_Click({


    # CHECK FOR/SET UP EVENT LOG ON SELECTED PRINT SERVER
    Invoke-Command -ComputerName $Script:SelectedPrintServer -ScriptBlock {
        if([System.Diagnostics.EventLog]::SourceExists('Printer Script') -eq $false){
            New-EventLog -LogName Application -Source "Printer Script"
        }
    }
    
    # IF NEW PRINTER RADIO IS SELECTED
    if($WPFNewRadio.IsChecked) {
        NewReservation
        NewPrinter
        $WPFGuideTextBlock.Text = "The selected action has been performed`n`nIf you made any mistakes filling out the information, you may click the Undo Action button at the top"
        CreateClicked
        Write-EventLog -ComputerName $Script:SelectedPrintServer -LogName Application -Source "Printer Script" -EntryType Information -EventId 1 -Message "$User added a new printer to $Script:SelectedPrintServer `n- Printer Name: $Script:PrinterName `n- IP Address: $Script:NewPrinterIP"
    }
    # IF REPLACE PRINTER RADIO IS SELECTED
    if($WPFReplaceRadio.IsChecked) {
        UpdateReservation
        $WPFGuideTextBlock.Text = "The selected action has been performed, restart the new printer to allow the DHCP reservation to assign the new IP address`n`nIf you made any mistakes filling out the information, you may click the Undo Action button at the top"
        CreateClicked
        Write-EventLog -ComputerName $Script:SelectedPrintServer -LogName Application -Source "Printer Script" -EntryType Information -EventId 2 -Message "$User replaced a printer on $Script:SelectedPrintServer with the same model `n- Printer Name: $Script:PrinterName `n- IP Address: $Script:NewPrinterIP"
    }
    #IF UPDATE PRINTER RADIO IS SELECTED
    if($WPFUpdateRadio.IsChecked) {
        UpdateReservation
        UpdatePrinter
        $WPFGuideTextBlock.Text = "The selected action has been performed`n`nIf you made any mistakes filling out the information, you may click the Undo Action button at the top"
        CreateClicked
        Write-EventLog -ComputerName $Script:SelectedPrintServer -LogName Application -Source "Printer Script" -EntryType Information -EventId 3 -Message "$User replaced printer $($Script:OldPrinter.Description) on $Script:SelectedPrintServer with a different model `n- Replacement Printer Name: $Script:PrinterName `n- IP Address: $($Script:NewPrinter.PortName)"
    }
})

####################
# CLICK UNDOBUTTON #
####################

$WPFUndoButton.Add_Click({
    
    # IF NEW PRINTER RADIO IS SELECTED
    if($WPFNewRadio.IsChecked) {
        Remove-Printer -ComputerName $Script:SelectedPrintServer -Name $Script:PrinterName
        Remove-PrinterPort -ComputerName $Script:SelectedPrintServer -Name $Script:NewPrinterIP
        Remove-DhcpServerv4Reservation -ComputerName $script:SelectedDHCP -IPAddress $script:NewPrinterIP
        $WPFGuideTextBlock.Text = "The previously added printer has now been removed from the server`n`nYou may close the script, or select a different radio button perform a new operation"
        Write-EventLog -ComputerName $Script:SelectedPrintServer -LogName Application -Source "Printer Script" -EntryType Information -EventId 4 -Message "$User undid the previous printer creation."
    }
    # IF REPLACE PRINTER RADIO IS SELECTED
    if($WPFReplaceRadio.IsChecked) {
        Set-DhcpServerv4Reservation -ComputerName $Script:SelectedDHCP -IPAddress $Script:OldPrinterReservation.IPAddress -ClientId $Script:OldPrinterReservation.ClientId
        $WPFGuideTextBlock.Text = "The previous DHCP reservation change has been reverted to it's original state`n`nYou may close the script, or select a different radio button perform a new operation"
                Write-EventLog -ComputerName $Script:SelectedPrintServer -LogName Application -Source "Printer Script" -EntryType Information -EventId 4 -Message "$User undid the previous printer replacement."
    }
    # IF UPDATE PRINTER RADIO IS SELECTED
    if($WPFUpdateRadio.IsChecked) {
        Set-DhcpServerv4Reservation -ComputerName $Script:SelectedDHCP -IPAddress $Script:OldPrinterReservation.IPAddress -ClientId $Script:OldPrinterReservation.ClientId -Name $Script:OldPrinterReservation.Name
        Remove-Printer -ComputerName $Script:SelectedPrintServer -Name $Script:NewPrinter.Name
        Add-Printer -Name $Script:SecurityPrinter.Name -DriverName $Script:SecurityPrinter.DriverName -PortName $Script:SecurityPrinter.PortName -ComputerName $Script:SelectedPrintServer -ShareName $Script:SecurityPrinter.Name -Shared
        Set-Printer -ComputerName $Script:SelectedPrintServer -Name $Script:SecurityPrinter.Name -PermissionSDDL $Script:SecurityPrinter.PermissionSDDL 
        $WPFGuideTextBlock.Text = "The previously added printer has now been removed from the server, and the original printer re-added`n`nYou may close the script, or select a different radio button perform a new operation"
                Write-EventLog -ComputerName $Script:SelectedPrintServer -LogName Application -Source "Printer Script" -EntryType Information -EventId 4 -Message "$User undid the previous printer update."
    }

    $WPFUndoButton.Visibility = "Hidden"
})

#===========================================================================
# Shows the form
#===========================================================================
$Form.ShowDialog() | out-null