$excelFilePath = "C:\Users\Desktop\VMs.xlsx"
$inputData = Import-Excel -Path $excelFilePath

# Loop through each row in the input data
foreach ($row in $inputData) {
# Get the values from each column in the current row
$resourceGroupName = $row.ResourceGroupName
$vmLocation = $row.VMLocation
$availabilitySetName = $row.AvailabilitySetName
$vmName = $row.VMName
$vmSize = $row.VMSize
$dataDiskSizeGB = $row.DataDiskSizeGB
$dataDiskName = $row.DataDiskName

# Check if resource group exists
if ((Get-AzResourceGroup -Name $resourceGroupName -ErrorAction SilentlyContinue) -eq $null) {
# Resource group does not exist, create new resource group
New-AzResourceGroup -Name $resourceGroupName -Location $vmLocation
Write-Host "The $resourceGroupName resource group has been created."
}

# Check if availability set exists in resource group
$availabilitySet = Get-AzAvailabilitySet -ResourceGroupName $resourceGroupName -Name $availabilitySetName -ErrorAction SilentlyContinue

if ($availabilitySet -eq $null) {
# Availability set does not exist, create new availability set
$availabilitySet = New-AzAvailabilitySet `
-ResourceGroupName $resourceGroupName `
-Name $availabilitySetName `
-Location $vmLocation `
-Sku Aligned `
-PlatformFaultDomainCount 2 `
-PlatformUpdateDomainCount 5
Write-Host "The $availabilitySetName availability set has been created in the $resourceGroupName resource group."
} else {
# Availability set already exists in resource group
Write-Host "The $availabilitySetName availability set already exists in the $resourceGroupName resource group."
}

# Check if virtual machine exists in resource group
if ((Get-AzVM -ResourceGroupName $resourceGroupName -Name $vmName -ErrorAction SilentlyContinue) -eq $null) {
# Virtual machine does not exist, create new virtual machine with availability set
$vm = New-AzVM `
-ResourceGroupName $resourceGroupName `
-Name $vmName `
-Size $vmSize `
-Location $vmLocation `
-AvailabilitySetName $availabilitySetName `
# Add any additional configuration options for the virtual machine here

Write-Host "The $vmName virtual machine has been created in the $resourceGroupName resource group with the $availabilitySetName availability set."

# Create and attach data disk
$diskConfig = New-AzDiskConfig -SkuName "Standard_LRS" -Location $vmLocation -CreateOption Empty -DiskSizeGB $dataDiskSizeGB
$dataDisk = New-AzDisk -DiskName $dataDiskName -Disk $diskConfig -ResourceGroupName $resourceGroupName

# Get the virtual machine object
$vm = Get-AzVM -Name $vmName -ResourceGroupName $resourceGroupName

# Attach the data disk to the virtual machine
$vm = Add-AzVMDataDisk -VM $vm -Name $dataDiskName -CreateOption Attach -ManagedDiskId $dataDisk.Id -Lun 1

# Update the virtual machine with the new data disk configuration
Update-AzVM -VM $vm -ResourceGroupName $resourceGroupName
Write-Host "A new data disk ($dataDiskName) has been created and attached to the $vmName virtual machine."
} else {
# Virtual machine already exists in resource group
Write-Host "The $vmName virtual machine already exists in the $resourceGroupName resource group."
}
}