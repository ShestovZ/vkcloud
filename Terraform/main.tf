variable "instances" {
  type = map(object({
    name              = string
    availability_zone = string
    port_id           = string
  }))

  default = {
    nginx = {
      name              = "nginx"
      availability_zone = var.availability_zone
      port_id           = vkcs_networking_port.port_nginx_in.id
    },
    mysql = {
      name              = "mysql"
      availability_zone = var.availability_zone2
      port_id           = vkcs_networking_port.port_mysql_in.id
    },
    services = {
      name              = "services"
      availability_zone = var.availability_zone
      port_id           = vkcs_networking_port.port_grafana_in.id
    }
  }
}

resource "vkcs_compute_instance" "instances" {
  for_each = var.instances

  name                = each.value.name
  availability_zone   = each.value.availability_zone
  flavor_name         = var.compute_flavor
  tags                = [var.tag]
  key_pair            = var.ssh_keys

  block_device {
    source_type            = "image"
    uuid                   = var.os_image
    destination_type       = "volume"
    volume_size            = 30
    volume_type            = "high-iops"
    delete_on_termination  = true
  }

  network {
    port = each.value.port_id
  }

  depends_on = [vkcs_networking_router.router]
}
