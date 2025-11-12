# Correctly get the external network
data "vkcs_networking_network" "ext_net" {
  external = true
}

# Your internal application network
resource "vkcs_networking_network" "app_net" {
  name = var.network_name
}

resource "vkcs_networking_subnet" "app_subnet" {
  name       = "${var.network_name}-subnet"
  network_id = vkcs_networking_network.app_net.id
  cidr       = var.subnet_cidr
  dns_nameservers = ["8.8.8.8", "1.1.1.1"] # Optional but recommended
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
