data "template_file" "name" {
  count    = var.servers_count
  template = "vpn-server-${count.index}"
}

data "template_file" "ip" {
  count    = var.servers_count
  template = "10.0.0.${count.index}"
}