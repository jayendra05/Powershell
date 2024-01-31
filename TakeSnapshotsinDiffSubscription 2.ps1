$SnapshotReportCsv = "C:\Users\AzSnapshotReport_$(Get-Date -UFormat "%Y%m%d%H%M%S").csv"
$Subscrioption =  Select-AzSubscription -SubscriptionId "fefe-edfdf-dfd"
$VMs1 = Import-Csv -Path "C:\Users\Downloads\DR_VMList.csv"
$StartTime = Get-Date
$Disks = Get-AzDisk
foreach($Server in $VMs1) {
Select-AzSubscription -SubscriptionId "fefe-edfdf-dfd"
$VM = Get-AzVM -ResourceGroupName $Server.ResourceGroupName -Name $Server.Name   
        $Osdisk = $Disks | ?{$_.Name -eq $VM.StorageProfile.OsDisk.Name}
        Write-Output "VM $($vm.name) OS Disk Name $($Osdisk.Name) Snapshot Begin"
        #Create Snapshot 
        $SnapshotName = $Osdisk.Name+('-')+(Get-Date -Format "yyyy-MM-dd")
        $Snapshotconfig = New-AzSnapshotConfig `
                            -SourceResourceID $Osdisk.Id `
                            -CreateOption Copy `
                            -Location $Osdisk.Location `
                            -AccountType $osdisk.sku.Name

       select-azSubscription -SubscriptionID "different_sub"
       $NewSnapshot = New-AzSnapshot -Snapshot $Snapshotconfig `
                       -SnapshotName $SnapshotName `
                       -ResourceGroupName "Snapshots"       
  
  if($VM.StorageProfile.DataDisks.Name -ne $null)  {
     $DataDisks = $VM.StorageProfile.DataDisks.Name
    foreach ($datadisk in $datadisks) {
 
        $Disk = $Disks | ?{$_.Name -eq $datadisk}
 
        Write-Output "VM $($vm.name) data Disk Name $($Disk.Name) Snapshot Begin"
        $snapshotNameData = $Disk.Name+('-')+(Get-Date -Format "yyyy-MM-dd")
        $DataDiskSnapshotConfig = New-AzSnapshotConfig `
                                     -SourceResourceID $Disk.Id `
                                     -CreateOption Copy `
                                     -Location $Disk.Location `
                                     -AccountType $disk.sku.Name  
        $DiskSnapshot = New-AzSnapshot -Snapshot $DataDiskSnapshotConfig `
                            -SnapshotName $snapshotNameData `
                            -ResourceGroupName "Snapshots"            
         }
      } 
 }
 
 Write-Host "Task completed in $((New-TimeSpan $StartTime (Get-Date)).Minutes) Minutes."
