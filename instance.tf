resource "aws_instance" "vpn" {

  count = var.servers_count

  ami           = var.vpn_ami_id
  instance_type = var.vpn_instance_type
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
    command = "echo '[faceless-vpn-server-ike]' > vpn_server_${self.id}.txt"
  }

  provisioner "local-exec" {
    command = "echo '${self.public_ip} id=${self.id} aws_region=${var.aws_region}' >> vpn_server_${self.id}.txt"
  }

  provisioner "local-exec" {
    command = "echo '[all:vars]' >> vpn_server_${self.id}.txt"
  }

  provisioner "local-exec" {
    command = "echo 'project=${ANSIBLE_PROJECT}' >> vpn_server_${self.id}.txt"
  }

  provisioner "local-exec" {
    command = "./provision.sh ${self.id}"
  }

  provisioner "local-exec" {
    when    = destroy
    command = "rm -f vpn_server_${self.id}.txt"
  }
}
