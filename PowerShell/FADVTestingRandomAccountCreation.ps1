#ERASE ALL THIS AND PUT XAML BELOW between the @" "@
$inputXML = @"
<Window x:Class="FADV_Assessment_Setup.MainWindow"
        xmlns="http://schemas.microsoft.com/winfx/2006/xaml/presentation"
        xmlns:x="http://schemas.microsoft.com/winfx/2006/xaml"
        xmlns:d="http://schemas.microsoft.com/expression/blend/2008"
        xmlns:mc="http://schemas.openxmlformats.org/markup-compatibility/2006"
        xmlns:local="clr-namespace:FADV_Assessment_Setup"
        mc:Ignorable="d"
        Title="FADV Assessment Setup" Height="200" Width="525" MinWidth="525" MinHeight="200" MaxWidth="525" MaxHeight="200">
    <Grid>
        <Label x:Name="CompLabel" Content="Please select a computer for the assessment:" HorizontalAlignment="Left" Margin="10,30,0,0" VerticalAlignment="Top" Width="245"/>
        <ComboBox x:Name="CompComboBox" Margin="0,30,10,0" VerticalAlignment="Top" Width="245" Height="26" IsReadOnly="True" HorizontalAlignment="Right"/>
        <Button x:Name="CreateButton" Content="Create Account" HorizontalAlignment="Left" Height="70" Margin="45,75,0,0" VerticalAlignment="Top" Width="175"/>
        <Label x:Name="UserLabel" Content="Username:" HorizontalAlignment="Left" Margin="255,81,0,0" VerticalAlignment="Top"/>
        <Label x:Name="PasswordLabel" Content="Password:" HorizontalAlignment="Left" Margin="258,113,0,0" VerticalAlignment="Top"/>
        <Label x:Name="UserField" Content="" HorizontalAlignment="Left" Margin="326,81,0,0" VerticalAlignment="Top"/>
        <Label x:Name="PassField" Content="" HorizontalAlignment="Left" Margin="326,113,0,0" VerticalAlignment="Top"/>
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
# Script Variables
#===========================================================================

$Script:Password = $null


#===========================================================================
# Script Functions
#===========================================================================

Function GetComputers {

    $CompList = Get-ADGroupMember -Identity "Computer Group Placeholder" | Sort

    $WPFCompComboBox.Items.Add("")
    foreach($Comp in $CompList) {
        $WPFCompComboBox.Items.Add($Comp.Name)
        $WPFCompComboBox.SelectedIndex = 0
    }
}

Function DisableForm {
    
    $WPFCompComboBox.IsEnabled = $false
    $WPFCreateButton.IsEnabled = $false
}

Function RandomPassword {

    $MinLength = 8

    $Sites = @("SiteListPlaceholder")
    $Numbers = @(0..9)
    $Chars = @("!","@","#","$","&","*")

    $Site = Get-Random -InputObject $Sites
    $Number = Get-Random -InputObject $Numbers
    $Char = Get-Random -InputObject $Chars

    $Password = "$Site" + "$Number"

    while($Password.Length -ilt $MinLength){
        $Password = $Password + (Get-Random -InputObject $Numbers).ToString()
    }

    $Script:Password = $Password + "$Char"
}

Function CopyShortcut {

    Copy-Item -Path "\\Path\FADV Script\FADV Assessment.lnk" -Destination "\\$($WPFCompComboBox.SelectedValue)\c$\Users\Public\Desktop"
}

Function CreateLogin {

    $SelectedComp = $WPFCompComboBox.SelectedValue

    $ADSIComp = [ADSI]"WinNT://$SelectedComp"

    $Username = "FADVUser"

    $NewUser = $ADSIComp.Create('User',$Username)

    #Create password 
    $Password = ConvertTo-SecureString $Script:Password -AsPlainText -Force
    $BSTR = [system.runtime.interopservices.marshal]::SecureStringToBSTR($Password)
    $_password = [system.runtime.interopservices.marshal]::PtrToStringAuto($BSTR)

    #Set password on account 
    $NewUser.SetPassword(($_password))

    $NewUser.SetInfo()

    #Cleanup 
    [Runtime.InteropServices.Marshal]::ZeroFreeBSTR($BSTR) 
    Remove-Variable Password,BSTR,_password

    $WPFUserField.Content = "$Username"
    $WPFPassField.Content = "$Script:Password"

    CopyShortcut
    DisableForm
}

GetComputers


#===========================================================================
# Make Objects Work
#===========================================================================

######################
# CLICK CREATEBUTTON #
######################
$WPFCreateButton.Add_Click({
   
    $wshell = New-Object -ComObject Wscript.Shell

    if(Test-Connection -Computername $WPFCompComboBox.SelectedValue -BufferSize 16 -Count 1 -Quiet){
        RandomPassword
        try { CreateLogin }
        catch [System.Management.Automation.MethodInvocationException] {
            $wshell.Popup("An account has already been created on $($WPFCompComboBox.SelectedValue)`n`nRestart the computer to clear the account before creating a new one",0,"Script Notice",0x0)
        }
    }
    else {
        $wshell.Popup("$($WPFCompComboBox.SelectedValue) is unable to be reached`n`nPlease verify the computer is turned on and functional",0,"Script Notice",0x0)
    }

})

#===========================================================================
# Shows the form
#===========================================================================
$Form.ShowDialog() | out-null