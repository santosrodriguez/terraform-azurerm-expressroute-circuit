 

variable "resource_group_name" {
  description = "Resource group where the ExpressRoute circuit will be created."
  type        = string
}

variable "location" {
  type        = string
  description = "Azure region for resource deployment. Only US regions are allowed."

  validation {
    condition = contains([
      "eastus",
      "eastus2",
      "centralus",
      "northcentralus",
      "southcentralus",
      "westcentralus",
      "westus",
      "westus2",
      "westus3"
    ], lower(var.location))

    error_message = "Location must be a valid Azure US region: eastus, eastus2, centralus, northcentralus, southcentralus, westcentralus, westus, westus2, or westus3."
  }
}

variable "service_provider_name" {
  description = "ExpressRoute service provider name."
  type        = string
  default     = "AT&T NetBond"
  validation {
    condition     = contains(["AT&T NetBond"], var.service_provider_name)
    error_message = "service_provider_name must be AT&T NetBond."
  }
}

variable "peering_location" {
  description = "ExpressRoute peering location."
  type        = string
  default     = "Washington DC"

  validation {
    condition = contains([
      "Atlanta",
      "Chicago",
      "Dallas",
      "Phoenix",
      "San Antonio",
      "Silicon Valley",
      "Washington DC"
    ], var.peering_location)

    error_message = "peering_location must be one of: Atlanta, Chicago, Dallas, Phoenix, San Antonio, Silicon Valley, Washington DC."
  }
}

variable "bandwidth_in_mbps" {
  description = "ExpressRoute circuit bandwidth in Mbps."
  type        = number
  default     = 100

  validation {
    condition     = contains([50, 100, 200, 500, 1000, 2000, 5000, 10000], var.bandwidth_in_mbps)
    error_message = "bandwidth_in_mbps must be a valid ExpressRoute circuit bandwidth."
  }
}

variable "sku_tier" {
  description = "ExpressRoute SKU tier."
  type        = string
  default     = "Standard"

  validation {
    condition     = contains(["Local", "Standard", "Premium"], var.sku_tier)
    error_message = "sku_tier must be Local, Standard, or Premium."
  }
}

variable "sku_family" {
  description = "ExpressRoute billing model."
  type        = string
  default     = "MeteredData"

  validation {
    condition     = contains(["MeteredData", "UnlimitedData"], var.sku_family)
    error_message = "sku_family must be MeteredData or UnlimitedData."
  }
}

variable "tags" {
  description = "Tags applied to the ExpressRoute circuit."
  type        = map(string)
  default     = {}
}

 
variable "environment" {
  type = string
  validation {
    condition = contains(
      ["prd", "nonprd"], var.environment
    )
    error_message = "Error: Valid environments are prd and nonprd"
  }
}

variable "solution_name" {
  type = string
}
