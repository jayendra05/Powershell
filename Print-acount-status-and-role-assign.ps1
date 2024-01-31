$username = "h.com"
Get-AzureADUser -Filter "userPrincipalName eq '$username'" | Select-Object DisplayName, AccountEnabled
Get-AzRoleAssignment -SignInName $username -ExpandPrincipalGroups | Format-List DisplayName, RoleDefinitionName