Connect-AZAccount -Identity
Import-Module Az.Resources

Remove-AzVirtualNetworkPeering -Name 'Yatindra-Vnet_to_Harshal-Vnet' -VirtualNetwork 'Yatindra-Vnet' -ResourceGroupName 'Yatindra-RG' -Force
Remove-AzVirtualNetworkPeering -Name 'Harshal-Vnet_to_Yatindra-Vnet' -VirtualNetwork 'Harshal-Vnet' -ResourceGroupName 'Harshal-RG' -Force
