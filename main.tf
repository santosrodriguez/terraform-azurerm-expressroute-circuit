resource "random_string" "expressroute_circuit_name" {
  length = 4
  upper = false
  lower = false
  special = false
  numeric = true
}

resource "azurecaf_name" "expressroute_circuit_name" {
  resource_type = "azurerm_express_route_circuit"
  suffixes = [ var.solution_name, var.location, var.environment, random_string.expressroute_circuit_name.result ]
}





resource "azurerm_express_route_circuit" "this" {
  name                = azurecaf_name.expressroute_circuit_name.result
  resource_group_name = var.resource_group_name
  location            = var.location

  service_provider_name = var.service_provider_name
  peering_location      = var.peering_location
  bandwidth_in_mbps     = var.bandwidth_in_mbps

  sku {
    tier   = var.sku_tier
    family = var.sku_family
  }

  allow_classic_operations = false

  tags = var.tags

  lifecycle {
    prevent_destroy = false
    ignore_changes = [ 
      tags
     ]
  }
}
