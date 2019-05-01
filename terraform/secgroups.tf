resource "openstack_networking_secgroup_v2" "ingress-public" {
  name                 = "vgcn-ingress-public"
  description          = "Allow incoming connection from this host and internal traffic"
  delete_default_rules = true
}

resource "openstack_networking_secgroup_rule_v2" "ingress-public-4" {
  direction         = "ingress"
  ethertype         = "IPv4"
  remote_ip_prefix  = "${data.http.local-ip.body}/24"
  security_group_id = "${openstack_networking_secgroup_v2.ingress-public.id}"
}
resource "openstack_networking_secgroup_rule_v2" "ingress-internal-4" {
  direction         = "ingress"
  ethertype         = "IPv4"
  remote_group_id   = "${openstack_networking_secgroup_v2.ingress-public.id}"
  security_group_id = "${openstack_networking_secgroup_v2.ingress-public.id}"
}

# resource "openstack_networking_secgroup_rule_v2" "ingress-public-6" {
#   direction         = "ingress"
#   ethertype         = "IPv6"
#   security_group_id = "${openstack_networking_secgroup_v2.ingress-public.id}"
# }

resource "openstack_networking_secgroup_v2" "egress-public" {
  name                 = "vgcn-egress-public"
  description          = "Allow any outgoing connection"
  delete_default_rules = true
}

resource "openstack_networking_secgroup_rule_v2" "egress-public-4" {
  direction         = "egress"
  ethertype         = "IPv4"
  security_group_id = "${openstack_networking_secgroup_v2.egress-public.id}"
}

# resource "openstack_networking_secgroup_rule_v2" "egress-public-6" {
#   direction         = "egress"
#   ethertype         = "IPv6"
#   security_group_id = "${openstack_networking_secgroup_v2.egress-public.id}"
# }

data "http" "local-ip" {
   url = "http://icanhazip.com"
}
