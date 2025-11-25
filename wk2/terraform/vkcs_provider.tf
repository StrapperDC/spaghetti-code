terraform {
  required_providers {
    vkcs = {
      source = "vk-cs/vkcs"
      version = "< 1.0.0"
    }
    null = {
      source = "hashicorp/null"
      version = "~> 3.2"
    }
  }
}

provider "vkcs" {
  username   = var.username
  password   = var.password
  project_id = var.project_id
  region     = "RegionOne"
  auth_url   = "https://infra.mail.ru:35357/v3/"
}

provider "null" {
}
