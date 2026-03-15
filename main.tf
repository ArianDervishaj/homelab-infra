# main.tf

terraform {
  required_providers {
    proxmox = {
      source  = "bpg/proxmox"
      version = "~> 0.78"
    }
  }
}

provider "proxmox" {
  endpoint  = var.proxmox_url
  api_token = var.proxmox_api_token
  insecure  = true # uses a self signed cert

  ssh {
    agent    = true
    username = "root"
  }
}

locals {
  gateway     = "192.168.100.1"
  dns_servers = ["192.168.1.225"]
}

module "vm" {
  source   = "./modules/proxmox-vm"
  for_each = var.vm_map

  vm_name            = each.key
  node_name          = var.node_name
  template_id        = var.template_id
  ip_address         = each.value.ip_address
  gateway            = local.gateway
  dns_servers        = local.dns_servers
  cloud_init_file_id = proxmox_virtual_environment_file.cloud_init[each.key].id

  # Override module defaults only when the map entry specifies a value
  cpu_cores = each.value.cores != null ? each.value.cores : 2
  memory    = each.value.memory != null ? each.value.memory : 2048
  disk_size = each.value.disk_size != null ? each.value.disk_size : 32
  bridge    = each.value.bridge != null ? each.value.bridge : "vmbr1"
  tags      = each.value.tags != null ? each.value.tags : ["terraform"]
  started   = each.value.started != null ? each.value.started : true
  hostpci_devices = each.value.hostpci_devices != null ? each.value.hostpci_devices : []
}