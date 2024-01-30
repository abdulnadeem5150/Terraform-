resource_group_name = "ntire"
location            = "eastus"
address_space       = "192.168.0.0/16"
subnet_names        = ["web", "app", "db"]
nsgs_name  = [ "web", "app", "db" ]

webnsg_rules_info = [{
  name                       = "AllowHttp"
  protocol                   = "Tcp"
  source_address_prefix      = "*"
  source_port_range          = "*"
  destination_address_prefix = "*"
  destination_port_range     = "80"
  direction                  = "Inbound"
  access                     = "Allow"
  priority                   = 300
  nsgs_name = "web"
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
    nsgs_name = "web"
  },
  {
    name                       = "Allowssh"
    protocol                   = "Tcp"
    source_address_prefix      = "*"
    source_port_range          = "*"
    destination_address_prefix = "*"
    destination_port_range     = "22"
    direction                  = "Inbound"
    access                     = "Allow"
    priority                   = 320
    nsgs_name = "web"
  }
]