variable "ocp_machines2" {
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
      vmid          = 500
      vmname        = "bootstrap"
      nodename      = "pve3"
      memory        = 12288
      numcpus       = 4
      size          = "50G"
      stoageGroup   = "storage"
      macaddr       = "08:00:27:66:E2:DE"
      # iso_file      = "rhcos-4.19.0-x86_64-live-iso-bootstrap.iso"
      iso_file      = "rhcos-4.19.0-x86_64-live-iso.x86_64.iso"
      
      # password      = "Asdf@135"
      # user          = "core"
      # cicustom      = "user=snippets:snippets/qemu-guest-agent-rchos-bootstrap-5000.yaml"
      # These works but don't include live image url option and after coreos-install in /dev/sda need to stop
      # the vm and remove the args part in /etc/pve/qemu-server/<vm-id>.conf
      # args          = "-kernel /root/rhcos-4.19.0-x86_64-live-kernel.x86_64 -initrd /root/rhcos-4.19.0-x86_64-live-initramfs.x86_64.img -append \"coreos.live.rootfs_url=http://192.168.0.16:8083/rchos/rhcos-4.19.0-x86_64-live-rootfs.x86_64.img coreos.inst.insecure=yes coreos.inst.install_dev=/dev/sda coreos.inst.ignition_url=http://192.168.0.16:8083/ocp-setup/bootstrap.ign coreos.inst.fetch_retries=0 coreos.inst.offline coreos.inst.firstboot\""
      # args          = "-kernel /root/rhcos-installer-kernel.x86_64 -initrd /root/rhcos-installer-initramfs.x86_64.img -append \"coreos.live.rootfs_url=http://192.168.0.16:8083/rchos/rhcos-installer-rootfs.x86_64.img coreos.inst.insecure=yes coreos.inst.install_dev=/dev/sda coreos.inst.ignition_url=http://192.168.0.16:8083/ocp-setup/bootstrap.ign coreos.inst.fetch_retries=1 coreos.inst.offline=yes coreos.inst.firstboot=yes\""
    },
    {
      vmid          = 501
      vmname        = "master0"
      nodename      = "pve3"
      memory        = 12288
      numcpus       = 4
      size          = "50G"
      stoageGroup   = "storage"
      macaddr       = "08:00:27:E2:A2:44"
      # iso_file      = "rhcos-4.19.0-x86_64-live-iso-master.iso"
      iso_file      = "rhcos-4.19.0-x86_64-live-iso.x86_64.iso"

      # cicustom      = "user=snippets:snippets/qemu-guest-agent-rchos-master-5000.yaml"
      # user          = "core"
      # password      = "Asdf@135"
      # args          = "-kernel /root/rhcos-4.19.0-x86_64-live-kernel.x86_64 -append 'coreos.inst.ignition_url=http://192.168.0.16:8083/ocp-setup/master.ign coreos.inst.install_dev=/dev/sda coreos.inst.insecure=yes'"
    }
  ]
}