# modules/proxmox-vm/variables.tf

variable "vm_name" {
  description = "Hostname of the VM (used as Proxmox display name)"
  type        = string
}

variable "node_name" {
  description = "Proxmox node to place the VM on"
  type        = string
}

variable "template_id" {
  description = "VM ID of the cloud-init template to clone"
  type        = number
}

variable "cpu_cores" {
  description = "Number of vCPU cores"
  type        = number
  default     = 2
}

variable "memory" {
  description = "Dedicated RAM in MB"
  type        = number
  default     = 2048
}

variable "disk_size" {
  description = "Boot disk size in GB"
  type        = number
  default     = 32
}

variable "disk_datastore" {
  description = "Proxmox datastore for the VM disk"
  type        = string
  default     = "local-lvm"
}

variable "bridge" {
  description = "Network bridge to attach the VM to"
  type        = string
  default     = "vmbr1"
}

variable "ip_address" {
  description = "Static IPv4 address in CIDR notation (e.g., 192.168.100.14/24)"
  type        = string

  validation {
    condition     = can(cidrhost(var.ip_address, 0))
    error_message = "ip_address must be valid CIDR notation (e.g., 192.168.100.14/24)."
  }
}

variable "gateway" {
  description = "IPv4 default gateway"
  type        = string
}

variable "dns_servers" {
  description = "List of DNS server IPs"
  type        = list(string)
}

variable "cloud_init_file_id" {
  description = "Proxmox file ID of the cloud-init user-data snippet"
  type        = string
}

variable "tags" {
  description = "Tags to apply to the VM in Proxmox"
  type        = list(string)
  default     = ["terraform"]
}

variable "started" {
  description = "Whether the VM should be started after creation"
  type        = bool
  default     = true
}

variable "hostpci_devices" {
  description = "PCI devices to pass through to the VM (e.g., iGPU for hardware transcoding)"
  type = list(object({
    device  = string           # Proxmox slot name: hostpci0, hostpci1, etc.
    id      = optional(string) # PCI address: 0000:00:02 OR mapping
    mapping = optional(string) # Proxmox resource mapping name  OR id
    pcie    = optional(bool)
    rombar  = optional(bool)
    xvga    = optional(bool)
  }))
  default = []
}