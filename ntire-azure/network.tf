resource "azurerm_resource_group" "ntire" {
  name     = var.resource_group_name
  location = var.location
  tags = {
    Env       = "dev"
    CreatedBy = "Terraform"
  }

}

resource "azurerm_virtual_network" "primary" {
  name = format("%s-primary", var.resource_group_name)
  // "${var.resource_group_name}-primary"
  resource_group_name = azurerm_resource_group.ntire.name
  address_space       = [var.address_space]
  location            = var.location

}


resource "azurerm_subnet" "subnets" {
  count                = length(var.subnet_name)
  name                 = var.subnet_name[count.index]
  resource_group_name  = azurerm_resource_group.ntire.name
  virtual_network_name = azurerm_virtual_network.primary.name
  address_prefixes     = [cidrsubnet(var.address_space, 8, count.index)]

  depends_on = [azurerm_virtual_network.primary]

}

resource "azurerm_network_security_group" "webnsg" {
  name                = "webnsg"
  resource_group_name = azurerm_resource_group.ntire.name
  location            = var.location
  depends_on          = [azurerm_virtual_network.primary]
}

resource "azurerm_network_security_rule" "web_rules" {
  count                       = length(var.webnsg_rules_info)
  name                        = var.webnsg_rules_info[count.index].name
  resource_group_name         = azurerm_resource_group.ntire.name
  network_security_group_name = "webnsg"
  protocol                    = var.webnsg_rules_info[count.index].protocol
  source_port_range           = var.webnsg_rules_info[count.index].source_port_range
  destination_port_range      = var.webnsg_rules_info[count.index].destination_port_range
  direction                   = var.webnsg_rules_info[count.index].direction
  source_address_prefix       = var.webnsg_rules_info[count.index].source_address_prefix
  destination_address_prefix  = var.webnsg_rules_info[count.index].destination_address_prefix
  access                      = var.webnsg_rules_info[count.index].access
  priority                    = var.webnsg_rules_info[count.index].priority
  depends_on                  = [azurerm_network_security_group.webnsg]
}
