## Connect to Azure AD Tenant
Connect-AzureAD
## List of groups to modify (REMOVEDFOR SANITIZING
## 8-19-19 $Groups =
## 8-21-19 $Groups = 
$Group = "Group Placeholder"
Foreach($Group in $Groups)
{ 
## Construct rule based on Group Name. Split at each - and create format site-groupname
$split = $group.Split("-")
$DeviceDisplayname = $split[2]+"-"+$split[3]+"-"
## look up Group in Azure AD to get Object ID to modify
$groupid = Get-AzureADMSGroup -Filter "DisplayName eq '$Group'"
Set-AzureADMSGroup -Id $groupid.id -MembershipRule "(device.displayName -contains ""$DeviceDisplayname"") -and (device.deviceOSType -match ""Windows"")"

## Other options include:
## -MembershipRuleProcessingState "On"} to start evaluating Dynamic Rules
}