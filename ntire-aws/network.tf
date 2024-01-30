resource "aws_vpc" "ntier-primary" {
  cidr_block = var.vpc_cidr

  tags = {
    Name = "ntier"
  }
}

resource "aws_subnet" "subnets" {
  count      = length(var.subnet_names)
  vpc_id     = aws_vpc.ntier-primary.id
  cidr_block = cidrsubnet(var.vpc_cidr, 8, count.index)
  tags = {
    Name = var.subnet_names[count.index]
  }
}

resource "aws_security_group" "open-ssh-http" {

  name        = "open-ssh-http"
  vpc_id      = aws_vpc.ntier-primary.id
  depends_on  = [aws_vpc.ntier-primary]
  description = "open-ssh-http"
}

resource "aws_vpc_security_group_ingress_rule" "sg_rules" {
  security_group_id = aws_security_group.open-ssh-http.id
  ip_protocol       = "tcp"
  cidr_ipv4         = "0.0.0.0/0"
  from_port         = 22
  to_port           = 22

}