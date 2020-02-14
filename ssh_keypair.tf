resource "aws_key_pair" "ssh" {
  key_name   = ssh_key_name
  public_key = ssh_public_key
}
