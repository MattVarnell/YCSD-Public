# Script to modify a vDisk image without requiring manual booting/modification
#  Updates all specified vDisk versions at all specified sites

$sites = @("#SiteArray")
$models = @("#ModelArray")

foreach ($site in $sites) {
    foreach ($model in $models) {

        #####################################################################
        ###   MODIFY THIS LINE TO REFLECT VDISK NAME YOU WANT TO CHANGE   ###
        #####################################################################
        $vhdpath = "\\$site-#PVSFileshare\#vDiskShare\$model-1903-#Date-#Version.vhdx"

        Mount-DiskImage $vhdpath

        ## Mount Reg Hives:
        reg load HKLM\sysupdate e:\windows\system32\config\system 
        reg load HKLM\sofupdate e:\windows\system32\config\software


        #############################################################################################
        ###   REGISTRY MODIFICATION DONE IN THIS SECTION. DO NOT MODIFY OUTSIDE OF THIS SECTION   ###
        #############################################################################################


        ### Adds font into the image
        <#
        $objFolder = '\\Path\Fonts'
        $objShell = New-Object -ComObject Shell.Application
        $destination = 'D:\Windows\Fonts'
        $fontFolder = $objShell.namespace($objFolder)
        $regPath = "HKLM:\sofupdate\Microsoft\Windows NT\CurrentVersion\Fonts"

        foreach ($file in $fontFolder.items()) {

            $fileType = $($fontFolder.getDetailsOf($file, 2))
            $fontName = $($fontFolder.getDetailsOf($File, 21))
            $regKeyName = $fontName,$openType -join " "
            $regKeyValue = $file.Name
            Write-Output "$installLabel : $regKeyValue"
            Copy-Item $file.Path  $destination
            New-ItemProperty -Path $regPath -Name $regKeyname -Value $regKeyValue -PropertyType String -Force
        }
        #>

        ## Change Server Path   
        Set-ItemProperty -Path 'HKLM:\sofupdate\FSLogix\Profiles\ObjectSpecific\#SID' -Name 'VHDLocations' -Value '\\Path\Profiles\'
        Set-ItemProperty -Path 'HKLM:\sofupdate\Policies\FSLogix\ODFC\ObjectSpecific\#SID' -Name 'VHDLocations' -Value '\\Path\Profiles\'


        #Set-ItemProperty -Path 'HKLM:\sysupdate\ControlSet001\Services\EventLog\Application' -Name 'File' -Value 'D:\Citrix\Logs\Application.evtx' 

        #Move FSLogix Admin log to the D: drive
        #try {
            #Set-ItemProperty -Path 'HKLM:\sofupdate\Microsoft\Windows\CurrentVersion\WINEVT\Channels\FSLogix-Apps/Admin' -Name 'File' -Value 'D:\Citrix\Logs\FSLogix-Apps%4Admin.evtx'

        #}
        #catch {
            #New-ItemProperty -Path 'HKLM:\sofupdate\Microsoft\Windows\CurrentVersion\WINEVT\Channels\FSLogix-Apps/Admin' -Name 'File' -Value 'D:\Citrix\Logs\FSLogix-Apps%4Admin.evtx' -PropertyType 'String'
        #}


        #######################################################################################
        ###   END OF REGISTRY MODIFICATION SECTION. DO NOT MODIFY OUTSIDE OF THIS SECTION   ###
        #######################################################################################


        ## Run Garbage Collection
        [gc]::collect()

        ## Unload Hives
        reg unload HKLM\sysupdate
        reg unload HKLM\sofupdate

        Dismount-DiskImage -ImagePath $vhdpath

    }
}