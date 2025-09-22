terraform {
  required_providers {
    proxmox = {
        # "registry.terraform.io/telmate/proxmox"
        source      = "telmate/proxmox"
        version     = "3.0.2-rc04"
    }
  }
}

provider "proxmox" {
    # if passthrough is used then only root can do the operation
    pm_user             = "root@pam"
    pm_password         = "Asdf@135"
    alias               = "pve1_root"
    pm_api_url          = "https://192.168.0.140:8006/api2/json"
    # pm_api_token_id     = "root@pam!root"
    # pm_api_token_secret = "a41415dc-2082-4671-9946-bcfe2a50f61d"
    pm_tls_insecure     = true

    pm_log_file         = "terraform-plugin-proxmox.log"
    pm_debug            = true
    pm_log_levels       = {
        _default        = "debug"
        _capturelog     = ""
    }
    pm_timeout = 300
}

variable "ubuntu" {
  type = map
  default = {
    "vmid"          = 200
    "vmname"        = "ubuntu-ocp-svc"
    "memory"        = 8192
    "nodename"      = "pve1"
    "numcpus"       = 4
    "size"          = "200G"
    "macaddr"       = "BC:24:11:C6:26:65"
    "template"      = "ubuntu-2404-cloudimg"
    "add_disk"      = false
    "storage_group" = "local-lvm"
    "data_disk"     = "/dev/disk/by-id/nvme-CT1000E100SSD8_2523EAD4658C"
  }
}

resource "proxmox_vm_qemu" "ubuntu-os-create" {
    vmid                = var.ubuntu.vmid
    name                = var.ubuntu.vmname
    target_node         = var.ubuntu.nodename
    memory              = var.ubuntu.memory
    balloon             = var.ubuntu.memory
    scsihw              = "virtio-scsi-pci"
    onboot              = true
    boot                = "order=scsi0;ide1"
    agent               = 0 # Disabled the agent
    vm_state            = "running"
    automatic_reboot    = true

    cpu {
        cores           = var.ubuntu["numcpus"]
        type            = "host"
    }

    disks {
        scsi {
            scsi0 {
                disk {
                    # iothread        = true

                    discard         = true
                    storage         = var.ubuntu.storage_group
                    size            = var.ubuntu.size
                    backup          = false
                }
            }

            # Attach passthrough disk only if data_disk is set
            dynamic "scsi1" {
                for_each = var.ubuntu.add_disk && var.ubuntu.data_disk != "" ? [var.ubuntu.data_disk] : []
                content {
                    # The passthrough block attaches a physical disk directly to the VM.
                    # Ensure the Proxmox node has access to the specified disk path and that passthrough is supported.
                    passthrough {
                        discard         = true
                        backup          = false
                        # scsi1.value refers to the data disk path provided in the dynamic block's for_each
                        file            = scsi1.value
                    }
                }
            }
        }

        ide {
            ide1 {
                cdrom {
                    # [storage pool]:iso/[name of iso file]
                    iso = "local:iso/ubuntu-24.04.2-live-server-amd64.iso"
                }
            }
        }
    }

    network {
        id              = 0
        bridge          = "vmbr0"
        firewall        = true
        link_down       = false
        model           = "virtio"
        macaddr         = var.ubuntu.macaddr
        # tag             = 60
    }

    network {
        id              = 1
        bridge          = "ocp"
        firewall        = true
        link_down       = false
        model           = "virtio"
        # macaddr         = "06:00:20:E2:A2:12"
        tag             = 50
    }
}
