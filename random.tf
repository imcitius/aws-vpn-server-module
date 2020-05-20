resource "random_integer" "dhcp" {
  min     = 11
  max     = 254
  
  keepers = {
    listener_arn = "${aws_instance.vpn}"
  }
}