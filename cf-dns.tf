resource "cloudflare_record" "vpn-servers" {

  count = var.servers_count

  zone_id = var.cloudflare_zone_id
  name    = "${var.aws_region}.${var.dns_domain}"
  value   = element(aws_instance.vpn.*.public_ip, count.index)
  type    = "A"
  ttl     = 600

  depends_on = [aws_instance.vpn]
}
