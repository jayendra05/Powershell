$inputValu = Import-Csv -Path "C:\Users\Desktop\removetaginput.csv"

foreach($in in $inputValu)
{

$vms = Get-AzVM -ResourceGroupName $in.RGName -Name $in.VMName

foreach ($vm in $vms) {
$vmTags = $vm.Tags

if ($vmTags.ContainsKey("Test2")) {
$vmTags.Remove("Test2")
}
$vm | Set-AzResource -ResourceId $vm.Id -Force
}
}