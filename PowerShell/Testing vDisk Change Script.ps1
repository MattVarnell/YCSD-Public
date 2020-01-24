# Load required PowerShell Snapins
Add-PSSnapin MCLIPSSnapin

# Set the PVS Server connection
$PVSServer= #PVSServerIPPlaceholder

# Set Actively used vDisk Names
$HSM92CertImg = #CertiportImagePlaceholder
$HSM92InstImg = #CertiportImagePlaceholder
$M92CertImg = #CertiportImagePlaceholder
$M92InstImg = #CertiportImagePlaceholder

# Set Site Variables
$SiteName = #SiteNamePlaceholder
$StoreName = #StoreNamePlaceholder
$317ViewID = "b3d7ef07-b129-49c8-9a44-5a0b12df3b66"
$403ViewID = "cba1375f-28fb-4646-83c3-827d131d2de4"
$404ViewID= "eeea7c3b-1a02-45ef-a6bc-e9e08b3bad09"

# Test Site
$TestSiteName = #TestSiteNamePlaceholder
$TestStoreName = #TestStoreNamePlaceholder
$TestSiteViewID = "f1ebe42b-8b1e-4cc4-b293-7bfe500e3cbc"

# Create an Array Variable
$x = @()

# Load .NET Framework Forms Assemblies
[void] [System.Reflection.Assembly]::LoadWithPartialName("System.Windows.Forms")
[void] [System.Reflection.Assembly]::LoadWithPartialName("System.Drawing") 

# Create a New .NET Dialog Box
$objForm = New-Object System.Windows.Forms.Form 

# Set Dialog Box Title and Properties
$objForm.Text = "Certiport/IC3 Testing Setup"
$objForm.Font = New-Object System.Drawing.Font("Georgia",10,0,3,1)
$objForm.Size = New-Object System.Drawing.Size(300,250) 
$objForm.StartPosition = "CenterScreen"
$objForm.FormBorderStyle = "Fixed3D"


# Create a Radio Button for Testing Image or Classroom Image
$objRadioButton1 = New-Object System.Windows.Forms.RadioButton
$objRadioButton2 = New-Object System.Windows.Forms.RadioButton 
$objRadioButton1.Checked = $False
$objRadioButton1.Name = "Testing"
$objRadioButton1.Text = "Testing Image"
$objRadioButton1.Location = New-Object System.Drawing.Point(10,120)
$objRadioButton1.AutoSize = $true
$objRadioButton2.Checked = $False
$objRadioButton2.Name = "Classroom"
$objRadioButton2.Text = "Instructional Image"
$objRadioButton2.Location = New-Object System.Drawing.Point(10,145)
$objRadioButton2.AutoSize = $true
$objForm.Controls.Add($objRadioButton1)
$objForm.Controls.Add($objRadioButton2)


# Disable Minimize, Maximize and "X" buttons on Dialog Box
$objForm.MinimizeBox = $False
$objForm.MaximizeBox = $False
$objForm.ControlBox = $False

