# creating azure Linux Virtual Machine 
resource "azurerm_linux_virtual_machine" "linux01" {
  name                = "linux01"

# additional properties elided for brevity
  source_image_reference {
    publisher = "Canonical"
    offer     = "0001-com-ubuntu-server-focal"
    sku       = "20_04-lts-gen2"
    version   = "latest"
  }

  custom_data = base64encode(templatefile("${path.module}/tailscale_cloudinit.tpl", {
    tailscale_auth_key = var.tailscale_auth_key
  }))
}

#install Tailscale into Azure Virtual Machine 
apt:
  sources:
    tailscale.list:
      source: deb https://pkgs.tailscale.com/stable/ubuntu focal main
      keyid: 2596A99EAAB33821893C0A79458CA832957F5868
packages:
  - tailscale
runcmd:
  - "tailscale up -authkey ${tailscale_auth_key} --advertise-tags=tag:server,tag:lab --advertise-routes=10.0.0.0/24,168.63.129.16/32 --accept-dns=false"
  - "echo 'net.ipv4.ip_forward = 1' | sudo tee -a /etc/sysctl.conf"
  - "echo 'net.ipv6.conf.all.forwarding = 1' | sudo tee -a /etc/sysctl.conf"
  - "sysctl -p /etc/sysctl.conf"