module "ec2_instance" {
  source = "terraform-aws-modules/ec2-instance/aws"

  name = "terraform"

  instance_type          = "t2.micro"
  key_name               = "id_rsa"
  monitoring             = true
  vpc_security_group_ids = ["sg-00632eda30db2d3e5"]
  subnet_id              = "subnet-0b524abd7174c3187"

  tags = {
    Terraform   = "true"
    Environment = "dev"
  }
}