resource "openstack_compute_instance_v2" "nfs-server" {
  name            = "${var.name_prefix}nfs${var.name_suffix}"
  image_name      = "${var.image}"
  flavor_name     = "${var.flavors["nfs-server"]}"
  key_pair        = "${openstack_compute_keypair_v2.my-cloud-key.name}"
  security_groups = "${var.secgroups}"
  network         = "${var.network}"
  power_state     = "${var.condor_clusterState}"

  block_device {
    uuid                  = "${var.image_id}"
    source_type           = "image"
    destination_type      = "local"
    boot_index            = 0
    delete_on_termination = true
  }

  block_device {
    uuid                  = "${openstack_blockstorage_volume_v2.volume_nfs_data.id}"
    source_type           = "volume"
    destination_type      = "volume"
    boot_index            = -1
    delete_on_termination = true
  }

  user_data = "${data.template_cloudinit_config.nfs-share.rendered}"
}

resource "openstack_blockstorage_volume_v2" "volume_nfs_data" {
  name = "${var.name_prefix}volume_nfs_data"
  size = "${var.nfs_disk_size}"
}

data "template_cloudinit_config" "nfs-share" {
  gzip          = true
  base64_encode = true

  part {
    content_type = "text/x-shellscript"
    content      = "${file("${path.module}/files/create_share.sh")}"
  }

  part {
    content_type = "text/cloud-config"

    content = <<-EOF
    #cloud-config
    write_files:
    - content: |
        /data/share *(rw,sync)
      owner: root:root
      path: /etc/exports
      permissions: '0644'
    runcmd:
     - [ mkdir, -p, /data/share ]
     - [ chown, "centos:centos", -R, /data/share ]
     - [ systemctl, enable, nfs-server ]
     - [ systemctl, start, nfs-server ]
     - [ exportfs, -avr ]
   EOF
  }
}
