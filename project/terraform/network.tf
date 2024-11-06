# Get external network with Internet access
data "vkcs_networking_network" "extnet" {
   sdn        = "neutron"
   external   = true
}
# Create a network
resource "vkcs_networking_network" "minaev" {
   name       = "ITHUBterraformnetwork-minaev"
   sdn        = "neutron"
}
# Create a subnet
resource "vkcs_networking_subnet" "minaev" {
   name       = "ITHUBterraformsubnet-minaev"
   network_id = vkcs_networking_network.minaev.id
   cidr       = "192.168.254.0/24"
}
# Create a router
resource "vkcs_networking_router" "minaev" {
   name       = "ITHUBterraformrouter-minaev"
   sdn        = "neutron"
   external_network_id = data.vkcs_networking_network.extnet.id
}
# Connect the network to the router
resource "vkcs_networking_router_interface" "minaev" {
   router_id  = vkcs_networking_router.minaev.id
   subnet_id  = vkcs_networking_subnet.minaev.id
}
