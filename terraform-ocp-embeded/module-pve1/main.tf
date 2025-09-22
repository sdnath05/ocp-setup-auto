terraform {
  required_providers {
    proxmox = {
        # "registry.terraform.io/telmate/proxmox"
        source      = "telmate/proxmox"
        version     = "3.0.2-rc04"
    }
  }
}

resource "proxmox_vm_qemu" "ocp-vms-create" {
    count               = length(var.ocp_machines1)

    vmid                = var.ocp_machines1[count.index].vmid
    name                = var.ocp_machines1[count.index].vmname
    target_node         = var.ocp_machines1[count.index].nodename
    memory              = var.ocp_machines1[count.index].memory
    balloon             = var.ocp_machines1[count.index].memory
    agent               = 0 # Disabled the agent
    scsihw              = "virtio-scsi-pci"
    onboot              = true
    boot                = "order=scsi0;ide1"
    vm_state            = "running"
    automatic_reboot    = true

    # os_type             = "cloud-init"
    # clone               = var.ocp_machines1[count.index].template # The name of the template
    # args                = var.ocp_machines1[count.index].args

    # Cloud-Init configuration
    # cicustom            = var.ocp_machines1[count.index].cicustom
    # ipconfig0           = "ip=dhcp,ip6=dhcp"
    # skip_ipv6           = true
    # ciuser              = var.ocp_machines1[count.index].user
    # cipassword          = var.ocp_machines1[count.index].password
    # sshkeys             = "ssh-rsa AAAAB3NzaC1yc2EAAAADAQABAAACAQDIOxd70J481cQYXgKieTfmvU6sYpNgncJqiLTJgzMVEv+wMmXdrDh+4WJ8VC1Jqq6yoHBkG9N7bOZUHhpORHDp+cEvIm/7rsGMPcOXSOYrG3hs0EB1lQLItRp0vZUKi2xwmHRRnYtLeOPXpHjx17AHroNqWj1DyzKTIjAEluyEcjA/OlUoUhoqMcOdkir8omy7u7yNcWVg61IImoduNq1Ukc8MY08cIH8wWF5FsieAUTITDWzMBNAcSD8Uri68o2yM9wovDkn/Q+AwekZUcnAckSOa9/cAaXkRElfOFp5wEyu6NsaYtYOSbwVJv11MvrFAx7WlUCgEFg4LGibG1PLshhve3gEQ4vUHSE0FUFjUDj0yL5OVa6XOy2H3uNlGx/k6+ppFdGZiussBoRyg5dzPDj700sR4/UukCHVc4aLDPBoH3U/aa7ukfhlI4pAl76wyvJIMor2CxD/82XzdkjeaY4JDKgBsh5b+5SUNchXCtHMpXsSzth5Q7e8vN4bxnsEPowMXAvmN1/NbTgStaS7XoEqi9yhM4uryh7qGEcwREcIu0h7sb2RjX/21LLdDuPb1t/JG9aAQpV64P+JR/dcRmW4Trx+KiZTestF2M/7ysgUYtKuA0eukJlZriW4oHt8fWc9uxrs0RsbkH6CA12fJs7Ec494CbmuuelJI/Q099w== ocp-svc"
    # ciupgrade           = true

    cpu {
        cores           = var.ocp_machines1[count.index].numcpus
        type            = "host"
    }

    # serial {
    #     id              = 0
    #     type            = "socket"
    # }

    # vga {
    #     type            = "serial"
    # }

    # disks {
    #     ide {
    #         # Some images require a cloud-init disk on the IDE controller, others on the SCSI or SATA controller
    #         ide1 { # OR ide2
    #             cloudinit {
    #                 storage         = "local-lvm"
    #             }
    #         }
    #     }

    #     scsi {
    #         scsi0 {
    #             # We have to specify the disk from our template, else Terraform will think it's not supposed to be there
    #             disk {
    #                 # iothread        = true # iothread is only valid with virtio disk or virtio-scsi-single controller, ignoring
    #                 discard         = true
    #                 storage         = var.ocp_machines1[count.index].stoageGroup
    #                 size            = var.ocp_machines1[count.index].size
    #                 backup          = true
    #             }
    #         }
    #     }
    # }

    disks {
        ide {
            ide1 {
                cdrom {
                    # [storage pool]:iso/[name of iso file]
                    iso = "local:iso/${var.ocp_machines1[count.index].iso_file}"
                }
            }
        }

        scsi {
            scsi0 {
                disk {
                    # iothread        = true
                    storage         = var.ocp_machines1[count.index].stoageGroup
                    size            = var.ocp_machines1[count.index].size
                }
            }
        }
    }
    
    network {
        id              = 0
        bridge          = "ocp"
        firewall        = true
        link_down       = false
        model           = "virtio"
        macaddr         = var.ocp_machines1[count.index].macaddr
        tag             = 50
    }
}
