Connect-AZAccount -Identity
Import-Module Az.Resources

Get-AzResourceGroup  | Export-Excel -Path "$env:Temp\resource.csv"
$Receivers = @{
    "Jayendra Mishra" = "j@xyz.com"  
}

$Parameters = @{
    FromAddress = ""
    FromName    = ""
    ToAddress   = "placeholder"
    ToName      = "placeholder"
    Subject     = "AZ ResourceGroup report"
    Body        = "AZ ResourceGroup reportt"
    Token = ""
    AttachmentPath = "$env:Temp\resource.csv"
}

Foreach ($Receiver in $Receivers.GetEnumerator()) {
    $Parameters.ToName = $Receiver.name
    $Parameters.ToAddress = $Receiver.value
    Send-PSSendGridMail @Parameters

}
