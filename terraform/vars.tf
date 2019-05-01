variable "nfs_disk_size" {
  default = 3
}

variable "flavors" {
  type = "map"
  default = {
    "central-manager" = "m1.tiny"
    "exec-node" = "m1.tiny"
    "nfs-server" = "m1.tiny"
    "pulsar-server" = "m1.medium"
    "galaxy-server" = "m1.medium"
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

variable "public_key" {
  default = "ssh-rsa blablabla"
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
  default = ".uni.example.com"
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
