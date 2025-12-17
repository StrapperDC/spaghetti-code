data "vkcs_images_image" "ubuntu" {
  visibility = "public"
  default    = true
  properties = {
    mcs_os_distro  = "ubuntu"
    mcs_os_version = "24.04"
  }
}

# Security group
resource "vkcs_networking_secgroup" "app_sg" {
  name = "app-sg"
}

# Разрешаем SSH
resource "vkcs_networking_secgroup_rule" "allow_ssh" {
  direction         = "ingress"
  protocol          = "tcp"
  port_range_min    = 22
  port_range_max    = 22
  remote_ip_prefix  = "0.0.0.0/0"
  security_group_id = vkcs_networking_secgroup.app_sg.id
}

# Разрешаем HTTP
resource "vkcs_networking_secgroup_rule" "allow_http" {
  direction         = "ingress"
  protocol          = "tcp"
  port_range_min    = 80
  port_range_max    = 80
  remote_ip_prefix  = "0.0.0.0/0"
  security_group_id = vkcs_networking_secgroup.app_sg.id
}

resource "vkcs_networking_port" "app_port" {
  name                  = "${var.vm_name}-port"
  network_id            = vkcs_networking_network.app_net.id
  security_group_ids    = [vkcs_networking_secgroup.app_sg.id]
  full_security_groups_control = true

  fixed_ip {
    subnet_id = vkcs_networking_subnet.app_subnet.id
  }
}

# Виртуальная машина
resource "vkcs_compute_instance" "app_vm" {
  name              = var.vm_name
  flavor_name       = var.vm_flavor
  key_pair          = var.ssh_key_name
  security_group_ids = [vkcs_networking_secgroup.app_sg.id]

  network {
    port = vkcs_networking_port.app_port.id
  }

  block_device {
    uuid                  = data.vkcs_images_image.ubuntu.id
    source_type           = "image"
    volume_size           = 10
    boot_index            = 0
    destination_type      = "volume"
    delete_on_termination = true
  }
}

# Floating IP для доступа к серверу (SSH/Ansible)
resource "vkcs_networking_floatingip" "app_fip" {
  pool = data.vkcs_networking_network.ext_net.name
}

resource "vkcs_networking_floatingip_associate" "app_fip_assoc" {
  floating_ip = vkcs_networking_floatingip.app_fip.address
  port_id     = vkcs_networking_port.app_port.id
}

# Outputs
output "vm_ip" {
  description = "Внешний IP сервера (для SSH и Ansible)"
  value       = vkcs_networking_floatingip.app_fip.address
}

