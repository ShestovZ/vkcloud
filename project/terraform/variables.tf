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
