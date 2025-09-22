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
    "template"      = "ubuntu-2404-cloudimg"
    "user"          = "ocp"
    "password"      = "Asdf@135"
    "add_disk"      = true
    "storage_group" = "local-lvm"
    "data_disk"     = "/dev/disk/by-id/nvme-CT1000E100SSD8_2523EAD4658C"
  }
}

resource "proxmox_vm_qemu" "cloudinit-ubuntu-os-create" {
    provider            = proxmox.pve1_root

    vmid                = var.ubuntu["vmid"]
    name                = var.ubuntu["vmname"]
    target_node         = var.ubuntu["nodename"]
    memory              = var.ubuntu["memory"]
    balloon             = var.ubuntu["memory"]
    clone               = var.ubuntu["template"] # The name of the template
    boot                = "order=scsi0;ide1;net0"
    scsihw              = "virtio-scsi-pci"
    agent               = 1
    os_type             = "cloud-init"
    vm_state            = "running"
    automatic_reboot    = true
    onboot              = true

    # Cloud-Init configuration
    # /var/lib/vz/snippets/qemu-guest-agent-ubuntu-9000.yaml
    cicustom            = "vendor=snippets:snippets/qemu-guest-agent-ubuntu-9000.yaml"
    ciupgrade           = true
    ipconfig0           = "ip=dhcp,ip6=dhcp"
    skip_ipv6           = true
    ciuser              = var.ubuntu["user"]
    cipassword          = var.ubuntu["password"]
    # sshkeys             = "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAIE/Pjg7YXZ8Yau9heCc4YWxFlzhThnI+IhUx2hLJRxYE Cloud-Init@Terraform"
    # nameserver          = "1.1.1.1 8.8.8.8"

    cpu {
        cores           = var.ubuntu["numcpus"]
        type            = "host"
    }

    # Most cloud-init images require a serial device for their display and I've used serial0
    serial {
        id              = 0
        type            = "socket"
    }

    disks {
        scsi {
            scsi0 {
                # We have to specify the disk from our template, else Terraform will think it's not supposed to be there
                disk {
                    # iothread        = true # iothread is only valid with virtio disk or virtio-scsi-single controller, ignoring
                    discard         = true
                    storage         = var.ubuntu["storage_group"]
                    size            = var.ubuntu["size"]
                    backup          = true
                }
            }

            # Attach passthrough disk only if data_disk is set
            dynamic "scsi1" {
                for_each = var.ubuntu["add_disk"] && var.ubuntu["data_disk"] != "" ? [var.ubuntu["data_disk"]] : []
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
            # Some images require a cloud-init disk on the IDE controller, others on the SCSI or SATA controller
            ide1 { # OR ide2
                cloudinit {
                    storage         = "local-lvm"
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
        macaddr         = "BC:24:11:C6:26:65"
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
