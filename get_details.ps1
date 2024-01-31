$ResourceGroupName = "DEMO-RG-VISUALSTUDIO"
$VMName = "sftptest"
$RemoteScriptPath = "C:\Users\Desktop\script.ps1"

$Result = Invoke-AzVMRunCommand -ResourceGroupName $ResourceGroupName -VMName $VMName -CommandId "RunPowerShellScript" -ScriptPath $RemoteScriptPath -Verbose
$Result | Export-Excel -Path 'C:\Users\Desktop\getservice.csv'