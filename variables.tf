variable "hardware" {
  type = string
  default = "03c66e24-b386-4ceb-91f8-36e898d7fa72"
}
variable "compute_flavor" {
  type = string
  default = "STD3-4-8"
}
variable "ssh_keys" {
  type = string
  default = "devops_keys"
}
variable "availability_zone" {
  type = string
  default = "MS1"
}
variable "availability_zone2" {
        type=string
        default="GZ1"
}
variable "external_network"{
  type=string
  default="298117ae-3fa4-4109-9e08-8be5602be5a2"
}
variable "tag"{
        type=string
        default="fluddality"
}
variable "os_image"{
        type=string
        default="785bd3c3-6d63-44f8-b2ad-4e37afc38a38"
}
variable "sec_group_all"{
        type=string
        default="eb6f34e9-ce8e-4e17-8025-801c406f4cef"
}
variable "sec_group_default"{
        type=string
        default="cb00be20-cbd2-4334-9dea-9bb74b2d4344"
}