resource "openstack_compute_instance_v2" "pulsar-server" {
  name            = "${var.name_prefix}pulsar${var.name_suffix}"
  image_name      = "${var.image}"
  flavor_name     = "${var.flavors["pulsar-server"]}"
  key_pair        = "${openstack_compute_keypair_v2.my-cloud-key.name}"
  security_groups = "${var.secgroups}"

  user_data = <<-EOF
    #cloud-config
    write_files:
    - content: |
        CONDOR_HOST = ${cloudflare_record.central-manager.hostname}
        ALLOW_WRITE = *
        ALLOW_READ = $(ALLOW_WRITE)
        ALLOW_NEGOTIATOR = *
        ALLOW_OWNER = $(ALLOW_ADMINISTRATOR)
        ALLOW_CLIENT = *
        DAEMON_LIST = COLLECTOR, MASTER, NEGOTIATOR, SCHEDD
        FILESYSTEM_DOMAIN = vgcn
        UID_DOMAIN = vgcn
        TRUST_UID_DOMAIN = True
        SOFT_UID_DOMAIN = True
        # http://research.cs.wisc.edu/htcondor/manual/v8.6/3_5Configuration_Macros.html#sec:Collector-Config-File-Entries
        # Keep classads for only 5 minutes which should mean dead cloud nodes are expired much faster.
        CLASSAD_LIFETIME = 300
        # Try and consider new negotations a little bit sooner?
        NEGOTIATOR_INTERVAL = 30
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
     - [ chown, "centos:centos", -R, /mnt/pulsar ]
     - [ systemctl, enable, nfs-server ]
     - [ systemctl, start, nfs-server ]
     - [ exportfs, -avr ]
  EOF
}
