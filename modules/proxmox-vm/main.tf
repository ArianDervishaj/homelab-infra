# modules/proxmox-vm/main.tf

terraform {
  required_providers {
    proxmox = {
      source  = "bpg/proxmox"
      version = "~> 0.78"
    }
  }
}

resource "proxmox_virtual_environment_vm" "this" {
  name      = var.vm_name
  node_name = var.node_name
  tags      = var.tags
  started   = var.started
  pool_id   = var.pool_id

  scsi_hardware = "virtio-scsi-single"

  clone {
    vm_id = var.template_id
  }

  cpu {
    cores = var.cpu_cores
    type  = "host"
  }

  memory {
    dedicated = var.memory
  }

  agent {
    enabled = true
  }

  network_device {
    bridge = var.bridge
  }

  dynamic "hostpci" {
    for_each = var.hostpci_devices
    content {
      device  = hostpci.value.device
      id      = hostpci.value.id
      mapping = hostpci.value.mapping
      pcie    = hostpci.value.pcie != null ? hostpci.value.pcie : false
      rombar  = hostpci.value.rombar != null ? hostpci.value.rombar : true
      xvga    = hostpci.value.xvga != null ? hostpci.value.xvga : false
    }
  }

  disk {
    interface    = "scsi0"
    datastore_id = var.disk_datastore
    size         = var.disk_size
    discard      = "on"
    iothread     = true
  }

  initialization {
    user_data_file_id = var.cloud_init_file_id

    ip_config {
      ipv4 {
        address = var.ip_address
        gateway = var.gateway
      }
    }

    dns {
      servers = var.dns_servers
    }
  }

  lifecycle {
    ignore_changes = [pool_id]
  }
}
