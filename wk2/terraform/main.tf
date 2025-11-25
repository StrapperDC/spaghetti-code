data "vkcs_images_image" "ubuntu" {
  visibility = "public"
  default    = true
  properties = {
    mcs_os_distro  = "ubuntu"
    mcs_os_version = "24.04"
  }
}

# Security Group для GitLab
resource "vkcs_networking_secgroup" "gitlab_sg" {
  name = "gitlab-sg"
}

resource "vkcs_networking_secgroup_rule" "gitlab_web" {
  direction         = "ingress"
  protocol          = "tcp"
  port_range_min    = 80
  port_range_max    = 80
  remote_ip_prefix  = "0.0.0.0/0"
  security_group_id = vkcs_networking_secgroup.gitlab_sg.id
}

resource "vkcs_networking_secgroup_rule" "gitlab_https" {
  direction         = "ingress"
  protocol          = "tcp"
  port_range_min    = 443
  port_range_max    = 443
  remote_ip_prefix  = "0.0.0.0/0"
  security_group_id = vkcs_networking_secgroup.gitlab_sg.id
}

resource "vkcs_networking_secgroup_rule" "gitlab_ssh" {
  direction         = "ingress"
  protocol          = "tcp"
  port_range_min    = 22
  port_range_max    = 22
  remote_ip_prefix  = "0.0.0.0/0"
  security_group_id = vkcs_networking_secgroup.gitlab_sg.id
}

# GitLab Server
resource "vkcs_compute_instance" "gitlab_server" {
  name              = var.vm_name
  flavor_name       = var.vm_flavor
  key_pair          = var.ssh_key_name
  security_group_ids = [vkcs_networking_secgroup.gitlab_sg.id]

  network {
    port = vkcs_networking_port.gitlab_port.id
  }

  block_device {
    uuid                  = data.vkcs_images_image.ubuntu.id
    source_type           = "image"
    volume_size           = 50
    boot_index            = 0
    destination_type      = "volume"
    delete_on_termination = true
  }

  depends_on = [vkcs_networking_router_interface.router_interface]
}

# Floating IP для GitLab
resource "vkcs_networking_floatingip" "gitlab_fip" {
  pool = data.vkcs_networking_network.ext_net.name
}

resource "vkcs_networking_floatingip_associate" "gitlab_fip_assoc" {
  floating_ip = vkcs_networking_floatingip.gitlab_fip.address
  port_id     = vkcs_networking_port.gitlab_port.id

  depends_on = [vkcs_networking_router_interface.router_interface]
}

# Duck DNS обновление для GitLab
resource "null_resource" "update_duckdns_gitlab" {
  triggers = {
    gitlab_ip = vkcs_networking_floatingip.gitlab_fip.address
  }

  provisioner "local-exec" {
    command = "curl -s 'https://www.duckdns.org/update?domains=${var.gitlab_duckdns_domain}&token=${var.duckdns_token}&ip=${vkcs_networking_floatingip.gitlab_fip.address}'"
  }

  depends_on = [vkcs_networking_floatingip_associate.gitlab_fip_assoc]
}

output "gitlab_ip" {
  description = "Внешний IP GitLab сервера"
  value       = vkcs_networking_floatingip.gitlab_fip.address
}

output "gitlab_url" {
  description = "URL GitLab"
  value       = "http://${var.gitlab_duckdns_domain}.duckdns.org"
}
