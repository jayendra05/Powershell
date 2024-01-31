$inputValu = Import-Csv -Path "C:\Users\Desktop\removetaginput.csv"

$jobs = @()

foreach ($in in $inputValu) {
    $job = Start-Job -ScriptBlock {
        param($rgName, $vmName)
        $vms = Get-AzVM -ResourceGroupName $rgName -Name $vmName
        foreach ($vm in $vms) {
            $vmTags = $vm.Tags
            if ($vmTags.ContainsKey("Test1")) {
                $vmTags.Remove("Test1")
                $vm | Set-AzResource -ResourceId $vm.Id -Force
            }
        }
    } -ArgumentList $in.RGName, $in.VMName
    $jobs += $job
}
Wait-Job -Job $jobs
$results = $jobs | Receive-Job
$results