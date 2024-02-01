variable "region" {
  type        = string
  default     = "us-east-1"
  description = "region in which resources will be created"
}

variable "vpc_cidr" {
  type    = string
  default = "10.100.0.0/16"
}

variable "subnetcount" {
  type    = number
  default = 3
}

variable "subnet_names" {
  type    = list(string)
  default = ["web", "business", "data"]

}

variable "aws_security_group" {
  type    = string
  default = "open-ssh-http"
}

variable "aws_security_group_ingress_rule" {
  type = list(object({
    ip_protocol = string
    cidr_ipv4   = string
    from_port   = number
    to_port     = number

  }))
  default = [{
    ip_protocol = "tcp"
    cidr_ipv4   = "0.0.0.0/0"
    from_port   = 22
    to_port     = 22
    },
    {
      ip_protocol = "tcp"
      cidr_ipv4   = "0.0.0.0/0"
      from_port   = 80
      to_port     = 80
    }
  ]


}