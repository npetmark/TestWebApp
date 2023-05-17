#########VNET Block#################
resource "azurerm_virtual_network" "mongonet" {
  for_each            = var.address_spaces_to_locations
  name                = "vnet-${each.key}"
  address_space       = [each.value]
  location            = each.key
  resource_group_name = azurerm_resource_group.tw-rg-dev.name
  # dns_servers         = each.value.vnet.dns_servers
  #depends_on          = [
  #  azurerm_resource_group.rg
  #]
}
######################################

#########Subnet Block#################
resource "azurerm_subnet" "mongosubnet" {
  for_each             = var.address_prefixes_to_locations
  name                 = "sn-${each.key}"
  resource_group_name  = azurerm_resource_group.tw-rg-dev.name
  virtual_network_name = azurerm_virtual_network.mongonet[each.key].name
  address_prefixes     = [each.value]

  # dynamic "delegation" {
  #   for_each = each.value.delegation
  #   content {
  #     name = "d1"

  #     service_delegation {
  #           name =  delegation.value.name
  #           actions =  delegation.value.actions
  #     }
  #   }
  # }


  depends_on = [
    azurerm_virtual_network.mongonet
  ]
}
######################################

#########Private Endpoint Block#################
# resource "azurerm_private_endpoint" "mongo" {
#   for_each            = var.private_connection_resource_id
#   name                = "pe-${each.key}-to-${each.key}"
#   location            = each.key
#   resource_group_name = azurerm_resource_group.tw-rg-dev.name
#   subnet_id           = azurerm_subnet.mongosubnet[each.key].id

#   private_service_connection {
#     name                           = "mongo"
#     private_connection_resource_id = each.value
#     is_manual_connection           = true
#     request_message                = "PL"
#   }
# }
################################################

#########Peering Block#################
resource "azurerm_virtual_network_peering" "fisrt" {
  name                         = "peer-${var.location[0]}-to-${var.location[1]}"
  resource_group_name          = azurerm_resource_group.tw-rg-dev.name
  virtual_network_name         = azurerm_virtual_network.mongonet[var.location[0]].name
  remote_virtual_network_id    = azurerm_virtual_network.mongonet[var.location[1]].id
  allow_virtual_network_access = true
  allow_forwarded_traffic      = true

  # `allow_gateway_transit` must be set to false for vnet Global Peering
  allow_gateway_transit = false
}

resource "azurerm_virtual_network_peering" "second" {
  name                         = "peer-${var.location[1]}-to-${var.location[0]}"
  resource_group_name          = azurerm_resource_group.tw-rg-dev.name
  virtual_network_name         = azurerm_virtual_network.mongonet[var.location[1]].name
  remote_virtual_network_id    = azurerm_virtual_network.mongonet[var.location[0]].id
  allow_virtual_network_access = true
  allow_forwarded_traffic      = true

  # `allow_gateway_transit` must be set to false for vnet Global Peering
  allow_gateway_transit = false
}

resource "azurerm_virtual_network_peering" "third" {
  name                         = "peer-${var.location[0]}-to-${var.location[2]}"
  resource_group_name          = azurerm_resource_group.tw-rg-dev.name
  virtual_network_name         = azurerm_virtual_network.mongonet[var.location[0]].name
  remote_virtual_network_id    = azurerm_virtual_network.mongonet[var.location[2]].id
  allow_virtual_network_access = true
  allow_forwarded_traffic      = true

  # `allow_gateway_transit` must be set to false for vnet Global Peering
  allow_gateway_transit = false
}

resource "azurerm_virtual_network_peering" "fouth" {
  name                         = "peer-${var.location[2]}-to-${var.location[0]}"
  resource_group_name          = azurerm_resource_group.tw-rg-dev.name
  virtual_network_name         = azurerm_virtual_network.mongonet[var.location[2]].name
  remote_virtual_network_id    = azurerm_virtual_network.mongonet[var.location[0]].id
  allow_virtual_network_access = true
  allow_forwarded_traffic      = true

  # `allow_gateway_transit` must be set to false for vnet Global Peering
  allow_gateway_transit = false
}

resource "azurerm_virtual_network_peering" "fifth" {
  name                         = "peer-${var.location[1]}-to-${var.location[2]}"
  resource_group_name          = azurerm_resource_group.tw-rg-dev.name
  virtual_network_name         = azurerm_virtual_network.mongonet[var.location[1]].name
  remote_virtual_network_id    = azurerm_virtual_network.mongonet[var.location[2]].id
  allow_virtual_network_access = true
  allow_forwarded_traffic      = true

  # `allow_gateway_transit` must be set to false for vnet Global Peering
  allow_gateway_transit = false
}

resource "azurerm_virtual_network_peering" "sixth" {
  name                         = "peer-${var.location[2]}-to-${var.location[1]}"
  resource_group_name          = azurerm_resource_group.tw-rg-dev.name
  virtual_network_name         = azurerm_virtual_network.mongonet[var.location[2]].name
  remote_virtual_network_id    = azurerm_virtual_network.mongonet[var.location[1]].id
  allow_virtual_network_access = true
  allow_forwarded_traffic      = true

  # `allow_gateway_transit` must be set to false for vnet Global Peering
  allow_gateway_transit = false
}
#########Peering Block#################