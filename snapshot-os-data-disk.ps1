Login-AzAccount -TenantId ""

$resourceGroupName = 'Jayendra-RG'
$location = 'East US'
$vmName = 'Jayendra-Server01'
$snapshotNamePrefix = 'mySnapshot'

$vm = Get-AzVM -ResourceGroupName $resourceGroupName -Name $vmName

$osDiskSnapshot = New-AzSnapshotConfig -SourceUri $vm.StorageProfile.OsDisk.ManagedDisk.Id -Location $location -CreateOption copy
$osDiskSnapshotName = $snapshotNamePrefix + '-OS'
New-AzSnapshot -Snapshot $osDiskSnapshot -SnapshotName $osDiskSnapshotName -ResourceGroupName $resourceGroupName

foreach ($dataDisk in $vm.StorageProfile.DataDisks) {
    $dataDiskSnapshot = New-AzSnapshotConfig -SourceUri $dataDisk.ManagedDisk.Id -Location $location -CreateOption copy
    $dataDiskSnapshotName = $snapshotNamePrefix + '-' + $dataDisk.Name
    New-AzSnapshot -Snapshot $dataDiskSnapshot -SnapshotName $dataDiskSnapshotName -ResourceGroupName $resourceGroupName
}

Write-Host "Snapshots created successfully for both OS and data disks."
