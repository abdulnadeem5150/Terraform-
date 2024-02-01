resource "azurerm_linux_virtual_machine" "web" {
  name                = "web"
  resource_group_name = azurerm_resource_group.ntire.name
  location            = var.location
  size                = "Standard_B1"
  // change the admin
  admin_username                  = "adminuser"
  admin_password                  = "admin@123"
  disable_password_authentication = false
  network_interface_ids = [
    azurerm_network_interface.webnic
  ]

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


}

resource "azurerm_linux_virtual_machine" "business" {
  name = "business"
resource_group_name = azurerm_resource_group.ntire.name
  location            = var.location
  size                = "Standard_B1"
  // change the admin
  admin_username                  = "adminuser"
  admin_password                  = "admin@123"
  disable_password_authentication = false
  network_interface_ids = [
    azurerm_network_interface.webnic
  ]

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
  
}

resource "azurerm_linux_virtual_machine" "data" {
  name = "data"
resource_group_name = azurerm_resource_group.ntire.name
  location            = var.location
  size                = "Standard_B1"
  // change the admin
  admin_username                  = "adminuser"
  admin_password                  = "admin@123"
  disable_password_authentication = false
  network_interface_ids = [
    azurerm_network_interface.webnic
  ]

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
  
}