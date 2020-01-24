data "aws_ami" "ubuntu" {
  most_recent = true

  filter {
    name   = "name"
    values = ["ubuntu/images/hvm-ssd/ubuntu-xenial-16.04-amd64-server-*"]
  }

  filter {
    name   = "virtualization-type"
    values = ["hvm"]
  }

  owners = ["099720109477"] # Canonical
}

resource "aws_instance" "vpn" {

  count = var.servers_count

  ami           = data.aws_ami.ubuntu.id
  instance_type = "t2.micro"
  key_name = var.ssh_key_name
  associate_public_ip_address = true
  private_ip = element(data.template_file.ip.*.rendered, count.index)

  subnet_id = aws_subnet.vpn.id

  vpc_security_group_ids = [
    aws_security_group.vpn.id
  ]

  tags = {
    Name = element(data.template_file.name.*.rendered, count.index)
  }

  provisioner "local-exec" {
    command = "echo ${self.public_ip} >> public_ip.txt"
  }

#  provisioner "local-exec" {
#    command = "./provision.sh"
#  }

}
