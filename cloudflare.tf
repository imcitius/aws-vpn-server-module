resource "cloudflare_record" "vpn-server-host" {

  count = var.servers_count

  zone_id = var.cloudflare_zone_id
  name    = "${element(aws_instance.vpn.*.id, count.index)}.${var.aws_region}"
  value   = element(aws_instance.vpn.*.public_ip, count.index)
  type    = "A"
  ttl     = 600

  depends_on = [aws_instance.vpn]
}

resource "cloudflare_record" "vpn-domain-region-name" {

  count = var.servers_count

  zone_id = var.cloudflare_zone_id
  name    = "${var.aws_region}.${var.dns_vpn_subdomain}.${var.dns_global_domain}"
  value   = element(aws_instance.vpn.*.public_ip, count.index)
  type    = "A"
  ttl     = 600

  depends_on = [aws_instance.vpn]
}

resource "cloudflare_record" "vpn-domain-default" {

  count = var.servers_count

  zone_id = var.cloudflare_zone_id
  name    = "${var.dns_vpn_subdomain}.${var.dns_global_domain}"
  value   = element(aws_instance.vpn.*.public_ip, count.index)
  type    = "A"
  ttl     = 600

  depends_on = [aws_instance.vpn]
}
