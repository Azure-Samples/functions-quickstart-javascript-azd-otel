param applicationInsightsName string
param principals array
param roleId string

resource applicationInsights 'Microsoft.Insights/components@2020-02-02' existing = {
  name: applicationInsightsName
}

// Allow access from Function App to Application Insights using a managed identity
resource appInsightsRoleAssignment 'Microsoft.Authorization/roleAssignments@2020-04-01-preview' = [for principal in principals: {
  name: guid(applicationInsights.id, principal.id, roleId)
  scope: applicationInsights
  properties: {
    roleDefinitionId: resourceId('Microsoft.Authorization/roleDefinitions', roleId)
    principalId: principal.id
    principalType: principal.type
  }
}]
