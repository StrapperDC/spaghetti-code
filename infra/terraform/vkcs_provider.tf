terraform {
    required_providers {
        vkcs = {
            source = "vk-cs/vkcs"
            version = "< 1.0.0"
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
