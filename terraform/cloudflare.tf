resource "cloudflare_record" "galaxy-server" {
  domain = "${var.cloudflare_zone}"
  name   = "galaxy.uni"
  value  = "${openstack_compute_instance_v2.galaxy-server.access_ip_v4}"
  type   = "A"
  ttl    = 120
}

resource "cloudflare_record" "pulsar-server" {
  domain = "${var.cloudflare_zone}"
  name   = "pulsar.uni"
  value  = "${openstack_compute_instance_v2.pulsar-server.access_ip_v4}"
  type   = "A"
  ttl    = 120
}

resource "cloudflare_record" "central-manager" {
  domain = "${var.cloudflare_zone}"
  name   = "condor-manager.uni"
  value  = "${openstack_compute_instance_v2.central-manager.access_ip_v4}"
  type   = "A"
  ttl    = 120
}

resource "cloudflare_record" "nfs-server" {
  domain = "${var.cloudflare_zone}"
  name   = "nfs.uni"
  value  = "${openstack_compute_instance_v2.nfs-server.access_ip_v4}"
  type   = "A"
  ttl    = 120
}

resource "cloudflare_record" "exec-node" {
  count  = "${var.exec_node_count}"
  domain = "${var.cloudflare_zone}"
  name   = "exec-node-${count.index}.uni"
  value  = "${element(openstack_compute_instance_v2.exec-node.*.access_ip_v4, count.index)}"
  type   = "A"
  ttl    = 120
}
