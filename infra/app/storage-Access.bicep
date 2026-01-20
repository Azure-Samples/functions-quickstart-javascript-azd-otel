param storageAccountName string
param principals array
param roleId string

resource storageAccount 'Microsoft.Storage/storageAccounts@2021-09-01' existing = {
  name: storageAccountName
}

// Allow access from API to storage account using a managed identity and least priv Storage roles
 
  resource storageRoleAssignment 'Microsoft.Authorization/roleAssignments@2020-04-01-preview' = [for principal in principals: {
  name: guid(storageAccount.id, principal.id, roleId)
  scope: storageAccount
  properties: {
    roleDefinitionId: resourceId('Microsoft.Authorization/roleDefinitions', roleId)
    principalId: principal.id
    principalType: principal.type
  }
}]
