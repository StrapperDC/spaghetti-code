variable "zone" {
  description = "Availability zone"
  type        = string
  default     = "MS1"
}

variable "vm_name" {
  description = "Имя виртуальной машины"
  type        = string
  default     = "app-server"
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

variable "external_network_id" {
  description = "ID внешней сети"
  type        = string
  default     = "ext-net"  
}

variable "username" {
  description = "VK Cloud username"
  type        = string
  sensitive   = true
}

variable "password" {
  description = "VK Cloud password"
  type        = string
  sensitive   = true
}

variable "project_id" {
  description = "VK Cloud project ID"
  type        = string
  sensitive   = true
}

variable "duckdns_token" {
  description = "Duck DNS API token"
  type        = string
  sensitive   = true
}

variable "duckdns_domain" {
  description = "Duck DNS domain name (without .duckdns.org)"
  type        = string
}
