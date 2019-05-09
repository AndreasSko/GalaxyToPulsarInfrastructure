variable "nfs_disk_size" {
  default = 20
}

variable "galaxy_disk_size" {
  default = 20
}

variable "flavors" {
  type = "map"

  default = {
    "central-manager" = "m1.tiny"
    "exec-node"       = "m1.tiny"
    "nfs-server"      = "m1.tiny"
    "pulsar-server"   = "m1.medium"
    "rabbitmq-server" = "m1.tiny"
    "galaxy-server"   = "m1.medium"
  }
}

variable "exec_node_count" {
  default = 1
}

variable "image" {
  default = "vgcn-image"
}

variable "image_id" {
  default = "42271322-6626-49b8-8907-9cdc3288963f"
}

variable "centos_image_id" {
  default = "51478426-3a25-4121-952d-42760be6f03f"
}

variable "public_key" {
  default = "ssh-rsa AAAAB3NzaC1yc2EAAAADAQABAAABAQCgxYCPARaL3HfjJkpjewh4t9NxJQ9sA05PVxS5LauXwyFD07DAA1uwJ4Mk0YJiITxgmtDHhP4OdALA1c6A87aEbi5GXAlcCzGRkabmruopdWFuGZXNF2zBdhMMJYc3rKEaoKbw50oBiNcz8+xwqSNB1NGG82JPTP0xL/hgfGuokBgKPkNqClH+H6m8ep7mbXySHY/glsdd+d4R+SgitNfYUVKEuIAVSg9VshkPtQGDbuqApfKY3YEA8G2oXJgcwH9ArYBHpTrxpWEu3RUmxxo1PcoCnRnY2j6GEFVs9qd9fJuGAfDUExmknW8kHc1qIScl+xD3vBESblZh8DISKYZR"
}

variable "cloudflare_email" {
  type = "string"
}

variable "cloudflare_token" {
  type = "string"
}

variable "cloudflare_zone" {
  type = "string"
}

variable "name_prefix" {
  default = ""
}

variable "name_suffix" {
  default = ".uni.andreas-sk.de"
}

variable "secgroups" {
  default = [
    "vgcn-ingress-public",
    "vgcn-egress-public",
  ]
}

variable "network" {
  default = [
    {
      name = "public"
    },
  ]
}
