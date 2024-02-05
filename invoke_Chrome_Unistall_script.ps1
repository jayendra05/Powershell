Login-AzAccount -tenant ""
$outp = @();
$vms = Import-Csv -Path "C:\Users\Inputcsv.csv"

foreach($vm in $vms)
{

Set-AzContext -Subscription $vm.Subscription

$vmrg = Get-azvm -Name $vm.VMName

$status = get-azvm -Name $vm.VMName -ResourceGroupName $vmrg.ResourceGroupName -Status


     if($status.Statuses[1].DisplayStatus -eq "VM running" )
     {
       try
       {
          Write-Host $vm.VMName
        Invoke-AzVMRunCommand -ResourceGroupName $vmrg.ResourceGroupName -VMName $vm.VMName -CommandId runpowershellscript -ScriptPath 'C:\Users\Remote_Chrome_install.ps1' -Verbose
    
          $outp += [pscustomobject]@{
                             "VMName" = $vm.VMName;
                             "ResourceGroup" = $vm.VMResourceGroup;
                             "VM Status" = "triggered";               
                 }
          }
        catch
        {
          $outp += [pscustomobject]@{
                             "VMName" = $vm.VMName;
                             "ResourceGroup" =  $vm.VMResourceGroup;
                             "VM Status" = "error";               
                 }
        }
      }
      else
      {
        $outp += [pscustomobject]@{
                             "VMName" = $vm.VMName;
                             "ResourceGroup" = $vm.VMResourceGroup;
                             "VM Status" = "VM not running";
                             
                            
                 }
      }
}
$outp | Export-Csv -NoTypeInformation -Path "‪C:\Users\uninstalloutput.csv"
