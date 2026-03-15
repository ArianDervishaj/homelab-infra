# outputs.tf

output "vm_ips" {
  description = "Map of VM names to their configured static IPs"
  value       = { for name, vm in module.vm : name => vm.ip_address }
}

output "vm_ids" {
  description = "Map of VM names to their Proxmox VM IDs"
  value       = { for name, vm in module.vm : name => vm.vm_id }
}
