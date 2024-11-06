#!/bin/bash


sudo apt update -y

sudo apt install python-setuptools python3-pip docker.io docker-compose ansible git pwgen -y -y

sudo usermod -aG docker $USER

git clone https://github.com/ansible/awx.git --branch 17.0.1 --depth 1

cd awx/installer
pwgen -N 1 -s 30
sed -i "s/^#admin_password=password/admin_password=1234/g" inventory
sed -i "s/^secret_key=awxsecret/secret_key=1234/g" inventory

sudo ansible-playbook -i inventory install.yml
