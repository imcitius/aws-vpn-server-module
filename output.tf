output "public_ip" {
  description = "List of public IP addresses assigned to the instances, if applicable"
  value       = "${tolist(aws_instance.vpn.*.public_ip)}"
}
