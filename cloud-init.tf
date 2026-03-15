# cloud-init.tf

resource "proxmox_virtual_environment_file" "cloud_init" {
  for_each = var.vm_map

  content_type = "snippets"
  datastore_id = "local"
  node_name    = var.node_name

  source_raw {
    data = templatefile("${path.module}/templates/cloud-init-base.yml", {
      username       = var.ssh_username
      ssh_public_key = var.ssh_public_key
    })
    file_name = "cloud-init-${each.key}.yml"
  }
}
