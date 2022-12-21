@description('Storage Account type')
@allowed([
  'Premium_LRS'
  'Premium_ZRS'
  'Standard_GRS'
  'Standard_GZRS'
  'Standard_LRS'
  'Standard_RAGRS'
  'Standard_RAGZRS'
  'Standard_ZRS'
])
param storageAccountType string = 'Standard_LRS'

@description('Storage Account Location')
@allowed([
  'eastasia'
  'southeastasia'
  'eastus'
  'eastus2'
  'westus'
  'westus2'
  'northcentralus'
  'southcentralus'
  'westcentralus'
  'northeurope'
  'westeurope'
  'japaneast'
  'japanwest'
  'brazilsouth'
  'australiasoutheast'
  'australiaeast'
  'westindia'
  'southindia'
  'centralindia'
  'canadacentral'
  'canadaeast'
])
param Location string

@description('The name of the Storage Account')
param storageAccountName string

resource storageAccount 'Microsoft.Storage/storageAccounts@2022-05-01' = {
  name: storageAccountName
  location: Location
  sku: {
    name: storageAccountType
  }
  kind: 'StorageV2'
  properties: {
  }
}

output storageAccountName string = storageAccountName
output storageAccountId string = storageAccount.id