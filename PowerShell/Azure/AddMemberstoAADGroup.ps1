Connect-AzureAD

$Groups = "Azure Groups Placeholder"

## Group ID for Intune-W10-Student Group
$IntuneW10Student = "Group ID"

Foreach($Group in $Groups)

{$GroupID = Get-AzureADGroup -Filter "DisplayName eq '$Group'" | Select-Object ObjectID

Add-AzureADGroupMember -ObjectId $IntuneW10Student -RefObjectId $GroupID.ObjectId

}