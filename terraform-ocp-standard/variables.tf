variable "ocp_machines" {
  type = list(object({
    vmid                = number
    nodename            = string
    vmname              = string
    memory              = optional(number, 16384)
    numcpus             = optional(number, 4)
    size                = optional(string, "50G")
    macaddr             = string
    stoageGroup         = optional(string, "local-lvm")
    iso_file            = optional(string, "rhcos-4.19.0-x86_64-live-iso.x86_64.iso")
  }))

  default = [
    {
      vmid          = 500
      vmname        = "bootstrap"
      nodename      = "pve1"
      memory        = 16384 # minimum 12288 MB for bootstrap
      numcpus       = 4
      size          = "50G"
      stoageGroup   = "storage"
      macaddr       = "08:00:27:66:E2:DE"
      iso_file      = "rhcos-4.19.0-x86_64-live-iso.x86_64.iso"
    },
    # Masters can be added here
    {
      vmid          = 501
      vmname        = "master0"
      nodename      = "pve1"
      memory        = 16384 # minimum 12288 MB for master
      numcpus       = 4
      size          = "50G"
      stoageGroup   = "storage"
      macaddr       = "08:00:27:E2:A2:44"
      iso_file      = "rhcos-4.19.0-x86_64-live-iso.x86_64.iso"
    },
    {
      vmid          = 502
      vmname        = "master1"
      nodename      = "pve1"
      memory        = 16384 # minimum 12288 MB for master
      numcpus       = 4
      size          = "50G"
      macaddr       = "08:00:27:D3:53:07"
      stoageGroup   = "storage"
      iso_file      = "rhcos-4.19.0-x86_64-live-iso.x86_64.iso"
    },
    {
      vmid          = 503
      vmname        = "master2"
      nodename      = "pve1"
      memory        = 16384 # minimum 12288 MB
      numcpus       = 4
      size          = "50G"
      macaddr       = "08:00:27:9E:23:B0"
      stoageGroup   = "storage"
      iso_file      = "rhcos-4.19.0-x86_64-live-iso.x86_64.iso"
    },
    # Workers can be added here
    {
      vmid          = 520
      vmname        = "worker0"
      nodename      = "pve1"
      memory        = 20000 # minimum 12288 MB for worker
      numcpus       = 8
      size          = "300G"
      macaddr       = "08:00:27:2E:1A:FC"
      stoageGroup   = "storage"
      iso_file      = "rhcos-4.19.0-x86_64-live-iso.x86_64.iso"
    },
    {
      vmid          = 521
      vmname        = "worker1"
      nodename      = "pve1"
      memory        = 20000 # minimum 12288 MB for worker
      numcpus       = 8
      size          = "300G"
      macaddr       = "08:00:27:09:94:65"
      stoageGroup   = "storage"
      iso_file      = "rhcos-4.19.0-x86_64-live-iso.x86_64.iso"
    }    
  ]
}