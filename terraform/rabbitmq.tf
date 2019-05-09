resource "openstack_compute_instance_v2" "rabbitmq-server" {
  name            = "${var.name_prefix}rabbitmq${var.name_suffix}"
  image_name      = "${var.image}"
  flavor_name     = "${var.flavors["rabbitmq-server"]}"
  key_pair        = "${openstack_compute_keypair_v2.my-cloud-key.name}"
  security_groups = "${var.secgroups}"
}
