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
    pm_user             = "root@pam"
    pm_password         = "Asdf@135"
    pm_api_url          = "https://192.168.0.140:8006/api2/json"
    # pm_api_token_id     = "terraform@pam!terraform"
    # pm_api_token_secret = "77f117bf-7337-4bfe-8d3b-8db77447513a"
    pm_tls_insecure     = true

    pm_log_file         = "terraform-plugin-proxmox.log"
    pm_debug            = true
    pm_log_levels       = {
        _default        = "debug"
        _capturelog     = ""
    }
}

resource "proxmox_vm_qemu" "ocp-vms-create" {
    count               = length(var.ocp_machines)

    vmid                = var.ocp_machines[count.index].vmid
    name                = var.ocp_machines[count.index].vmname
    target_node         = var.ocp_machines[count.index].nodename
    memory              = var.ocp_machines[count.index].memory
    balloon             = var.ocp_machines[count.index].memory
    agent               = 0 # Disabled the agent
    scsihw              = "virtio-scsi-pci"
    onboot              = true
    boot                = "order=scsi0;ide1"
    vm_state            = "running"
    automatic_reboot    = true

    cpu {
        cores                       = var.ocp_machines[count.index].numcpus
        type                        = "host"
    }

    disks {
        ide {
            ide1 {
                cdrom {
                    # [storage pool]:iso/[name of iso file]
                    iso             = "local:iso/${var.ocp_machines[count.index].iso_file}"
                }
            }
        }

        scsi {
            scsi0 {
                disk {
                    storage         = var.ocp_machines[count.index].stoageGroup
                    size            = var.ocp_machines[count.index].size
                    discard         = true
                    backup          = false
                }
            }
        }
    }
    
    network {
        id                          = 0
        bridge                      = "ocp"
        firewall                    = true
        link_down                   = false
        model                       = "virtio"
        macaddr                     = var.ocp_machines[count.index].macaddr
        tag                         = 50
    }
}
