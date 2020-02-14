variable "aws_region" {}
variable "vpn_ami_id" {}
variable "vpn_instance_type" {}
variable "ssh_key_name" {}
variable "ssh_public_key" {}
variable "servers_count" {
    default = "1"
}
variable "dns_global_domain" {}
variable "dns_vpn_subdomain" {}
variable "cloudflare_zone_id" {}
variable "ansible_project" {}

variable "tg_chat_id" {}
variable "tg_token" {}

variable "aws_iam_role_iam_for_lambda" {}
