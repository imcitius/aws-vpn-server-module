resource "aws_key_pair" "ssh" {
  key_name   = var.ssh_key_name
  public_key = var.sh_public_key
}
