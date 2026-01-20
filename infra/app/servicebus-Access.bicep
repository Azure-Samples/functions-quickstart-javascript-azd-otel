param serviceBusNamespaceName string
param roleDefinitionId string
param principals array

resource ServiceBusResource 'Microsoft.ServiceBus/namespaces@2022-10-01-preview' existing = {
  name: serviceBusNamespaceName
}

resource ServiceBusRoleAssignment 'Microsoft.Authorization/roleAssignments@2020-04-01-preview' = [for principal in principals: {
  name: guid(ServiceBusResource.id, principal.id, roleDefinitionId)
  scope: ServiceBusResource
  properties: {
    roleDefinitionId: resourceId('Microsoft.Authorization/roleDefinitions', roleDefinitionId)
    principalId: principal.id
    principalType: principal.type
  }
}]
