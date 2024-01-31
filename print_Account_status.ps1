Connect-AzureAD
Get-AzureADUser -Filter "userPrincipalName eq 'email.com'" | Select-Object DisplayName, AccountEnabled