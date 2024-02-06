Login-AzAccount -tenant ""

$RGName = 'Jayendra-RG'
$RGName1 = 'Harshal-RG'
$eastVNetName = 'Jayendra-Vnet'
$westVNetName = 'Harshal-Vnet'
$Peering1 = 'Jayendra-Vnet_to_Harshal-Vnet'
$Peering2 = 'Harshal-Vnet_to_Jayendra-Vnet'
$vnet1 = Get-AzVirtualNetwork -Name $eastVNetName -ResourceGroupName $RGName
$vnet2 = Get-AzVirtualNetwork -Name $westVNetName -ResourceGroupName $RGName1

Add-AzVirtualNetworkPeering -Name $Peering1 -VirtualNetwork $vnet1 -RemoteVirtualNetworkId $vnet2.Id -AllowForwardedTraffic
Add-AzVirtualNetworkPeering -Name $Peering2 -VirtualNetwork $vnet2 -RemoteVirtualNetworkId $vnet1.Id -AllowForwardedTraffic
