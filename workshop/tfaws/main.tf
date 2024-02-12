resource "aws_instance" "web" {
  ami                         = "ami-008fe2fc65df48dac"
  instance_type               = "t2.micro"
  associate_public_ip_address = true
  key_name                    = "id_rsa"
  security_groups             = ["allopensg"]

  tags = {
    Name = "web"
  }

  connection {
    type        = "ssh"
    user        = "ubuntu"
    private_key = file("~/.ssh/id_rsa")
    host        = self.public_ip
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
}