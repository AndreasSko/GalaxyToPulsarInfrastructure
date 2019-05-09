resource "openstack_compute_instance_v2" "galaxy-server" {
  name            = "${var.name_prefix}galaxy${var.name_suffix}"
  image_name      = "${var.image}"
  flavor_name     = "${var.flavors["galaxy-server"]}"
  key_pair        = "${openstack_compute_keypair_v2.my-cloud-key.name}"
  security_groups = [
    "vgcn-ingress-public",
    "vgcn-egress-public",
  ]

  block_device {
      uuid                  = "${var.centos_image_id}"
      source_type           = "image"
      destination_type      = "local"
      boot_index            = 0
      delete_on_termination = true
    }

  block_device {
    uuid                  = "${openstack_blockstorage_volume_v2.volume_galaxy_data.id}"
    source_type           = "volume"
    destination_type      = "volume"
    boot_index            = -1
    delete_on_termination = true
  }

  user_data = "${data.template_cloudinit_config.galaxy-volume.rendered}"
}

resource "openstack_blockstorage_volume_v2" "volume_galaxy_data" {
  name = "${var.name_prefix}volume_galaxy_data"
  size = "${var.galaxy_disk_size}"
}

data "template_cloudinit_config" "galaxy-volume" {
  gzip          = true
  base64_encode = true

  part {
    content_type = "text/x-shellscript"
    content      = "${file("${path.module}/files/create_galaxy-volume.sh")}"
  }
}
