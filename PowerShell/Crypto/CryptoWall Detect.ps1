##################################################
# CryptoWall infection detect                    #
#                                                #
# Use: Detects directories infected by the       #
#      CryptoWall ransomware                     #
#                                                #
# Author: Matt Varnell                           #
##################################################

# Array of data directory acronyms
$schools = #SchoolsPlaceholder

# Loop through each data share to search for the DECRYPT_INSTRUCTION.TXT file
foreach ($school in $schools) {

    $base = "\\$school-share\data"
    $infected = @()

    Write-Host -NoNewline "Now scanning $base`:"

    $infected = Get-ChildItem "$base" -Recurse -Filter DECRYPT_INSTRUCTION.TXT | split-path
    
    Write-Host $infected[0]
    Write-Host $infected[1]
    }