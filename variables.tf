variable "aws_region" {}
variable "ssh_key_name" {}
variable "servers_count" {
    default = "1"
}
variable "dns_vpn_subdomain" {}
variable "cloudflare_zone_id" {}
variable "vpn_ami_id" {}
variable "vpn_instance_type" {}
variable "ansible_project" {}
variable "dns_global_domain" {}