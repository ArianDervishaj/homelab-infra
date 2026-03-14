variable "proxmox_url" {
  description = "Proxmox API URL"
  type        = string
}

variable "proxmox_api_token" {
  description = "Proxmox API token (format: user@realm!token-name=secret)"
  type        = string
  sensitive   = true
}

variable "ssh_public_key" {
  description = "SSH public key for cloud-init"
  type        = string
}

variable "ssh_username" {
  description = "Default SSH username for cloud-init"
  type        = string
  default     = "nuggets"
}

variable "node_name" {
  description = "Proxmox node name"
  type        = string
  default     = "pve-homelab"
}

variable "template_id" {
  description = "VM ID of the cloud-init template"
  type        = number
  default     = 9000
}