#Dell Bios Powershell Provider
#version 2.1
#copy to image before using
#7-19-18

$ScriptHome = "\\Path\netlogon\biosConfig"
$UpdateHost = hostname
$Log = "\\Path\svcpcupdate\biosupdate"

Start-Transcript -Path $Log\$UpdateHost-bios.txt -Append

Import-Module DellBIOSProvider

Set-Item DellSmbios:\BootSequence\BootList UEFI -Password #Password
Set-Item DellSmbios:\AdvancedBootOptions\LegacyOrom	Disabled -Password #Password
Set-Item DellSmbios:\SystemConfiguration\EmbNic1 EnabledPxe -Password #Password
Set-Item DellSmbios:\SystemConfiguration\UefiNwStack	Enabled -Password #Password
Set-Item DellSmbios:\PowerManagement\WakeOnLan	LanWithPxeBoot -Password #Password
Set-Item DellSmbios:\PowerManagement\BlockSleep	Enabled -Password #Password
Set-Item DellSmbios:\VirtualizationSupport\Virtualization	Enabled -Password #Password
Set-Item DellSmbios:\VirtualizationSupport\VtForDirectIo	Enabled -Password #Password
Set-Item DellSmbios:\Wireless\WirelessLan	Disabled -Password #Password
Set-Item DellSmbios:\Wireless\BluetoothDevice	Disabled -Password #Password
Set-Item DellSmbios:\BootSequence\BootSequence 2 -Password #Password