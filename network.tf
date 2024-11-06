variable "networks" {
  type = map(object({
    name = string
    cidr = string
    tags = list(string)
  }))

  default = {
    network = {
      name = "network"
      cidr = "192.168.192.0/24"
      tags = [var.tag]
    }
    network2 = {
      name = "network2"
      cidr = "192.168.193.0/24"
      tags = [var.tag]
    }
  }
}

resource "vkcs_networking_network" "networks" {
  for_each = var.networks

  name            = each.value.name
  admin_state_up  = true
  sdn             = (each.key == "network" ? "neutron" : null) // Применяется только для первого сетевого интерфейса
  tags            = each.value.tags
}

resource "vkcs_networking_subnet" "subnets" {
  for_each = var.networks

  name        = "${each.key}_subnet"
  network_id  = vkcs_networking_network.networks[each.key].id
  cidr        = each.value.cidr
  tags        = each.value.tags
}

resource "vkcs_networking_router" "router" {
  name                   = "router"
  admin_state_up         = true
  external_network_id    = var.external_network
}

resource "vkcs_networking_router_interface" "router_interfaces" {
  for_each = vkcs_networking_subnet.subnets

  router_id = vkcs_networking_router.router.id
  subnet_id = each.value.id
}

resource "vkcs_networking_port" "ports" {
  count = 3
  name  = ["port_nginx_in", "port_mysql_in", "port_services_in"][count.index]
  network_id = vkcs_networking_network.networks[count.index < 2 ? "network" : "network2"].id
  admin_state_up = true

  fixed_ip {
    subnet_id = vkcs_networking_subnet.subnets[count.index < 2 ? "network" : "network2"].id
    ip_address = ["192.168.192.192", "192.168.192.193", "192.168.193.194"][count.index]
  }
}

resource "vkcs_networking_secgroup" "secgroup1" {
  name = "rules"
}

resource "vkcs_networking_secgroup_rule" "allow" {
  for_each = {
    "allow22"   = { port = 22, description = "Allow SSH to connect" }
    "allow2024" = { port = 2024, description = "Allow SSH to connect from ext-net." }
  }

  direction          = "ingress"
  port_range_max    = each.value.port
  port_range_min    = each.value.port
  protocol          = "tcp"
  remote_ip_prefix  = "0.0.0.0/0"
  security_group_id = vkcs_networking_secgroup.secgroup1.id
  description       = each.value.description
}

resource "vkcs_networking_port_secgroup_associate" "port_secgroup_associate" {
  for_each = {
    "port_nginx_in"    = vkcs_networking_port.ports[0].id,
    "port_mysql_in"    = vkcs_networking_port.ports[1].id,
    "port_services_in" = vkcs_networking_port.ports[2].id
  }

  port_id         = each.value
  enforce         = true
  security_group_ids = [
    var.sec_group_default,
    vkcs_networking_secgroup.secgroup1.id,
  ]
}
