# infra.auto.tfvars

vm_map = {
  "proxy" = {
    ip_address = "192.168.100.10/24"
    cores      = 1
    tags       = ["terraform", "proxy"]
    pool_id    = "Homelab"
  }

  "streaming" = {
    ip_address = "192.168.100.11/24"
    cores      = 4
    memory     = 4096
    tags       = ["terraform", "media"]
    hostpci_devices = [
      {
        device  = "hostpci0"
        mapping = "igpu"
      }
    ]
    pool_id    = "Homelab"
  }

  "arr" = {
    ip_address = "192.168.100.12/24"
    memory     = 3072
    tags       = ["terraform", "media"]
    pool_id    = "Homelab"
  }

  "downloader" = {
    ip_address = "192.168.100.13/24"
    memory     = 4096
    tags       = ["terraform", "media"]
    pool_id    = "Homelab"
  }

  "monitoring" = {
    ip_address = "192.168.100.14/24"
    tags       = ["terraform", "monitoring"]
    pool_id    = "Homelab"
  }

  "library" = {
    ip_address = "192.168.100.15/24"
    tags       = ["terraform", "media"]
    pool_id    = "Homelab"
  }
}
