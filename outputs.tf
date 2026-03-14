output "monitoring_ip" {
  value = proxmox_virtual_environment_vm.monitoring.ipv4_addresses[1][0]
}

output "monitoring_vm_id" {
  value = proxmox_virtual_environment_vm.monitoring.vm_id
}