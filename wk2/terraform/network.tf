# Внешняя сеть - используем правильный data source
data "vkcs_networking_network" "ext_net" {
  external = true
}

# Внутренняя сеть для GitLab
resource "vkcs_networking_network" "app_net" {
  name = var.network_name
}

resource "vkcs_networking_subnet" "app_subnet" {
  name       = "${var.network_name}-subnet"
  network_id = vkcs_networking_network.app_net.id
  cidr       = var.subnet_cidr
  dns_nameservers = ["8.8.8.8", "1.1.1.1"]
  enable_dhcp = true
}

# Роутер с правильным external_network_id
resource "vkcs_networking_router" "app_router" {
  name                = "gitlab-router"
  admin_state_up      = true
  external_network_id = data.vkcs_networking_network.ext_net.id
}

resource "vkcs_networking_router_interface" "router_interface" {
  router_id = vkcs_networking_router.app_router.id
  subnet_id = vkcs_networking_subnet.app_subnet.id
}

# Исправленный порт с full_security_groups_control = true
resource "vkcs_networking_port" "gitlab_port" {
  name                  = "gitlab-port"
  network_id            = vkcs_networking_network.app_net.id
  security_group_ids    = [vkcs_networking_secgroup.gitlab_sg.id]
  full_security_groups_control = true  # Исправлено!

  fixed_ip {
    subnet_id = vkcs_networking_subnet.app_subnet.id
  }

  depends_on = [vkcs_networking_router_interface.router_interface]
}
