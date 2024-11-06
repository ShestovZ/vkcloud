variable "" {
  default = "var_server"
}

resource "openstack_networking_network_v2" "network" {
  name = "ITHUBterraformnetwork-${var.lastname}"
}

resource "openstack_networking_subnet_v2" "subnet" {
  name       = "ITHUBterraformsubnet-${var.lastname}"
  network_id = openstack_networking_network_v2.network.id
  cidr       = "192.168.254.0/24"
  ip_version = 4
}

resource "openstack_compute_instance_v2" "vm1" {
  name            = "ITHUBterraforubuntu1-${var.lastname}"
  image_id       = "Ubuntu-20.04"
  flavor_id      = "high-iops"
  key_pair        = "my-key"
  security_groups = ["my-sec-group"]

  network {
    uuid = openstack_networking_network_v2.network.id
    fixed_ip = "192.168.254.100"
  }
}

resource "openstack_compute_instance_v2" "vm2" {
  name            = "ITHUBterraforubuntu2-${var.lastname}"
  image_id       = "Ubuntu-20.04"
  flavor_id      = "high-iops"
  key_pair        = "my-key"
  security_groups = ["my-sec-group"]

  network {
    uuid = openstack_networking_network_v2.network.id
    fixed_ip = "192.168.254.200"
  }
}

resource "openstack_networking_router_v2" "router" {
  name           = "ITHUBterraformrouter-${var.lastname}"
  external_network_id = "public"
}

resource "openstack_networking_router_interface_v2" "router_interface" {
  router_id = openstack_networking_router_v2.router.id
  subnet_id = openstack_networking_subnet_v2.subnet.id
}
