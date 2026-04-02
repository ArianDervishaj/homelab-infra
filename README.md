# Homelab Terraform

Terraform configuration for provisioning VMs on Proxmox VE. Handles VM creation, cloud-init bootstrapping, and resource allocation. Once provisioned, VMs are configured by [homelab-ansible](https://github.com/ArianDervishaj/homelab).

## Overview

VMs are defined as a map in `infra.auto.tfvars` and provisioned through a reusable module. Each VM is cloned from a cloud-init template, assigned a static IP on the homelab subnet (`192.168.100.0/24`), and bootstrapped with an SSH user and qemu-guest-agent.

## Architecture

- **Provider:** [bpg/proxmox](https://registry.terraform.io/providers/bpg/proxmox)
- **VM module:** `modules/proxmox-vm` reusable module handling clone, CPU, memory, disk, networking, and optional PCI passthrough
- **Cloud-init:** Bootstraps each VM with a user, SSH key, and guest agent

## Current VMs

| VM | IP | Resources | Tags | Notes |
|---|---|---|---|---|
| proxy | 192.168.100.10/24 | 1 core, 2GB RAM, 32GB disk | terraform, proxy | |
| streaming | 192.168.100.11/24 | 4 cores, 4GB RAM, 32GB disk | terraform, media | iGPU passthrough (UHD 770) |
| arr | 192.168.100.12/24 | 2 cores, 3GB RAM, 32GB disk | terraform, media | |
| downloader | 192.168.100.13/24 | 2 cores, 4GB RAM, 32GB disk | terraform, media | |
| monitoring | 192.168.100.14/24 | 2 cores, 2GB RAM, 32GB disk | terraform, monitoring | |
| library | 192.168.100.15/24 | 2 cores, 2GB RAM, 32GB disk | terraform, media | |

## Usage

### Prerequisites

- Proxmox VE host with a cloud-init VM template (ID 9000 by default)
- Proxmox API token with VM provisioning permissions
- SSH key pair for cloud-init user access
- `igpu` resource mapping configured in Proxmox for GPU passthrough (streaming VM)

### Deploy
```bash
terraform init
terraform plan
terraform apply

# Deploy a single VM
terraform apply -target='module.vm["downloader"]' -target='proxmox_virtual_environment_file.cloud_init["downloader"]'
```

### Adding a VM

Add an entry to `infra.auto.tfvars`:
```hcl
"my-new-vm" = {
  ip_address = "192.168.100.16/24"
  cores      = 2
  memory     = 4096
  tags       = ["terraform", "security"]
  pool_id    = "Homelab"
}
```

Only `ip_address` is required, everything else falls back to module defaults (2 cores, 2GB RAM, 32GB disk, `vmbr1` bridge).

### GPU Passthrough

The streaming VM uses Intel iGPU passthrough for Jellyfin hardware transcoding. This requires:
1. A `hostpci_devices` block in `infra.auto.tfvars` referencing the `igpu` resource mapping
2. IOMMU and `vfio-pci` configured on the Proxmox host
3. The `gpu_passthrough` Ansible role to replace the cloud kernel with the full kernel (cloud kernel lacks `i915` driver)