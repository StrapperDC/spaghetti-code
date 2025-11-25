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

variable "zone" {
  description = "Availability zone"
  type        = string
  default     = "MS1"
}

variable "vm_name" {
  description = "Имя виртуальной машины"
  type        = string
  default     = "gitlab-server"
}

variable "vm_image" {
  description = "Образ ОС"
  type        = string
  default     = "ubuntu-24.04-64"
}

variable "vm_flavor" {
  description = "Размер виртуалки"
  type        = string
  default     = "STD2-2-8"
}

variable "ssh_key_name" {
  description = "Имя ssh-ключа, загруженного в VK Cloud"
  default     = "rsa_nopass"
}

variable "network_name" {
  description = "Имя сети"
  type        = string
  default     = "gitlab-net"
}

variable "subnet_cidr" {
  description = "Подсеть"
  type        = string
  default     = "192.168.20.0/24"
}

variable "gitlab_duckdns_domain" {
  description = "DuckDNS domain for GitLab (without .duckdns.org)"
  type        = string
  default     = "cikapibarartest"
}

variable "duckdns_token" {
  description = "DuckDNS API token"
  type        = string
  sensitive   = true
}

variable "gitlab_domain" {
  description = "Full domain for GitLab"
  type        = string
  default     = "cikapibarartest.duckdns.org"
}
