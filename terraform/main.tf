variable "condor_clusterState" {
  default = "active"
}

resource "openstack_compute_instance_v2" "central-manager" {
  name            = "${var.name_prefix}central-manager${var.name_suffix}"
  flavor_name     = "${var.flavors["central-manager"]}"
  image_name        = "${var.image}"
  key_pair        = "${openstack_compute_keypair_v2.my-cloud-key.name}"
  security_groups = "${var.secgroups}"
  network         = "${var.network}"
  power_state     = "${var.condor_clusterState}"

  user_data = <<-EOF
    #cloud-config
    write_files:
    - content: |
        CONDOR_HOST = localhost
        ALLOW_WRITE = *
        ALLOW_READ = $(ALLOW_WRITE)
        ALLOW_NEGOTIATOR = $(ALLOW_WRITE)
        DAEMON_LIST = COLLECTOR, MASTER, NEGOTIATOR, SCHEDD
        FILESYSTEM_DOMAIN = vgcn
        UID_DOMAIN = vgcn
        TRUST_UID_DOMAIN = True
        SOFT_UID_DOMAIN = True
      owner: root:root
      path: /etc/condor/condor_config.local
      permissions: '0644'
    - content: |
        /data           /etc/auto.data          nfsvers=3
      owner: root:root
      path: /etc/auto.master.d/data.autofs
      permissions: '0644'
    - content: |
        share  -rw,hard,intr,nosuid,quota  ${cloudflare_record.nfs-server.hostname}:/data/share
      owner: root:root
      path: /etc/auto.data
      permissions: '0644'
    - content: |
        /mnt/pulsar/dependencies *(rw,sync)
      owner: root:root
      path: /etc/exports
      permissions: '0644'
    runcmd:
     - [ mkdir, -p, /mnt/pulsar/dependencies ]
     - [ chown, "centos:centos", -R, /mnt/pulsar/dependencies ]
     - [ systemctl, enable, nfs-server ]
     - [ systemctl, start, nfs-server ]
     - [ exportfs, -avr ]
  EOF
}

resource "openstack_compute_instance_v2" "exec-node" {
  count           = "${var.exec_node_count}"
  name            = "${var.name_prefix}exec-node-${count.index}${var.name_suffix}"
  flavor_name     = "${var.flavors["exec-node"]}"
  image_name        = "${var.image}"
  key_pair        = "${openstack_compute_keypair_v2.my-cloud-key.name}"
  security_groups = "${var.secgroups}"
  network         = "${var.network}"
  power_state     = "${var.condor_clusterState}"

  user_data = <<-EOF
    #cloud-config
    write_files:
    - content: |
        CONDOR_HOST = ${cloudflare_record.central-manager.hostname}
        ALLOW_WRITE = *
        ALLOW_READ = $(ALLOW_WRITE)
        ALLOW_ADMINISTRATOR = *
        ALLOW_NEGOTIATOR = $(ALLOW_ADMINISTRATOR)
        ALLOW_CONFIG = $(ALLOW_ADMINISTRATOR)
        ALLOW_DAEMON = $(ALLOW_ADMINISTRATOR)
        ALLOW_OWNER = $(ALLOW_ADMINISTRATOR)
        ALLOW_CLIENT = *
        DAEMON_LIST = MASTER, SCHEDD, STARTD
        FILESYSTEM_DOMAIN = vgcn
        UID_DOMAIN = vgcn
        TRUST_UID_DOMAIN = True
        SOFT_UID_DOMAIN = True
        # run with partitionable slots
        CLAIM_PARTITIONABLE_LEFTOVERS = True
        NUM_SLOTS = 1
        NUM_SLOTS_TYPE_1 = 1
        SLOT_TYPE_1 = 100%
        SLOT_TYPE_1_PARTITIONABLE = True
        ALLOW_PSLOT_PREEMPTION = False
        STARTD.PROPORTIONAL_SWAP_ASSIGNMENT = True
      owner: root:root
      path: /etc/condor/condor_config.local
      permissions: '0644'
    - content: |
        /data           /etc/auto.data          nfsvers=3
        /mnt/pulsar /etc/auto.dep nfsvers=3
      owner: root:root
      path: /etc/auto.master.d/data.autofs
      permissions: '0644'
    - content: |
        share  -rw,hard,intr,nosuid,quota  ${cloudflare_record.nfs-server.hostname}:/data/share
      owner: root:root
      path: /etc/auto.data
      permissions: '0644'
    - content: |
        dependencies  -hard,intr,nosuid, ${cloudflare_record.pulsar-server.hostname}:/mnt/pulsar/dependencies
      owner: root:root
      path: /etc/auto.dep
      permissions: '0644'
  EOF
}
