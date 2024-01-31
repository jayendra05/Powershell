Get-AzResourceGroup  | Export-Excel -Path 'C:\Users\Desktop\resource.csv'
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
    AttachmentPath = "C:\Users\Desktop\resource.csv"
}

Foreach ($Receiver in $Receivers.GetEnumerator()) {
    $Parameters.ToName = $Receiver.name
    $Parameters.ToAddress = $Receiver.value
    Send-PSSendGridMail @Parameters

}

Remove-Item -Path 'C:\Users\Desktop\resource.csv' -Force