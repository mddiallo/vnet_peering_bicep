// File to create a network peering between two existing virtual networks in the same resource group

param sourceNetworkname string

param destinationNetworkname string

resource sourceNetwork 'Microsoft.Network/virtualNetworks@2022-09-01' existing = {
  name: sourceNetworkname
}

resource destinationNetwork 'Microsoft.Network/virtualNetworks@2022-09-01' existing = {
  name: destinationNetworkname
}

resource sourceToDestinationPeering 'Microsoft.Network/virtualNetworks/virtualNetworkPeerings@2022-07-01' = {
  name: '${sourceNetworkname}-To-${destinationNetworkname}'
  parent: sourceNetwork
  properties: {
    allowForwardedTraffic: true
    allowGatewayTransit: true
    remoteVirtualNetwork: {
      id: destinationNetwork.id
    }
  }
}

resource destinationToSourcePeering 'Microsoft.Network/virtualNetworks/virtualNetworkPeerings@2022-07-01' = {
  name: '${destinationNetworkname}-To-${sourceNetworkname}'
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
// az deployment group create --template-file .\vnet-peering.bicep --resource-group NetworkPeering-rg --parameters sourceNetworkname=VNet-northeurope destinationNetworkname=VNet-westus
