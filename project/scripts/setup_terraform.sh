#!/bin/bash

sudo apt install unzip git -y
wget https://hashicorp-releases.mcs.mail.ru/terraform/1.9.7/terraform_1.9.7_linux_amd64.zip
unzip terraform_1.9.7_linux_amd64.zip
sudo mv terraform /usr/bin/

cat << EOF > ~/.terraformrc
provider_installation {
    network_mirror {
        url = "https://terraform-mirror.mcs.mail.ru"
        include = ["registry.terraform.io/*/*"]
    }
    direct {
        exclude = ["registry.terraform.io/*/*"]
    }
}
EOF

mkdir project
cd project
cat << EOF > vkcs_provider.tf
terraform {
    required_providers {
        vkcs = {
            source = "vk-cs/vkcs"
            version = "~> 0.5.2" 
        }
    }
}

provider "vkcs" {
    # Your user account.
    username = "minaevda21@st.ithub.ru"

    # The password of the account
    password = ""

    # The tenant token can be taken from the project Settings tab - > API keys.
    # Project ID will be our token.
    project_id = "259eb7c6129a46f6b01062f53d57b9f8"
    
    # Region name
    region = "RegionOne"
    
    auth_url = "https://infra.mail.ru:35357/v3/" 
}

EOF

cat << EOF > variables.tf
variable "image_name" {
  type = string
  default = "ubuntu-20-202404160933.gitd6495fe9"
}

variable "compute_flavor" {
  type = string
  default = "STD2-2-4"
}

variable "key_pair_name" {
  type = string
  default = "key-minaev"
}

variable "availability_zone_name" {
  type = string
  default = "MS1"
}
EOF

cat << EOF > main.tf
variable "vm_count" {
  type = number
  default = 3
}

data "vkcs_compute_flavor" "compute" {
  name = var.compute_flavor
}

data "vkcs_images_image" "compute" {
  name = var.image_name
}

resource "vkcs_compute_instance" "minaev_project_vm" {
  count                   = var.vm_count
  name                    = "minaev_project_vm-${count.index == 0 ? "dc" : format("client%02d",count.index)}"
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
    uuid = "e443a337-74fe-43f4-88da-aaf9b9094063"
    fixed_ip_v4 = format("192.168.254.%d",100+count.index+1)

  }
}
EOF

terraform init 
terraform apply --auto-approve
