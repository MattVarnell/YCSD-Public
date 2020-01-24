$WakeonMagic =  Get-NetAdapterAdvancedProperty | Where-Object {$_.Displayname -Like "*Magic Packet*"}
$11WakeonMagic =  Get-NetAdapterAdvancedProperty | Where-Object {$_.Displayname -Like "CJ11111*"}
$wakeOnPacket = Get-NetAdapterAdvancedProperty | Where-Object {$_.Displayname -Like "*Pattern Match*"}
$ArpOffload = Get-NetAdapterAdvancedProperty | Where-Object {$_.Displayname -Like "*ARP Offload*"}
$NSOffload = Get-NetAdapterAdvancedProperty | Where-Object {$_.Displayname -Like "*NS Offload*"}
$IntMod = Get-NetAdapterAdvancedProperty | Where-Object {$_.Displayname -Like "Interrupt Moderation"}
$EEE = Get-NetAdapterAdvancedProperty | Where-Object {$_.Displayname -Like "*Energy Efficient*"}
$LowPower = Get-NetAdapterAdvancedProperty | Where-Object {$_.Displayname -Like "*Low Power*"}


## Array of Enabled items
$EnableObjects = @($WakeonMagic,$wakeOnPacket,$11WakeonMagic)

## Array of Disabled Items
$DisableObjects = @($ArpOffload,$NSOffload,$IntMod,$EEE,$LowPower)

ForEach ($Object in $EnableObjects){
$Object | Set-NetAdapterAdvancedProperty -RegistryValue 1
}

ForEach ($Object in $DisableObjects){
$Object | Set-NetAdapterAdvancedProperty -RegistryValue 0
}
Write-Output C:\Intel\net.log