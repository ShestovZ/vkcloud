resource "vkcs_networking_network" "network"{
        name="Liude_Ilya_network"
        admin_state_up="true"
        sdn="neutron"
        tags=[var.tag]
}
resource "vkcs_networking_network" "network2" {
        name="Liude_Ilya_network2"
        admin_state_up="true"
        tags=[var.tag]
}
resource "vkcs_networking_router" "router" {
        name = "Liude_Ilya_router"
        admin_state_up=true
        external_network_id=var.external_network
}

resource "vkcs_networking_router_interface" "router_subnet1"{
        router_id=vkcs_networking_router.router.id
        subnet_id=vkcs_networking_subnet.subnet.id
}
resource "vkcs_networking_router_interface" "router_subnet2" {
        router_id=vkcs_networking_router.router.id
        subnet_id=vkcs_networking_subnet.subnet2.id
}
resource "vkcs_networking_subnet" "subnet"{
        name="Liude_Ilya_subnet"
        network_id=vkcs_networking_network.network.id
        cidr="192.168.192.0/24"
        tags=[var.tag]
}
resource "vkcs_networking_subnet" "subnet2" {
        name="Liude_Ilya_subnet2"
        network_id=vkcs_networking_network.network2.id
        cidr="192.168.193.0/24"
        tags=[var.tag]
}

resource "vkcs_networking_port" "port_nginx_in"{
        name="port_nginx_in"
        network_id=vkcs_networking_network.network.id
        admin_state_up = "true"
        fixed_ip{
                subnet_id=vkcs_networking_subnet.subnet.id
                ip_address="192.168.192.192"
        }
}
resource "vkcs_networking_port" "port_mysql_in"{
        name="port_mysql_in"
        network_id=vkcs_networking_network.network.id
        admin_state_up="true"
        fixed_ip{
                subnet_id=vkcs_networking_subnet.subnet.id
                ip_address="192.168.192.193"
        }
}


resource "vkcs_networking_port" "port_grafana_in"{
        name="port_services_in"
        network_id=vkcs_networking_network.network2.id
        admin_state_up="true"
        fixed_ip{
                subnet_id=vkcs_networking_subnet.subnet2.id
                ip_address="192.168.193.194"
        }
}


resource "vkcs_networking_secgroup" "secgroup1" {
        name="Liude_rules"
}
resource "vkcs_networking_secgroup_rule" "allow22" {
        direction="ingress"
        port_range_max=22
        port_range_min=22
        protocol="tcp"
        remote_ip_prefix="0.0.0.0/0"
        security_group_id=vkcs_networking_secgroup.secgroup1.id
        description="Allow SSH to connect"
}
resource "vkcs_networking_secgroup_rule" "allow2024" {
        direction="ingress"
        port_range_max=2024
        port_range_min=2024
        protocol="tcp"
        remote_ip_prefix="0.0.0.0/0"
        security_group_id=vkcs_networking_secgroup.secgroup1.id
        description="Allow ssh to connect from ext-net."
}

resource "vkcs_networking_port_secgroup_associate" "for_in_net" {
        port_id=vkcs_networking_port.port_nginx_in.id
        enforce=true
        security_group_ids = [ 
                var.sec_group_default,
                vkcs_networking_secgroup.secgroup1.id,
        ]
}
resource "vkcs_networking_port_secgroup_associate" "for_in_net2" {
        port_id=vkcs_networking_port.port_mysql_in.id
        enforce=true
        security_group_ids=[
                   var.sec_group_default,
                vkcs_networking_secgroup.secgroup1.id,
        ]
}
resource "vkcs_networking_port_secgroup_associate" "for_in_net3" {
        port_id=vkcs_networking_port.port_grafana_in.id
        enforce=true
        security_group_ids=[
                var.sec_group_default,
        ]
}