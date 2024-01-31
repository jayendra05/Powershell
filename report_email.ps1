$reportName = "myReport.csv"
$report = @()
$vms = Get-AzVM
$publicIps = Get-AzPublicIpAddress 
$nics = Get-AzNetworkInterface | ?{ $_.VirtualMachine -NE $null}

 

foreach ($nic in $nics) { 
   $info = "" | Select VmName, ResourceGroupName, Region, VmSize, Subnet, PrivateIpAddress, OsType, PublicIPAddress, NicName, ApplicationSecurityGroup, ServerBanding,Environment,Description,Compliance,CN_PWO,acp_ims_endpoint,ResourceType,  OsFlavor, OsPublisher
 

    $vm = $vms | ? -Property Id -eq $nic.VirtualMachine.id

 

    foreach($publicIp in $publicIps) { 
        if($nic.IpConfigurations.id -eq $publicIp.ipconfiguration.Id) {
            $info.PublicIPAddress = $publicIp.ipaddress
        } 
    }

 

    $tags = $vm.Tags
    foreach($tag in $tags.GetEnumerator()){
        if($tag.Key -eq "Server Banding"){
            $info.ServerBanding = $tag.Value
        } 
        elseif($tag.Key -eq "environment"){
            $info.Environment = $tag.Value
        } 
        elseif($tag.Key -eq "Description"){
            $info.Description = $tag.Value
        } 
        elseif($tag.Key -eq "Compliance"){
            $info.Compliance = $tag.Value
        } 
        elseif($tag.Key -eq "CN-PWO"){
            $info.CN_PWO = $tag.Value
        } 
        elseif($tag.Key -eq "acp-ims-endpoint"){
            $info.acp_ims_endpoint = $tag.Value
        }

    }

 

    $info.OsType = $vm.StorageProfile.OsDisk.OsType 
    $info.VMName = $vm.Name 
    $info.ResourceGroupName = $vm.ResourceGroupName 
    $info.Region = $vm.Location 
    $info.VmSize = $vm.HardwareProfile.VmSize
    $info.Subnet = $nic.IpConfigurations.subnet.Id.Split("/")[-1] 
    $info.PrivateIpAddress = $nic.IpConfigurations.PrivateIpAddress 
    $info.NicName = $nic.Name 
    $info.ApplicationSecurityGroup = $nic.IpConfigurations.ApplicationSecurityGroups.Id
    $info.ResourceType = $vm.GetType().Name 
    #$info.ResourceStatus = $vm.Statuses[0].DisplayStatus 
    $info.OsFlavor = $vm.StorageProfile.ImageReference.Offer 
    $info.OsPublisher = $vm.StorageProfile.ImageReference.Publisher

 

    $report += $info 
}

 

$report | ft VmName, ResourceGroupName, Region, VmSize, Subnet, PrivateIpAddress, OsType, PublicIPAddress, NicName, ApplicationSecurityGroup, ServerBanding, Environment,Description,Compliance,CN_PWO,acp_ims_endpoint,ResourceType,OsFlavor, OsPublisher
$report | export-csv -Path 'C:\Users\Desktop\Report.csv' -NoTypeInformation

$Receivers = @{
    "Jayendra Mishra" = "j@xyz.com"  
    "Harshal Badwaik" = "h@xyz.com" 
}

$Parameters = @{
    FromAddress = ""
    FromName    = ""
    ToAddress   = "placeholder"
    ToName      = "placeholder"
    Subject     = "AZ report"
    Body        = "AZ report"
    Token = ""
    AttachmentPath = "C:\Users\Desktop\Report.csv"
}

Foreach ($Receiver in $Receivers.GetEnumerator()) {
    $Parameters.ToName = $Receiver.name
    $Parameters.ToAddress = $Receiver.value
    Send-PSSendGridMail @Parameters

}

#ps2exe -inputFile "C:\Users\Desktop\Code\report_email.ps1" -outputFile "C:\Users\Desktop\Code\report_email.exe"