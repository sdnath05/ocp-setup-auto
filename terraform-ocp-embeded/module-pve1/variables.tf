variable "ocp_machines1" {
  type = list(object({
    vmid                = number
    nodename            = string
    vmname              = string
    memory              = optional(number, 12288)
    numcpus             = optional(number, 4)
    size                = optional(string, "50G")
    macaddr             = string
    stoageGroup         = optional(string, "local-lvm")
    user                = optional(string, "")
    password            = optional(string, "")
    cicustom            = optional(string, "")
    template            = optional(string, "rchos-419-cloudimg") # The name of the template to clone from
    args                = optional(string, "")
    iso_file            = optional(string, "")
  }))

  default = [
    {
      vmid = 502
      vmname = "master1"
      nodename = "pve1"
      memory = 12288
      numcpus = 4
      size = "50G"
      macaddr = "08:00:27:D3:53:07"
      stoageGroup = "storage"
      # iso_file      = "rhcos-4.19.0-x86_64-live-iso-master.iso"
      iso_file      = "rhcos-4.19.0-x86_64-live-iso.x86_64.iso"

      # cicustom = "user=snippets:snippets/qemu-guest-agent-rchos-master-5000.yaml"
      # user = "core"
      # password = "Asdf@135"
      # args = "-kernel /root/rhcos-4.19.0-x86_64-live-kernel.x86_64 -append 'coreos.inst.ignition_url=http://192.168.56.2:8083/ocp-setup/master.ign coreos.inst.install_dev=/dev/sda coreos.inst.insecure=yes'"
    },
    {
      vmid = 503
      vmname = "master2"
      nodename = "pve1"
      memory = 12288
      numcpus = 4
      size = "50G"
      macaddr = "08:00:27:9E:23:B0"
      stoageGroup = "storage"
      # iso_file      = "rhcos-4.19.0-x86_64-live-iso-master.iso"
      iso_file      = "rhcos-4.19.0-x86_64-live-iso.x86_64.iso"

      # cicustom = "user=snippets:snippets/qemu-guest-agent-rchos-master-5000.yaml"
      # user = "core"
      # password = "Asdf@135"
      # args = "-kernel /root/rhcos-4.19.0-x86_64-live-kernel.x86_64 -append 'coreos.inst.ignition_url=http://192.168.56.2:8083/ocp-setup/master.ign coreos.inst.install_dev=/dev/sda coreos.inst.insecure=yes'"
    },
    {
      vmid = 520
      vmname = "worker0"
      nodename = "pve1"
      memory = 12288
      numcpus = 8
      size = "100G"
      macaddr = "08:00:27:2E:1A:FC"
      stoageGroup = "storage"
      # iso_file      = "rhcos-4.19.0-x86_64-live-iso-worker.iso"
      iso_file      = "rhcos-4.19.0-x86_64-live-iso.x86_64.iso"

      # cicustom = "user=snippets:snippets/qemu-guest-agent-rchos-worker-5000.yaml"
      # user = "core"
      # password = "Asdf@135"
      # args = "-kernel /root/rhcos-4.19.0-x86_64-live-kernel.x86_64 -append 'coreos.inst.ignition_url=http://192.168.56.2:8083/ocp-setup/worker.ign coreos.inst.install_dev=/dev/sda coreos.inst.insecure=yes'"
    },
    {
      vmid = 521
      vmname = "worker1"
      nodename = "pve1"
      memory = 12288
      numcpus = 8
      size = "100G"
      macaddr = "08:00:27:09:94:65"
      stoageGroup = "storage"
      # iso_file      = "rhcos-4.19.0-x86_64-live-iso-worker.iso"
      iso_file      = "rhcos-4.19.0-x86_64-live-iso.x86_64.iso"

      # cicustom = "user=snippets:snippets/qemu-guest-agent-rchos-worker-5000.yaml"
      # user = "core"
      # password = "Asdf@135"
      # args = "-kernel /root/rhcos-4.19.0-x86_64-live-kernel.x86_64 -append 'coreos.inst.ignition_url=http://192.168.56.2:8083/ocp-setup/worker.ign coreos.inst.install_dev=/dev/sda coreos.inst.insecure=yes'"
    }
  ]
}