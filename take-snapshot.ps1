Login-AzAccount -TenantId "" -Subscription ""
#$Subscrioption =  Select-AzSubscription -SubscriptionId ""
$VMs1 = Import-Csv -Path "C:\Users\Desktop\Powershell code\Report.csv"
$StartTime = Get-Date
$Disks = Get-AzDisk
foreach($Server in $VMs1) {
$VM = Get-AzVM -ResourceGroupName $Server.ResourceGroupName -Name $Server.Name   
        $Osdisk = $Disks | ?{$_.Name -eq $VM.StorageProfile.OsDisk.Name}
        Write-Output "VM $($vm.name) OS Disk Name $($Osdisk.Name) Snapshot Begin"
        #Create Snapshot 
        $SnapshotName = $Osdisk.Name+"_snapshot"
        $Snapshotconfig = New-AzSnapshotConfig `
                            -SourceResourceID $Osdisk.Id `
                            -CreateOption Copy `
                            -Location $Osdisk.Location `
                            -AccountType $osdisk.sku.Name
       $NewSnapshot = New-AzSnapshot -Snapshot $Snapshotconfig `
                       -SnapshotName $SnapshotName `
                       -ResourceGroupName $Server.ResourceGroupName   
  
  if($VM.StorageProfile.DataDisks.Name -ne $null)  {
     $DataDisks = $VM.StorageProfile.DataDisks.Name
    foreach ($datadisk in $datadisks) {
 
        $Disk = $Disks | ?{$_.Name -eq $datadisk}
 
        Write-Output "VM $($vm.name) data Disk Name $($Disk.Name) Snapshot Begin"
        $snapshotNameData = $Disk.Name+"_snapshot"
        $DataDiskSnapshotConfig = New-AzSnapshotConfig `
                                     -SourceResourceID $Disk.Id `
                                     -CreateOption Copy `
                                     -Location $Disk.Location `
                                     -AccountType $disk.sku.Name  
        $DiskSnapshot = New-AzSnapshot -Snapshot $DataDiskSnapshotConfig `
                            -SnapshotName $snapshotNameData `
                            -ResourceGroupName $Server.ResourceGroupName           
         }
      } 
 }
 
 Write-Host "Task completed in $((New-TimeSpan $StartTime (Get-Date)).Minutes) Minutes."
