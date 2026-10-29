# ExpressRoute Circuit

## Overview

This Terraform module creates an Azure ExpressRoute circuit using the `azurerm` provider. It uses the `azurecaf` provider to generate a compliant ExpressRoute circuit name and the `random` provider to add a short random suffix to the generated name.

Use this module to provision an ExpressRoute circuit with consistent naming, validated region input, validated bandwidth options, and configurable ExpressRoute SKU settings.

## What This Module Deploys

- An `azurerm_express_route_circuit` resource.
- An `azurecaf_name` resource used to generate the ExpressRoute circuit name.
- A `random_string` resource used as a randomized suffix for the ExpressRoute circuit name.
- ExpressRoute service provider configuration using `service_provider_name`, `peering_location`, and `bandwidth_in_mbps`.
- ExpressRoute SKU configuration using `sku_tier` and `sku_family`.
- Resource tags from `var.tags`.
- Lifecycle protection with `prevent_destroy = true`.
- Lifecycle tag drift suppression using `ignore_changes = [tags]`.

## Requirements

| Requirement | Details |
|---|---|
| Required Terraform version | Not explicitly defined. |
| Required providers | `azurerm`, `azurecaf`, `random` |
| Required provider versions | Not explicitly defined. |
| Azure prerequisites | The target resource group must already exist. The selected ExpressRoute service provider, peering location, bandwidth, SKU tier, and SKU family must be valid for the target Azure subscription and region. |
| Required permissions or role assumptions | Not explicitly defined. The caller must have permissions to create and manage ExpressRoute circuits in the target resource group. |

## Required Parameters

| Name | Type | Description |
|---|---|---|
| `resource_group_name` | `string` | Resource group where the ExpressRoute circuit will be created. |
| `location` | `string` | Azure region for resource deployment. Only US regions are allowed. Valid values are `eastus`, `eastus2`, `centralus`, `northcentralus`, `southcentralus`, `westcentralus`, `westus`, `westus2`, and `westus3`. |
| `environment` | `string` | Environment value used in the generated ExpressRoute circuit name. Valid values are `prd` and `nonprd`. |
| `solution_name` | `string` | Solution name used in the generated ExpressRoute circuit name. |

## Optional Parameters

| Name | Type | Default | Description |
|---|---|---|---|
| `service_provider_name` | `string` | `"AT&T NetBond"` | ExpressRoute service provider name. |
| `peering_location` | `string` | `"Washington DC"` | ExpressRoute peering location. |
| `bandwidth_in_mbps` | `number` | `1000` | ExpressRoute circuit bandwidth in Mbps. Valid values are `50`, `100`, `200`, `500`, `1000`, `2000`, `5000`, and `10000`. |
| `sku_tier` | `string` | `"Standard"` | ExpressRoute SKU tier. Valid values are `Local`, `Standard`, and `Premium`. |
| `sku_family` | `string` | `"MeteredData"` | ExpressRoute billing model. Valid values are `MeteredData` and `UnlimitedData`. |
| `tags` | `map(string)` | `{}` | Tags applied to the ExpressRoute circuit. |

## Default Parameter Values

| Parameter | Default Value | Purpose |
|---|---|---|
| `service_provider_name` | `"AT&T NetBond"` | Sets the default ExpressRoute service provider. |
| `peering_location` | `"Washington DC"` | Sets the default ExpressRoute peering location. |
| `bandwidth_in_mbps` | `1000` | Sets the default ExpressRoute circuit bandwidth to 1 Gbps. |
| `sku_tier` | `"Standard"` | Sets the default ExpressRoute SKU tier. |
| `sku_family` | `"MeteredData"` | Sets the default ExpressRoute billing model. |
| `tags` | `{}` | Applies no tags by default. |

## Minimum Required Example

```hcl
module "expressroute_circuit" {
  source = "./modules/expressroute-circuit"

  resource_group_name = "rg-network-nonprd-eastus"
  location            = "eastus"
  environment         = "nonprd"
  solution_name       = "connectivity"
}
```

## Full Example

```hcl
module "expressroute_circuit" {
  source = "./modules/expressroute-circuit"

  resource_group_name = "rg-network-prd-eastus"
  location            = "eastus"
  environment         = "prd"
  solution_name       = "connectivity"

  service_provider_name = "AT&T NetBond"
  peering_location      = "Washington DC"
  bandwidth_in_mbps     = 1000
  sku_tier              = "Standard"
  sku_family            = "MeteredData"

  tags = {
    environment = "prd"
    workload    = "connectivity"
    managed_by  = "terraform"
  }
}
```

## Outputs

| Name | Description |
|---|---|
| `id` | ExpressRoute circuit resource ID. |
| `service_key` | ExpressRoute circuit service key used by the provider to provision the circuit. This output is marked sensitive. |
| `service_provider_provisioning_state` | Current service provider provisioning state. |
| `circuit_name` | ExpressRoute circuit name. |

## Best Practices

- Use a consistent `solution_name` value across related networking modules.
- Use `environment` values consistently with the module validation rules: `prd` or `nonprd`.
- Use lowercase Azure locations such as `eastus`, `westus`, or `centralus` to match the module examples and validation behavior.
- Store Terraform state remotely because the module outputs the sensitive ExpressRoute `service_key`.
- Protect access to state files because the ExpressRoute service key is sensitive and may be used by the provider to provision the circuit.
- Use separate state files or workspaces for production and non-production environments.
- Apply Azure governance controls outside this module, such as Azure Policy, naming standards, role assignments, and resource locks, where required.
- Plan changes carefully because the ExpressRoute circuit has `prevent_destroy = true`, which prevents Terraform from destroying the resource unless the lifecycle setting is changed in the module code.
- Manage tag updates carefully because the module ignores tag drift after creation through `ignore_changes = [tags]`.

## Notes

- The ExpressRoute circuit name is generated by the `azurecaf_name.expressroute_circuit_name` resource.
- The `azurecaf_name` resource uses `resource_type = "azurerm_express_route_circuit"`.
- The generated name uses the following suffixes:
  - `var.solution_name`
  - `var.location`
  - `var.environment`
  - `random_string.expressroute_circuit_name.result`
- The random suffix is generated by `random_string.expressroute_circuit_name`.
- The random suffix has a length of `4`.
- The random suffix uses lowercase alphabetic characters only because `upper = false`, `special = false`, and `numeric = false`.
- The ExpressRoute circuit resource name is set to `azurecaf_name.expressroute_circuit_name.result`.
- The module sets `allow_classic_operations = false`.
- The module sets `prevent_destroy = true` on the ExpressRoute circuit.
- The module ignores tag changes after creation using `ignore_changes = [tags]`.
- The `location` variable validation uses `lower(var.location)`, so uppercase input may pass validation, but examples should use lowercase region names.
- The `environment` variable validation only allows `prd` and `nonprd`.
- Provider sources are defined, but provider versions are not pinned.
- A required Terraform version is not defined.
