output "id" {
  description = "ExpressRoute circuit resource ID."
  value       = azurerm_express_route_circuit.this.id
}

output "service_key" {
  description = "ExpressRoute circuit service key used by the provider to provision the circuit."
  value       = azurerm_express_route_circuit.this.service_key
  sensitive   = true
}

output "service_provider_provisioning_state" {
  description = "Current service provider provisioning state."
  value       = azurerm_express_route_circuit.this.service_provider_provisioning_state
}

output "circuit_name" {
  description = "ExpressRoute circuit name"
  value = azurerm_express_route_circuit.this.name
}
