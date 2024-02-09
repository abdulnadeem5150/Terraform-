# Create a resource group

resource "azurerm_resource_group" "rg" {
  name     = var.resource_group.name
  location = var.resource_group.location

}

resource "azurerm_virtual_network" "vnet" {
  name                = var.vn_name
  address_space       = [var.address_space]
  location            = azurerm_resource_group.rg.location
  resource_group_name = azurerm_resource_group.rg.name
  depends_on          = [azurerm_resource_group.rg]
}

resource "azurerm_subnet" "web" {
  name                 = var.sg_name
  resource_group_name  = azurerm_resource_group.rg.name
  virtual_network_name = azurerm_virtual_network.vnet.name
  address_prefixes     = [cidrsubnet(var.address_space,1,1)]
  depends_on           = [azurerm_virtual_network.vnet]
}

resource "azurerm_public_ip" "webip" {
  name                = var.pub_ip.name
  location            = azurerm_resource_group.rg.location
  resource_group_name = azurerm_resource_group.rg.name
  allocation_method   = var.pub_ip.allocation_method
  depends_on          = [azurerm_resource_group.rg]

}

resource "azurerm_network_interface" "web" {
  name                = "workshop-nic"
  location            = azurerm_resource_group.rg.location
  resource_group_name = azurerm_resource_group.rg.name

  ip_configuration {
    name                          = var.net_inter.name
    subnet_id                     = azurerm_subnet.web.id
    private_ip_address_allocation = var.net_inter.private_ip_address_allocation
    public_ip_address_id          = azurerm_public_ip.webip.id
  }
  depends_on = [azurerm_subnet.web, azurerm_public_ip.webip]
}


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

  connection {
    type        = "ssh"
    user        = "Jarvis"
    private_key = file("~/.ssh/id_rsa")
    host        = self.public_ip_address

  }

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