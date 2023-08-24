param sourceNetworkName string // Parameter for the name of the source virtual network
param destinationNetworkName string // Parameter for the name of the destination virtual network
param resourceGroupName string // Parameter for the name of the resource group

// Define the source virtual network resource using the provided name
resource sourceNetwork 'Microsoft.Network/virtualNetworks@2022-09-01' = {
  name: sourceNetworkName
  location: sourceNetworkLocation // Location/region for the source virtual network
  properties: {
    addressSpace: {
      addressPrefixes: ['10.0.0.0/16']
    }
  }
}

// Define the destination virtual network resource using the provided name
resource destinationNetwork 'Microsoft.Network/virtualNetworks@2022-09-01' = {
  name: destinationNetworkName
  location: destinationNetworkLocation // Location/region for the destination virtual network
  properties: {
    addressSpace: {
      addressPrefixes: ['10.1.0.0/16']
    }
  }
}

// Create peering from source to destination virtual network
resource sourceToDestinationPeering 'Microsoft.Network/virtualNetworks/virtualNetworkPeerings@2022-07-01' = {
  name: '${sourceNetworkName}-To-${destinationNetworkName}'
  parent: sourceNetwork
  properties: {
    allowForwardedTraffic: true
    allowGatewayTransit: true
    remoteVirtualNetwork: {
      id: destinationNetwork.id
    }
  }
}

// Create peering from destination to source virtual network
resource destinationToSourcePeering 'Microsoft.Network/virtualNetworks/virtualNetworkPeerings@2022-07-01' = {
  name: '${destinationNetworkName}-To-${sourceNetworkName}'
  parent: destinationNetwork
  properties: {
    allowForwardedTraffic: true
    allowGatewayTransit: true
    remoteVirtualNetwork: {
      id: sourceNetwork.id
    }
  }
}

// How to use this template ?
// Execute the following command in Azure CLI
// az deployment group create --template-file vnet-peering.bicep --resource-group YourResourceGroupName --parameters sourceNetworkName=VNet-northeurope destinationNetworkName=VNet-westus sourceNetworkLocation=northeurope destinationNetworkLocation=westus
