resource "vkcs_compute_instance" "first"{
        name="nginx"
        availability_zone=var.availability_zone
        flavor_name=var.compute_flavor
        tags=[var.tag]
        key_pair=var.ssh_keys
        block_device{
                source_type="image"
                uuid             = var.os_image
                destination_type = "volume"
                volume_size      = 30
                volume_type      = "high-iops"
                delete_on_termination = true
        }
        network{
                port=vkcs_networking_port.port_nginx_in.id
        }
        depends_on=[vkcs_networking_router.router]
}
resource "vkcs_compute_instance" "second"{
        name="mysql"
        availability_zone=var.availability_zone2
        flavor_name=var.compute_flavor
        tags=[var.tag]
        key_pair=var.ssh_keys
        block_device{
                source_type="image"
                uuid=var.os_image
                destination_type="volume"
                volume_size=30
                volume_type="high-iops"
                delete_on_termination=true
        }
        network{
                port=vkcs_networking_port.port_mysql_in.id
        }
        depends_on=[vkcs_networking_router.router]
}

resource "vkcs_compute_instance" "third"{
        name="services"
        availability_zone=var.availability_zone
        flavor_name=var.compute_flavor
        tags=[var.tag]
        key_pair=var.ssh_keys
        block_device{
                source_type="image"
                uuid=var.os_image
                destination_type="volume"
                volume_size=30
                volume_type="high-iops"
                delete_on_termination=true
        }
        network{
                port=vkcs_networking_port.port_grafana_in.id
        }
        depends_on=[vkcs_networking_router.router]
}
 
#resource "vkcs_compute_interface_attach" "port_1VM" {
#       instance_id = vkcs_compute_instance.first.id
#       port_id     = vkcs_networking_port.port_nginx_in.id
#}
#resource "vkcs_compute_interface_attach" "port_2VM" {
#       instance_id=vkcs_compute_instance.second.id
#       port_id=vkcs_networking_port.port_mysql_in.id
#}

#resource "vkcs_compute_interface_attach" "port_3VM" {
#       instance_id=vkcs_compute_instance.third.id
#       port_id=vkcs_networking_port.port_grafana_in.id
#}