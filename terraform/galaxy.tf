resource "openstack_compute_instance_v2" "galaxy-server" {
  name            = "${var.name_prefix}galaxy${var.name_suffix}"
  image_name      = "CentOS 7"
  flavor_name     = "${var.flavors["galaxy-server"]}"
  key_pair        = "${openstack_compute_keypair_v2.my-cloud-key.name}"
  security_groups = [
    "vgcn-ingress-public",
    "vgcn-egress-public",
    "vgcn-ingress-public-http"
  ]
  user_data = <<-EOF
    #cloud-config
  EOF
}
