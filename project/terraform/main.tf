variable "vm_count" {
  type = number
  default = 1
}

data "vkcs_compute_flavor" "compute" {
  name = var.compute_flavor
}

data "vkcs_images_image" "compute" {
  name = var.image_name
}

resource "vkcs_compute_instance" "minaev_project_vm" {
  count                   = var.vm_count
# name                    = "minaev_project_vm-${count.index+1}"
  name                    = "minaev_project_vm-awx"
  flavor_id               = data.vkcs_compute_flavor.compute.id
  key_pair                = var.key_pair_name
  security_groups         = ["default","ssh", "security_group_minaev"]
  availability_zone       = "MS1"

  block_device {
    uuid                  = data.vkcs_images_image.compute.id
    source_type           = "image"
    destination_type      = "volume"
    volume_type           = "ceph-ssd"
    volume_size           = 20
    boot_index            = 0
    delete_on_termination = true
  }

  network {
    uuid = vkcs_networking_network.minaev.id
    #fixed_ip_v4 = format("192.168.254.%d",200+count.index+1)
    fixed_ip_v4 = format("192.168.254.100")

  }

#  provisioner "local-exec"{
#    command = "chmod +x /tmp/awx_insatllation.sh && sudo /tmp/awx_insatllation.sh"

#  }

#  provisioner "file"{
#    source = "scripts/awx_insatllation.sh"
#    destination = "/tmp/awx_insatllation.sh"

#  }

#  depends_on = [
#   vkcs_networking_network.minaev,
#    vkcs_networking_subnet.minaev
#  ]
}

output "vm_hostname"{
  value = [for vm in vkcs_compute_instance.minaev_project_vm:vm.name]
}

output "vm_ip"{
  value = [for vm in vkcs_compute_instance.minaev_project_vm:vm.network[0].fixed_ip_v4]
}