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
    alias               = "pve1"
    pm_api_url          = "https://192.168.0.140:8006/api2/json"
    # pm_api_token_id     = "terraform@pam!terraform"
    # pm_api_token_secret = "6c9275d4-9204-4774-807b-ab75624af38d"
    pm_tls_insecure     = true

    pm_log_file         = "terraform-plugin-proxmox.log"
    pm_debug            = true
    pm_log_levels       = {
        _default        = "debug"
        _capturelog     = ""
    }
}

provider "proxmox" {
    pm_user             = "root@pam"
    pm_password         = "Asdf@135"
    alias               = "pve3"
    pm_api_url          = "https://192.168.0.142:8006/api2/json"
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


module "rchos-vm-pve1" {
    source = "./module-pve1"
    providers = {
        proxmox = proxmox.pve1
    }
}

module "rchos-vm-pve3" {
    source = "./module-pve2"
    providers = {
        proxmox = proxmox.pve3
    }
}
