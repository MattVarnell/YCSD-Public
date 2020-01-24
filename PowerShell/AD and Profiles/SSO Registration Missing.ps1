##################################################
# SSO Student Registration Check                 #
#                                                #
# Use: Creates a list of students who have not   #
#      yet registered their SSO security         #
#      questions                                 #
#                                                #
# Author: Matt Varnell                           #
##################################################

# Array of school acronyms
$schools = #SchoolsListPlaceholder

# Create directory to save spreadsheets if it doesn't exist
$dir = "Y:\SSO Registration"

if (!(Test-Path "$dir")) {
    New-Item -ItemType Directory -Path "$dir" | Out-Null
    }

# Loop through and create an excel document for each school of unregistered students
foreach ($school in $schools) {


    Write-Host -NoNewline "Creating document for $school..."

    # Create arrays and hash tables needed for the program
    $studentArray = @()
    $studentHash  = @{}
    $tkrArray     = @()

    # Create a dynamic script block to get around the -Filter variable issue
    $block        = "(Name -notlike '*-*') -and (Name -notlike '" + $school + "*')"
    $scriptBlock  = [scriptblock]::Create($block)

    # Pull all students (excluding generics) into the student array
    $studentArray = Get-ADUser -Filter $scriptBlock -SearchBase "ou=$school,DC Placeholder Info" -Server "Student DC PlaceholdER" -Properties displayName | Select-Object Name, displayName

    # Goes through the filtered array and creates key-value pairs between IDs and names
    foreach ($student in $studentArray) {

        $studentHash.Add($student.Name, $student.displayName)

        }

    Write-Host -NoNewline "..."

    # Pull all instances of TKR (SSO registered) objects' distinguished names, containing user ID
    $tkrArray = Get-ADObject -Filter {(objectClass -like "citrix-SSOSecret") -and (cn -like "TKR")} -SearchBase "ou=$school,DC Placeholder Info" -Server ystu.ycsd.york.va.us | Select-Object DistinguishedName

    # Filter excess and only hold user ID
    foreach ($tkr in $tkrArray) {

        $tkr -match '.*(\d{6}).*' | Out-Null
        $temp = $matches[1]

        if ($studentHash.ContainsKey($temp)) {

            $studentHash.Remove($temp)

            }

        }

    Write-Host -NoNewline "..."

    $output = $studentHash.GetEnumerator() | foreach{ New-Object PSObject -Property (@{ID = $_.Key; Name = $_.Value})}

    $output | Export-Csv "$dir\$school.csv" -NoTypeInformation

    Write-Host " Done."

    }

Write-Host "Documents are saved in $dir"