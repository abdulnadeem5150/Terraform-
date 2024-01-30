variable "resource_group_name" {
  type = string

}

variable "location" {
  type    = string
  default = "eastus"

}

variable "address_space" {
  type    = string
  default = "10.100.0.0/16"

}

variable "subnet_name" {
  type    = list(string)
  default = ["web", "business", "data"]

}

variable "name_nsg" {
  type    = list(string)
  default = ["web", "business", "data"]
}

variable "webnsg_rules_info" {
  type = list(object({
    name                       = string
    protocol                   = string
    source_port_range          = string
    destination_port_range     = string
    direction                  = string
    source_address_prefix      = string
    destination_address_prefix = string
    access                     = string
    priority                   = number
    nsgs_name                  = string
  }))

  default = [{
    name                       = "AllowHttp"
    protocol                   = "Tcp"
    source_address_prefix      = "*"
    source_port_range          = "*"
    destination_address_prefix = "*"
    destination_port_range     = "80"
    direction                  = "Inbound"
    access                     = "Allow"
    priority                   = 300
    nsgs_name                  = "web"
    },
    {
      name                       = "AllowHttps"
      protocol                   = "Tcp"
      source_address_prefix      = "*"
      source_port_range          = "*"
      destination_address_prefix = "*"
      destination_port_range     = "443"
      direction                  = "Inbound"
      access                     = "Allow"
      priority                   = 310
      nsgs_name                  = "web"
    }
  ]

}