# Allow "ENTER" (for Selection) and "ESCAPE" (Escape) keys
$objForm.KeyPreview = $True
$objForm.Add_KeyDown({if ($_.KeyCode -eq "Enter") {

 foreach ($objItem in $objListbox.SelectedItems)
            {$x += $objItem

               
        if (($objItem -eq 'High School, Room 317') -and ($objRadioButton1.Checked -eq $true)) {
            
            #Get-ADComputer -Filter 'Name -Like "HS-317-*-M92"' | Move-ADObject -TargetPath "OU=HS Staff,DC Placeholder Info"
            
            #$vdisk = MCLI-Run assigndisklocator -p siteviewid=$HS317ViewID,removeExisting=1,disklocatorname=$HSM92CertImg,siteName=$SiteName,Storename=$StoreName
            
            #$TestMsgBox = [System.Windows.Forms.MessageBox]::Show("$objItem selected. Classroom is now ready for Testing!","Testing Setup Complete","OK","Information")

            }


        Elseif (($objItem -eq 'High School, Room 317') -and ($objRadioButton2.Checked -eq $true)) {
            
            #Get-ADComputer -Filter 'Name -Like "HS-317-*-M92"' | Move-ADObject -TargetPath "OU=Lab 317,DC Placeholder Info"
            
            #$vdisk = MCLI-Run assigndisklocator -p siteviewid=$317ViewID,removeExisting=1,disklocatorname=$HSM92InstImg,siteName=$SiteName,Storename=$StoreName

            #$InstMsgBox = [System.Windows.Forms.MessageBox]::Show("$objItem selected. Classroom is now ready for Instructional Use!","Instructional Setup Complete","OK","Information")
            
            }
                                  
       
        Elseif (($objItem -eq 'High School, Room 403') -and ($objRadioButton1.Checked -eq $true)) {
            
            #Get-ADComputer -Filter 'Name -Like "HS-403-*-M92"' | Move-ADObject -TargetPath "OU=HS Staff,DC Placeholder Info"
            
            #$vdisk = MCLI-Run assigndisklocator -p siteviewid=$403ViewID,removeExisting=1,disklocatorname=$HSM92CertImg,siteName=$SiteName,Storename=$StoreName
            
            #$TestMsgBox = [System.Windows.Forms.MessageBox]::Show("$objItem selected. Classroom is now ready for Testing!","Testing Setup Complete","OK","Information")

            }


        Elseif (($objItem -eq 'High School, Room 403') -and ($objRadioButton2.Checked -eq $true)) {
            
            #Get-ADComputer -Filter 'Name -Like "HS-403-*-M92"' | Move-ADObject -TargetPath "OU=Lab 403,DC Placeholder Info"
            
            #$vdisk = MCLI-Run assigndisklocator -p siteviewid=$403ViewID,removeExisting=1,disklocatorname=$HSM92InstImg,siteName=$SiteName,Storename=$StoreName

            #$InstMsgBox = [System.Windows.Forms.MessageBox]::Show("$objItem selected. Classroom is now ready for Instructional Use!","Instructional Setup Complete","OK","Information")
            
            }
                       

        Elseif (($objItem -eq 'High School, Room 404') -and ($objRadioButton1.Checked -eq $true)) {
            
            #Get-ADComputer -Filter 'Name -Like "HS-404-*-M92"' | Move-ADObject -TargetPath "OU=THS Staff,DC Placeholder Info"
            
            #$vdisk = MCLI-Run assigndisklocator -p siteviewid=$404ViewID,removeExisting=1,disklocatorname=$HSM92CertImg,siteName=$SiteName,Storename=$StoreName
            
            #$TestMsgBox = [System.Windows.Forms.MessageBox]::Show("$objItem selected. Classroom is now ready for Testing!","Testing Setup Complete","OK","Information")
            }


        Elseif (($objItem -eq 'High School, Room 404') -and ($objRadioButton2.Checked -eq $true)) {
            
            #Get-ADComputer -Filter 'Name -Like "HS-404-*-M92"' | Move-ADObject -TargetPath "OU=Lab 404,DC Placeholder Info"
            
            #$vdisk = MCLI-Run assigndisklocator -p siteviewid=$404ViewID,removeExisting=1,disklocatorname=$HSM92InstImg,siteName=$SiteName,Storename=$StoreName

            #$InstMsgBox = [System.Windows.Forms.MessageBox]::Show("$objItem selected. Classroom is now ready for Instructional Use!","Instructional Setup Complete","OK","Information")
            
            }



        # Create a Script Test Selection Item to avoid using Production Machines

        Elseif (($objItem -eq 'Test, Testing Computer') -and ($objRadioButton1.Checked -eq $true)) {
            
            Get-ADComputer -Filter 'Name -eq "M92-Master"' | Move-ADObject -TargetPath "OU=IT,DC Placeholder Info"
                        
            $vdisk = MCLI-Run assigndisklocator -p siteviewid=$TestSiteViewID,removeExisting=1,disklocatorname=$M92CertImg,siteName=$TestSiteName,Storename=$TestStoreName
            
            $TestMsgBox = [System.Windows.Forms.MessageBox]::Show("$objItem selected. Classroom is now ready for Testing!","Testing Setup Complete","OK","Information")
            
            }

        Elseif (($objItem -eq 'Test, Testing Computer') -and ($objRadioButton2.Checked -eq $true)) {
            

            Get-ADComputer -Filter 'Name -eq "M92-Master"' | Move-ADObject -TargetPath "OU=IT,DC Placeholder Info"
            
            $vdisk = MCLI-Run assigndisklocator -p siteviewid=$TestSiteViewID,removeExisting=1,disklocatorname=$M92InstImg,siteName=$TestSiteName,Storename=$TestStoreName

            $InstMsgBox = [System.Windows.Forms.MessageBox]::Show("$objItem selected. Classroom is now ready for Instructional Use!","Instructional Setup Complete","OK","Information")
            
            }
                      
    }

    
        if ($objItem -eq $Null) {
           
           $error = [System.Windows.Forms.MessageBox]::Show("Please select a classroom from the list!","Missing Classroom","OK","Warning")


            }

        Elseif ($objRadioButton1.Checked -eq $false -and $objRadioButton2.Checked -eq $false ) {

            $error2 = [System.Windows.Forms.MessageBox]::Show("Please select either the 'Testing Image' or the 'Instructional Image' button!","Missing Image Selection","OK","Warning")

            }

        Else {
        
        $objForm.Close()
        
        }
   }
   }
   )
         

