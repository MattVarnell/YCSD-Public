## This requires the Azure AD Preview Powershell module
## You can install it with install-module azureadpreview

$Groups= "Groups Placeholder"

Connect-AzureAD

Foreach($Group in $Groups){
## { $split = $group.Split("-")
$GroupName = "Intune"+"-"+$Group

New-AzureADMSGroup -DisplayName $GroupName -Description "Dynamic group created from PS for Stem iPads" -MailEnabled $False -MailNickName $False -SecurityEnabled $True -GroupTypes "DynamicMembership" -MembershipRule "(device.displayName -startswith ""$Group"") -and (device.deviceManufacturer -match ""Apple"") -and (device.deviceModel -notContains ""iPod"")" -MembershipRuleProcessingState "On"}