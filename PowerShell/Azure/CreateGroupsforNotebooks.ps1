## This script will create Azure AD groups to manage Student Notebooks in Intune.
## It requires the AzureADPreview module
## install-module AzureADPreview.

## Previous Groups created. These are the groups created with the script so far. Logging them here since we don't have another location at the moment. (GROUPS REMOVED FOR SANITIZING)
## 8-19-19 $Groups = 
## 8-21-19 $Groups = 
## 10-25-19 $Groups = 
## 10-25-19 $Groups = 
## 10-30-19 $Groups = 
## 10-30-19 $groups = 
## 11-05-19 $Groups = 
## 10-31-19 $groups = 
## 11-07-19 $groups = 

Connect-AzureAD
$Groups = "Group List Placeholder"

Foreach ($Group in $Groups) {
    $split = $group.Split("-")

    $DeviceDisplayname = $split[2] + "-" + $split[3] + "-"
    $NewGroup = New-AzureADMSGroup -DisplayName $Group -Description "Dynamic group created from PS" -MailEnabled $False -MailNickName $False -SecurityEnabled $True -GroupTypes "DynamicMembership" -MembershipRule "(device.displayName -contains ""$DeviceDisplayname"") -and (device.deviceOSType -match ""Windows"")" -MembershipRuleProcessingState "On"
    Add-AzureADGroupMember -ObjectId "ObjectId Placeholder" -RefObjectId $NewGroup.id 
}