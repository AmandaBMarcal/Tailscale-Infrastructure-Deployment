terraform {
  required_providers {
    tailscale = {
      source = "tailscale/tailscale"
      version = "~> 0.13.7"
    }
  }
}

provider "tailscale" {
  api_key = var.tailscale_api_key
  tailnet = var.tailnet_name
}

resource "tailscale_device" "subnet_router" {
  name = "subnet-router"
  tags = ["tag:subnet-router"]
}

resource "tailscale_device" "ssh_device" {
  name = "ssh-device"
  tags = ["tag:ssh"]
}

resource "tailscale_device_ssh" "ssh_config" {
  device_id = tailscale_device.ssh_device.id
  enabled   = true
}

resource "tailscale_subnet_route" "example_subnet" {
  subnet = "10.0.0.0/24"
  advertise_exit_node = false
}