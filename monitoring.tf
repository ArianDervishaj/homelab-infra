resource "proxmox_virtual_environment_vm" "monitoring" {
  name          = "monitoring-vm"
  node_name     = var.node_name
  scsi_hardware = "virtio-scsi-single"

  clone {
    vm_id = var.template_id
  }

  cpu {
    cores = 2
    type  = "host"
  }

  memory {
    dedicated = 2048
  }

  agent {
    enabled = true
  }

  network_device {
    bridge = "vmbr1"
  }

  disk {
    interface    = "scsi0"
    datastore_id = "local-lvm"
    size         = 32
    discard      = "on"
    iothread     = true
  }

  initialization {
    user_data_file_id = proxmox_virtual_environment_file.cloud_config.id

    ip_config {
      ipv4 {
        address = "192.168.100.14/24"
        gateway = "192.168.100.1"
      }
    }

    dns {
      servers = ["192.168.1.225"]
    }

  }
}
