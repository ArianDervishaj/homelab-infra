# infra.auto.tfvars

vm_map = {
  "proxy-vm-terra" = {
    ip_address = "192.168.100.20/24"
    cores      = 1
    tags       = ["terraform", "proxy"]
  }

  "streaming-vm-terra" = {
    ip_address = "192.168.100.21/24"
    cores      = 4
    memory     = 4096
    tags       = ["terraform", "media"]
    hostpci_devices = [
      {
        device = "hostpci0"
        mapping = "igpu"
      }
    ]
  }

  "arr-vm-terra" = {
    ip_address = "192.168.100.22/24"
    memory     = 3072
    tags       = ["terraform", "media"]
  }

  "downloader-vm-terra" = {
    ip_address = "192.168.100.23/24"
    memory     = 4096
    tags       = ["terraform", "media"]
  }

  "monitoring-vm-terra" = {
    ip_address = "192.168.100.24/24"
    tags       = ["terraform", "monitoring"]
  }
}
