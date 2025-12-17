variable "zone" {
  description = "Availability zone"
  type        = string
  default     = "MS1"
}

variable "vm_name" {
  description = "Имя виртуальной машины"
  type        = string
  default     = "CI-server"
}

variable "vm_image" {
  description = "Образ ОС"
  type        = string
  default     = "ubuntu-24.04-64"
}

variable "vm_flavor" {
  description = "Размер виртуалки"
  type        = string
  default     = "STD2-1-1"
}

variable "ssh_key_name" {
  description = "Имя ssh-ключа, загруженного в VK Cloud"
  default     = "rsa_nopass"
}

variable "network_name" {
  description = "Имя сети"
  type        = string
  default     = "app-net"
}

variable "subnet_cidr" {
  description = "Подсеть"
  type        = string
  default     = "192.168.10.0/24"
}
