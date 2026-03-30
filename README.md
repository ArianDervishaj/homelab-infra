# Homelab Terraform

Terraform configuration for provisioning VMs on Proxmox VE. Handles VM creation, cloud-init bootstrapping, and resource allocation. Once provisioned, VMs are configured by [homelab-ansible](https://github.com/ArianDervishaj/homelab).

## Overview

VMs are defined as a map in `infra.auto.tfvars` and provisioned through a reusable module. Each VM is cloned from a cloud-init template, assigned a static IP on the homelab subnet (`192.168.100.0/24`), and bootstrapped with an SSH user and qemu-guest-agent.

## Architecture

- **Provider:** [bpg/proxmox](https://registry.terraform.io/providers/bpg/proxmox)
- **VM module:** `modules/proxmox-vm` reusable module handling clone, CPU, memory, disk, networking, and optional PCI passthrough
- **Cloud-init:** Bootstraps each VM with a user, SSH key, and guest agent

## Current VMs

| VM | IP | Resources | Tags |
|---|---|---|---|
| monitoring | 192.168.100.14/24 | 2 cores, 2GB RAM, 32GB disk | terraform, monitoring |
| library | 192.168.100.15/24 | 2 cores, 2GB RAM, 32GB disk | terraform, media |

Other VMs (proxy, streaming, arr, downloader) are defined but commented out, they were provisioned manually before Terraform was introduced and are being migrated incrementally.

## Usage

### Prerequisites

- Proxmox VE host with a cloud-init VM template (ID 9000 by default)
- Proxmox API token with VM provisioning permissions
- SSH key pair for cloud-init user access

### Deploy
```bash
terraform init
terraform plan
terraform apply
```

### Adding a VM

Add an entry to `infra.auto.tfvars`:
```hcl
"my-new-vm" = {
  ip_address = "192.168.100.16/24"
  cores      = 2
  memory     = 4096
  tags       = ["terraform", "security"]
}
```

Only `ip_address` is required, everything else falls back to module defaults (2 cores, 2GB RAM, 32GB disk, `vmbr1` bridge).