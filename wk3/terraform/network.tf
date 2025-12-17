resource "vkcs_networking_network" "app_net" {
  name = var.network_name
}

resource "vkcs_networking_subnet" "app_subnet" {
  name       = "${var.network_name}-subnet"
  network_id = vkcs_networking_network.app_net.id
  cidr       = var.subnet_cidr
}

resource "vkcs_networking_router" "app_router" {
  name                = "app-router"
  admin_state_up      = true
  external_network_id = data.vkcs_networking_network.ext_net.id
}

resource "vkcs_networking_router_interface" "router_interface" {
  router_id = vkcs_networking_router.app_router.id
  subnet_id = vkcs_networking_subnet.app_subnet.id
}

# Внешняя сеть (нужна для выхода в интернет и плавающих IP)
data "vkcs_networking_network" "ext_net" {
  id = "ec8c610e-6387-447e-83d2-d2c541e88164"
}
