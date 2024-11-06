#!/bin/bash

	
sudo apt update
sudo apt install git docker.io docker-compose ansible -y

sudo usermod -aG docker $USER

git clone https://github.com/ansible/awx.git
cd awx/installer

cat << EOF > inventory
localhost ansible_connection=local

[all:vars]
dockerhub_base=ansible
awx_task_hostname=awx
awx_web_hostname=awxweb
host_port=80
admin_user=admin
admin_password=password
EOF

ansible-playbook -i inventory install.yml
