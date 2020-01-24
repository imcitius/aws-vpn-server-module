data "template_file" "name" {
  count    = var.count
  template = "${var.count > 1 ? "${var.name}-${element(random_pet.hostname.*.id, count.index)}" : var.name}"
}

data "template_file" "ip" {
  count    = var.count
  template = "10.0.0.${var.count + 1}"
}