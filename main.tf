locals {
  ubuntu_password  = "Lab@12345"
  controlplane_ip  = "192.168.1.183/24"
  node01_ip        = "192.168.1.199/24"
  node02_ip        = "192.168.1.200/24"
  node03_ip        = "192.168.1.201/24"
  gateway_all_node = "192.168.1.1"
  dns              = ["8.8.8.8"]
}

resource "proxmox_virtual_environment_vm" "controlplane-node" {
  name        = "controlplane"
  description = "Managed by Terraform"
  tags        = ["terraform", "ubuntu"]

  node_name = "proxmox"
  vm_id     = 1000

  agent {
    # read 'Qemu guest agent' section, change to true only when ready
    enabled = false
  }
  # if agent is not enabled, the VM may not be able to shutdown properly, and may need to be forced off
  stop_on_destroy = true

  startup {
    order      = "3"
    up_delay   = "60"
    down_delay = "60"
  }

  cpu {
    cores = 2
    type  = "x86-64-v2-AES" # recommended for modern CPUs
  }

  memory {
    dedicated = 2048
    floating  = 2048 # set equal to dedicated to enable ballooning
  }

  disk {
    datastore_id = "local-lvm"
    file_id      = proxmox_virtual_environment_download_file.latest_ubuntu_22_jammy_qcow2_img.id
    interface    = "scsi0"
  }

  initialization {
    ip_config {
      ipv4 {
        address = local.controlplane_ip
        gateway = local.gateway_all_node
      }
    }
    dns {
      servers = local.dns
    }

    user_account {
      keys     = [trimspace(tls_private_key.ubuntu_vm_key.public_key_openssh)]
      password = local.ubuntu_password
      username = "nattapong"
    }

    #user_data_file_id = proxmox_virtual_environment_file.cloud_config.id
  }

  network_device {
    bridge = "vmbr0"
  }

  operating_system {
    type = "l26"
  }

  tpm_state {
    version = "v2.0"
  }

  serial_device {}
}

resource "proxmox_virtual_environment_vm" "worker-node01" {
  name        = "node01"
  description = "Managed by Terraform"
  tags        = ["terraform", "ubuntu"]

  node_name = "proxmox"
  vm_id     = 2001

  agent {
    # read 'Qemu guest agent' section, change to true only when ready
    enabled = false
  }
  # if agent is not enabled, the VM may not be able to shutdown properly, and may need to be forced off
  stop_on_destroy = true

  startup {
    order      = "3"
    up_delay   = "60"
    down_delay = "60"
  }

  cpu {
    cores = 2
    type  = "x86-64-v2-AES" # recommended for modern CPUs
  }

  memory {
    dedicated = 2048
    floating  = 2048 # set equal to dedicated to enable ballooning
  }

  disk {
    datastore_id = "local-lvm"
    file_id      = proxmox_virtual_environment_download_file.latest_ubuntu_22_jammy_qcow2_img.id
    interface    = "scsi0"
  }

  initialization {
    ip_config {
      ipv4 {
        address = local.node01_ip
        gateway = local.gateway_all_node
      }
    }
    dns {
      servers = local.dns
    }

    user_account {
      keys     = [trimspace(tls_private_key.ubuntu_vm_key.public_key_openssh)]
      password = local.ubuntu_password
      username = "nattapong"
    }

    #user_data_file_id = proxmox_virtual_environment_file.cloud_config.id
  }

  network_device {
    bridge = "vmbr0"
  }

  operating_system {
    type = "l26"
  }

  tpm_state {
    version = "v2.0"
  }

  serial_device {}
}

resource "proxmox_virtual_environment_vm" "worker-node02" {
  name        = "node02"
  description = "Managed by Terraform"
  tags        = ["terraform", "ubuntu"]

  node_name = "proxmox"
  vm_id     = 2002

  agent {
    # read 'Qemu guest agent' section, change to true only when ready
    enabled = false
  }
  # if agent is not enabled, the VM may not be able to shutdown properly, and may need to be forced off
  stop_on_destroy = true

  startup {
    order      = "3"
    up_delay   = "60"
    down_delay = "60"
  }

  cpu {
    cores = 2
    type  = "x86-64-v2-AES" # recommended for modern CPUs
  }

  memory {
    dedicated = 2048
    floating  = 2048 # set equal to dedicated to enable ballooning
  }

  disk {
    datastore_id = "local-lvm"
    file_id      = proxmox_virtual_environment_download_file.latest_ubuntu_22_jammy_qcow2_img.id
    interface    = "scsi0"
  }

  initialization {
    ip_config {
      ipv4 {
        address = local.node02_ip
        gateway = local.gateway_all_node
      }
    }
    dns {
      servers = local.dns
    }

    user_account {
      keys     = [trimspace(tls_private_key.ubuntu_vm_key.public_key_openssh)]
      password = local.ubuntu_password
      username = "nattapong"
    }

    #user_data_file_id = proxmox_virtual_environment_file.cloud_config.id
  }

  network_device {
    bridge = "vmbr0"
  }

  operating_system {
    type = "l26"
  }

  tpm_state {
    version = "v2.0"
  }

  serial_device {}
}

resource "proxmox_virtual_environment_download_file" "latest_ubuntu_22_jammy_qcow2_img" {
  content_type = "iso"
  datastore_id = "local"
  node_name    = "proxmox"
  url          = "https://cloud-images.ubuntu.com/jammy/current/jammy-server-cloudimg-amd64.img"
  verify       = false
}

resource "random_password" "ubuntu_vm_password" {
  length           = 16
  override_special = "_%@"
  special          = true
}

resource "tls_private_key" "ubuntu_vm_key" {
  algorithm = "RSA"
  rsa_bits  = 2048
}

/*
output "ubuntu_vm_password" {
  value     = random_password.ubuntu_vm_password.result
  sensitive = true
}
*/

output "ubuntu_vm_private_key" {
  value     = tls_private_key.ubuntu_vm_key.private_key_pem
  sensitive = true
}

output "ubuntu_vm_public_key" {
  value = tls_private_key.ubuntu_vm_key.public_key_openssh
}