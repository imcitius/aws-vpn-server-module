variable "aws_region" {}
variable "ssh_key_name" {}
variable "servers_count" {
    default = "1"
}
variable "dns_domain" {}
variable "cloudflare_zone_id" {}
variable "vpn_ami_id" {}
variable "vpn_instance_type" {}
variable "ansible_project" {}