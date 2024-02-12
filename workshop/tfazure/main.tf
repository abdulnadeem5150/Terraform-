# Create a resource for resource group
# https://registry.terraform.io/providers/hashicorp/azurerm/latest/docs/resources/linux_virtual_machine

resource "azurerm_resource_group" "rg" {
  name     = var.resource_group.name
  location = var.resource_group.location

}

# create a resource for virtual network
resource "azurerm_virtual_network" "vnet" {
  name                = var.vn_name
  address_space       = [var.address_space]
  location            = azurerm_resource_group.rg.location
  resource_group_name = azurerm_resource_group.rg.name
  depends_on          = [azurerm_resource_group.rg]
}

# create a resource for subnet
resource "azurerm_subnet" "web" {
  name                 = var.sg_name
  resource_group_name  = azurerm_resource_group.rg.name
  virtual_network_name = azurerm_virtual_network.vnet.name
  address_prefixes     = [cidrsubnet(var.address_space, 1, 1)]
  # cidrsubnet calculate the subnet address within the gigen ip address
  depends_on = [azurerm_virtual_network.vnet]
}


# create a resource for public ip 
resource "azurerm_public_ip" "webip" {
  name                = var.pub_ip.name
  location            = azurerm_resource_group.rg.location
  resource_group_name = azurerm_resource_group.rg.name
  allocation_method   = var.pub_ip.allocation_method
  depends_on          = [azurerm_resource_group.rg]

}

# create rules for public ip 
resource "azurerm_publicip_rules" "rules" {
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

# create a resource for virtual machine
resource "azurerm_linux_virtual_machine" "web" {
  name                = "workshop-vm"
  resource_group_name = azurerm_resource_group.rg.name
  location            = azurerm_resource_group.rg.location
  size                = "Standard_B1s"
  network_interface_ids = [
    azurerm_network_interface.web.id,
  ]
  admin_username = "Jarvis"
  admin_ssh_key {
    username   = "Jarvis"
    public_key = file("~/.ssh/id_rsa.pub")
  }
  os_disk {
    caching              = "ReadWrite"
    storage_account_type = "Standard_LRS"
  }

  source_image_reference {
    publisher = "Canonical"
    offer     = "0001-com-ubuntu-server-jammy"
    sku       = "22_04-lts"
    version   = "latest"
  }

  # to connect to linux macnine the connection we have to give 
  connection {
    type        = "ssh"
    user        = "Jarvis"
    private_key = file("~/.ssh/id_rsa")
    host        = self.public_ip_address
    # here self dicribe the that you want to use your own machine whiche is created
  }

  # provisioner are the scrip i which we can login into linux machine and can do the extera activities
  provisioner "file" {
    source      = "springpetclinic.service"
    destination = "/tmp/springpetclinic.service"

  }

  provisioner "remote-exec" {
    inline = [
      "sudo apt update",
      "sudo apt install openjdk-17-jdk -y",
      "wget https://referenceapplicationskhaja.s3.us-west-2.amazonaws.com/spring-petclinic-3.1.0-SNAPSHOT.jar"
    ]

  }

  depends_on = [azurerm_network_interface.web]

}