$objForm.Add_KeyDown({if ($_.KeyCode -eq "Escape") 
    {$objForm.Close()}})

# Create an "OK" button
$OKButton = New-Object System.Windows.Forms.Button
$OKButton.Location = New-Object System.Drawing.Size(75,175)
$OKButton.Size = New-Object System.Drawing.Size(75,23)
$OKButton.Text = "OK"
$OKButton.Font = New-Object System.Drawing.Font("Georgia",10,0,3,1)

$OKButton.Add_Click(
   {
 
    Mcli-Run setupConnection -p server=$PVSServer

        foreach ($objItem in $objListbox.SelectedItems)
            {$x += $objItem

               
if (($objItem -eq 'High School, Room 317') -and ($objRadioButton1.Checked -eq $true)) {


        if (($objItem -eq 'High School, Room 317') -and ($objRadioButton1.Checked -eq $true)) {
            
            #Get-ADComputer -Filter 'Name -Like "HS-317-*-M92"' | Move-ADObject -TargetPath "OU=HS Staff,DC Placeholder Info"
            
            #$vdisk = MCLI-Run assigndisklocator -p siteviewid=$HS317ViewID,removeExisting=1,disklocatorname=$HSM92CertImg,siteName=$SiteName,Storename=$StoreName
            
            #$TestMsgBox = [System.Windows.Forms.MessageBox]::Show("$objItem selected. Classroom is now ready for Testing!","Testing Setup Complete","OK","Information")

            }


        Elseif (($objItem -eq 'High School, Room 317') -and ($objRadioButton2.Checked -eq $true)) {
            
            #Get-ADComputer -Filter 'Name -Like "HS-317-*-M92"' | Move-ADObject -TargetPath "OU=Lab 317,DC Placeholder Info"
            
            #$vdisk = MCLI-Run assigndisklocator -p siteviewid=$317ViewID,removeExisting=1,disklocatorname=$HSM92InstImg,siteName=$SiteName,Storename=$StoreName

            #$InstMsgBox = [System.Windows.Forms.MessageBox]::Show("$objItem selected. Classroom is now ready for Instructional Use!","Instructional Setup Complete","OK","Information")
            
            }
                                  
       
        Elseif (($objItem -eq 'High School, Room 403') -and ($objRadioButton1.Checked -eq $true)) {
            
            #Get-ADComputer -Filter 'Name -Like "HS-403-*-M92"' | Move-ADObject -TargetPath "OU=HS Staff,DC Placeholder Info"
            
            #$vdisk = MCLI-Run assigndisklocator -p siteviewid=$403ViewID,removeExisting=1,disklocatorname=$HSM92CertImg,siteName=$SiteName,Storename=$StoreName
            
            #$TestMsgBox = [System.Windows.Forms.MessageBox]::Show("$objItem selected. Classroom is now ready for Testing!","Testing Setup Complete","OK","Information")

            }


        Elseif (($objItem -eq 'High School, Room 403') -and ($objRadioButton2.Checked -eq $true)) {
            
            #Get-ADComputer -Filter 'Name -Like "HS-403-*-M92"' | Move-ADObject -TargetPath "OU=Lab 403,DC Placeholder Info"
            
            #$vdisk = MCLI-Run assigndisklocator -p siteviewid=$403ViewID,removeExisting=1,disklocatorname=$HSM92InstImg,siteName=$SiteName,Storename=$StoreName

            #$InstMsgBox = [System.Windows.Forms.MessageBox]::Show("$objItem selected. Classroom is now ready for Instructional Use!","Instructional Setup Complete","OK","Information")
            
            }
                       

        Elseif (($objItem -eq 'High School, Room 404') -and ($objRadioButton1.Checked -eq $true)) {
            
            #Get-ADComputer -Filter 'Name -Like "HS-404-*-M92"' | Move-ADObject -TargetPath "OU=THS Staff,DC Placeholder Info"
            
            #$vdisk = MCLI-Run assigndisklocator -p siteviewid=$404ViewID,removeExisting=1,disklocatorname=$HSM92CertImg,siteName=$SiteName,Storename=$StoreName
            
            #$TestMsgBox = [System.Windows.Forms.MessageBox]::Show("$objItem selected. Classroom is now ready for Testing!","Testing Setup Complete","OK","Information")
            }


        Elseif (($objItem -eq 'High School, Room 404') -and ($objRadioButton2.Checked -eq $true)) {
            
            #Get-ADComputer -Filter 'Name -Like "HS-404-*-M92"' | Move-ADObject -TargetPath "OU=Lab 404,DC Placeholder Info"
            
            #$vdisk = MCLI-Run assigndisklocator -p siteviewid=$404ViewID,removeExisting=1,disklocatorname=$HSM92InstImg,siteName=$SiteName,Storename=$StoreName

            #$InstMsgBox = [System.Windows.Forms.MessageBox]::Show("$objItem selected. Classroom is now ready for Instructional Use!","Instructional Setup Complete","OK","Information")
            
            }



        # Create a Script Test Selection Item to avoid using Production Machines

        Elseif (($objItem -eq 'Test, Testing Computer') -and ($objRadioButton1.Checked -eq $true)) {
            
            Get-ADComputer -Filter 'Name -eq "M92-Master"' | Move-ADObject -TargetPath "OU=IT,DC Placeholder Info"
                        
            $vdisk = MCLI-Run assigndisklocator -p siteviewid=$TestSiteViewID,removeExisting=1,disklocatorname=$M92CertImg,siteName=$TestSiteName,Storename=$TestStoreName
            
            $TestMsgBox = [System.Windows.Forms.MessageBox]::Show("$objItem selected. Classroom is now ready for Testing!","Testing Setup Complete","OK","Information")
            
            }

        Elseif (($objItem -eq 'Test, Testing Computer') -and ($objRadioButton2.Checked -eq $true)) {
            

            Get-ADComputer -Filter 'Name -eq "M92-Master"' | Move-ADObject -TargetPath "OU=IT,DC Placeholder Info"
            
            $vdisk = MCLI-Run assigndisklocator -p siteviewid=$TestSiteViewID,removeExisting=1,disklocatorname=$M92InstImg,siteName=$TestSiteName,Storename=$TestStoreName

            $InstMsgBox = [System.Windows.Forms.MessageBox]::Show("$objItem selected. Classroom is now ready for Instructional Use!","Instructional Setup Complete","OK","Information")
            
            }
                      
    }

    
        if ($objItem -eq $Null) {
           
           $error = [System.Windows.Forms.MessageBox]::Show("Please select a classroom from the list!","Missing Classroom","OK","Warning")


            }

        Elseif ($objRadioButton1.Checked -eq $false -and $objRadioButton2.Checked -eq $false ) {

            $error2 = [System.Windows.Forms.MessageBox]::Show("Please select either the 'Testing Image' or the 'Instructional Image' button!","Missing Image Selection","OK","Warning")

            }

        Else {
        
        $objForm.Close()
        
        }
   })
$objForm.Controls.Add($OKButton)

# Create a "Cancel" button
$CancelButton = New-Object System.Windows.Forms.Button
$CancelButton.Location = New-Object System.Drawing.Size(165,175)
$CancelButton.Size = New-Object System.Drawing.Size(75,23)
$CancelButton.Text = "Cancel"
$CancelButton.Font = New-Object System.Drawing.Font("Georgia",10,0,3,1)
$CancelButton.Add_Click({$objForm.Close()})
$objForm.Controls.Add($CancelButton)

# Create a Header inside the Dialog Box
$objLabel = New-Object System.Windows.Forms.Label
$objLabel.Location = New-Object System.Drawing.Size(10,20) 
$objLabel.Size = New-Object System.Drawing.Size(280,20) 
$objLabel.Text = "Please Select Your Classroom Below:"
$objLabel.Font = New-Object System.Drawing.Font("Georgia",10,0,3,1)
$objForm.Controls.Add($objLabel) 

# Create a Options List box; Allow Multiple Line selections
$objListBox = New-Object System.Windows.Forms.ListBox 
$objListBox.Location = New-Object System.Drawing.Size(10,40) 
$objListBox.Size = New-Object System.Drawing.Size(260,20) 
$objListBox.Height = 80
$objListbox.SelectionMode = "MultiExtended"
$objListBox.Sorted = $True
$objListBox.Font = New-Object System.Drawing.Font("Georgia",10,0,3,1)

# Manually Specify the Items available
[void] $objListBox.Items.Add("Tabb High School, Room 317")
[void] $objListBox.Items.Add("Tabb High School, Room 403")
[void] $objListBox.Items.Add("Tabb High School, Room 404")
[void] $objListBox.Items.Add("CMP, Testing Computer")

$objForm.Controls.Add($objListBox) 

$objForm.Topmost = $True

$objForm.Add_Shown({$objForm.Activate()})
[void] $objForm.ShowDialog()

$x