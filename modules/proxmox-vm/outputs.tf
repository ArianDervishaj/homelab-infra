# modules/proxmox-vm/outputs.tf

output "vm_id" {
  description = "Proxmox VM ID"
  value       = proxmox_virtual_environment_vm.this.vm_id
}

output "vm_name" {
  description = "VM hostname"
  value       = proxmox_virtual_environment_vm.this.name
}

output "ip_address" {
  description = "Configured static IPv4 address (CIDR)"
  value       = var.ip_address
}
