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
