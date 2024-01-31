#$userIdentifier = 'h.@xyz.com'


Get-AzRoleAssignment -SignInName 'h.@xyz.com' -ExpandPrincipalGroups | FL DisplayName, RoleDefinitionName, Scope


