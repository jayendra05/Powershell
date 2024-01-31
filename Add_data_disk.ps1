$rgName = 'web-server'
$vmName = 'web-server-02'
$location = 'East US'
$diskSizeGb = 128

# Create the new data disk
$diskConfig = New-AzDiskConfig -SkuName "Standard_LRS" -Location $location -CreateOption Empty -DiskSizeGB $diskSizeGb
$dataDisk = New-AzDisk -DiskName "myDataDisk" -Disk $diskConfig -ResourceGroupName $rgName

# Get the virtual machine object
$vm = Get-AzVM -Name $vmName -ResourceGroupName $rgName

# Attach the data disk to the virtual machine
$vm = Add-AzVMDataDisk -VM $vm -Name "myDataDisk" -CreateOption Attach -ManagedDiskId $dataDisk.Id -Lun 1

# Update the virtual machine with the new data disk configuration
Update-AzVM -VM $vm -ResourceGroupName $rgName