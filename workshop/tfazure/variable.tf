variable "resource_group" {
  type = object({
    name     = string
    location = string
  })
  default = {
    name     = "workshop"
    location = "eastus"
  }
}
variable "vn_name" {
  type    = string
  default = "workshop-network"

}

variable "address_space" {
  type    = string
  default = "10.100.0.0/16"
}

variable "sg_name" {
  type    = string
  default = "internal"
}

variable "pub_ip" {
  type = object({
    name              = string
    allocation_method = string
  })
  default = {
    name              = "webip"
    allocation_method = "Static"
  }

}

variable "net_inter" {
  type = object({
    name                          = string
    private_ip_address_allocation = string
  })
  default = {
    name                          = "iniernal"
    private_ip_address_allocation = "Dynamic"
  }

}