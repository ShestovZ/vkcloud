# Инструкция по развертыванию проекта

## Клонирование репозитория
```bash
git clone git@github.com:ShestovZ/vkcloud.git
cd project/terraform
```

## Инициализация и применение Terraform

```bash
terraform init
terraform apply --auto-approve
```

## Копирование и подключение

```bash
scp ../scripts/*.sh ubuntu@<ip-публичный>:~/
ssh ubuntu@<ip-публичный>
```

## Установка AWX

```bash
bash setup_awx.sh
```

## Инициализация и применение Terraform:
```bash
terraform init
terraform apply --auto-approve
```

## Доступ к AWX

Откройте браузер и перейдите по публичному IP адресу для доступа к AWX.




