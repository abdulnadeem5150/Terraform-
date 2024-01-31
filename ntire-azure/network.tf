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

resource "azurerm_network_security_group" "nsgs" {
  count               = length(var.name_nsg)
  name                = var.name_nsg[count.index]
  resource_group_name = azurerm_resource_group.ntire.name
  location            = var.location
  depends_on          = [azurerm_virtual_network.primary]
}

resource "azurerm_network_security_rule" "rules" {
  count                       = length(var.webnsg_rules_info)
  name                        = var.webnsg_rules_info[count.index].name
  resource_group_name         = azurerm_resource_group.ntire.name
  network_security_group_name = var.webnsg_rules_info[count.index].nsgs_name
  protocol                    = var.webnsg_rules_info[count.index].protocol
  source_port_range           = var.webnsg_rules_info[count.index].source_port_range
  destination_port_range      = var.webnsg_rules_info[count.index].destination_port_range
  direction                   = var.webnsg_rules_info[count.index].direction
  source_address_prefix       = var.webnsg_rules_info[count.index].source_address_prefix
  destination_address_prefix  = var.webnsg_rules_info[count.index].destination_address_prefix
  access                      = var.webnsg_rules_info[count.index].access
  priority                    = var.webnsg_rules_info[count.index].priority
  depends_on                  = [azurerm_network_security_group.nsgs]
}

resource "azurerm_network_interface" "webnics" {
  count = length(var.network_inter_info)
  name                = var.network_inter_info[count.index]
  location            = var.location
  resource_group_name = azurerm_resource_group.ntire.name

  ip_configuration {
    name = "web"
    //todo: need to change from static indexing to dynamic
    subnet_id                     = azurerm_subnet.subnets[0].id
    private_ip_address_allocation = "Dynamic"
  }

}

resource "azurerm_network_interface" "businessnic" {
  name                = "businessnic"
  location            = var.location
  resource_group_name = azurerm_resource_group.ntire.name

  ip_configuration {
    name = "business"
    //todo: need to change from static indexing to dynamic
    subnet_id                     = azurerm_subnet.subnets[1].id
    private_ip_address_allocation = "Dynamic"
  }

}

resource "azurerm_network_interface" "datanic" {
  name                = "datanic"
  location            = var.location
  resource_group_name = azurerm_resource_group.ntire.name

  ip_configuration {
    name = "data"
    //todo: need to change from static indexing to dynamic
    subnet_id                     = azurerm_subnet.subnets[2].id
    private_ip_address_allocation = "Dynamic"
  }
  depends_on = [azurerm_subnet.subnets,
  azurerm_network_security_rule.rules]
}

resource "azurerm_network_interface_security_group_association" "web" {
  network_interface_id      = azurerm_network_interface.webnic.id
  network_security_group_id = azurerm_network_security_group.nsgs[0].id
}

resource "azurerm_network_interface_security_group_association" "business" {
  network_interface_id      = azurerm_network_interface.businessnic.id
  network_security_group_id = azurerm_network_security_group.nsgs[1].id
}

resource "azurerm_network_interface_security_group_association" "data" {
  network_interface_id      = azurerm_network_interface.datanic.id
  network_security_group_id = azurerm_network_security_group.nsgs[2].id
}