resource "vkcs_networking_secgroup" "minaev" {
   name = "security_group_minaev"
   description = "terraform security group"
}

resource "vkcs_networking_secgroup_rule" "http" {
   direction = "ingress"
   port_range_max = 80
   port_range_min = 80
   protocol = "tcp"
   remote_ip_prefix = "0.0.0.0/0"
   security_group_id = vkcs_networking_secgroup.minaev.id
   description = "secgroup_rule_80_tcp"
}

resource "vkcs_networking_secgroup_rule" "https" {
   direction = "ingress"
   port_range_max = 443
   port_range_min = 443
   protocol = "tcp"
   remote_ip_prefix = "0.0.0.0/0"
   security_group_id = vkcs_networking_secgroup.minaev.id
   description = "secgroup_rule_443_tcp"
}
