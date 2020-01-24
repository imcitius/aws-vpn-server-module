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

  count = var.count
  name = "${element(data.template_file.name.*.rendered, var.count.index)}"

  ami           = data.aws_ami.ubuntu.id
  instance_type = "t2.micro"
  key_name = ssh_key_name
  associate_public_ip_address = true
  private_ip = "${element(data.template_file.ip.*.rendered, var.count.index)}"

  subnet_id = aws_subnet.vpn.id

  vpc_security_group_ids = [
    aws_security_group.vpn.id
  ]

  tags = {
    Name = "vpn instance"
  }

#  provisioner "local-exec" {
#    command = "echo ${aws_instance.vpn.public_ip} >> private_ip.txt"
#  }

#  provisioner "local-exec" {
#    command = "./provision.sh"
#  }

}
