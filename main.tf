resource "alicloud_vpc" "default" {
  vpc_name    = var.vpc_config.vpc_name
  cidr_block  = var.vpc_config.cidr_block
  enable_ipv6 = true
  ipv6_isp    = var.vpc_config.ipv6_isp
}


resource "alicloud_vswitch" "nlb" {
  for_each = { for i, value in var.nlb_vswitches : value.cidr_block => value }

  vpc_id               = alicloud_vpc.default.id
  cidr_block           = each.key
  zone_id              = each.value.zone_id
  ipv6_cidr_block_mask = each.value.ipv6_cidr_block_mask
  vswitch_name         = each.value.vswitch_name
  enable_ipv6          = true
}

resource "alicloud_vswitch" "app" {
  for_each = { for i, value in var.app_vswitches : value.cidr_block => value }

  vpc_id               = alicloud_vpc.default.id
  cidr_block           = each.key
  zone_id              = each.value.zone_id
  ipv6_cidr_block_mask = each.value.ipv6_cidr_block_mask
  vswitch_name         = each.value.vswitch_name
  enable_ipv6          = true
}

resource "alicloud_security_group" "default" {
  security_group_name = var.security_group_name
  vpc_id              = alicloud_vpc.default.id
}


resource "alicloud_instance" "default" {
  for_each = alicloud_vswitch.app

  availability_zone          = each.value.zone_id
  vswitch_id                 = each.value.id
  security_groups            = [alicloud_security_group.default.id]
  instance_type              = var.ecs_config.instance_type
  system_disk_category       = var.ecs_config.system_disk_category
  image_id                   = var.ecs_config.image_id
  instance_name              = var.ecs_config.instance_name
  internet_max_bandwidth_out = var.ecs_config.internet_max_bandwidth_out
  ipv6_address_count         = var.ecs_config.ipv6_address_count
}

resource "alicloud_vpc_ipv6_gateway" "default" {
  ipv6_gateway_name = var.vpc_ipv6_gateway_name
  vpc_id            = alicloud_vpc.default.id
}

resource "alicloud_common_bandwidth_package" "default" {
  count = var.create_common_bandwidth_package ? 1 : 0

  bandwidth_package_name = var.common_bandwidth_package.name
  isp                    = var.common_bandwidth_package.isp
  bandwidth              = var.common_bandwidth_package.bandwidth
  ratio                  = var.common_bandwidth_package.ratio
  internet_charge_type   = var.common_bandwidth_package.internet_charge_type
}

locals {
  bandwidth_package_id = var.create_common_bandwidth_package ? alicloud_common_bandwidth_package.default[0].id : var.exsiting_common_bandwidth_package_id
}


resource "alicloud_nlb_load_balancer" "default" {
  load_balancer_name   = var.nlb_load_balancer.load_balancer_name
  load_balancer_type   = "Network"
  address_type         = "Internet"
  address_ip_version   = "DualStack"
  ipv6_address_type    = "Internet"
  vpc_id               = alicloud_vpc.default.id
  bandwidth_package_id = local.bandwidth_package_id

  dynamic "zone_mappings" {
    for_each = alicloud_vswitch.nlb
    content {
      vswitch_id = zone_mappings.value.id
      zone_id    = zone_mappings.value.zone_id
    }
  }
}


resource "alicloud_nlb_server_group" "default" {
  server_group_name          = var.nlb_server_group.server_group_name
  server_group_type          = "Instance"
  vpc_id                     = alicloud_vpc.default.id
  scheduler                  = var.nlb_server_group.scheduler
  protocol                   = var.nlb_server_group.protocol
  preserve_client_ip_enabled = var.nlb_server_group.preserve_client_ip_enabled
  address_ip_version         = "DualStack"

  dynamic "health_check" {
    for_each = [var.nlb_server_group.health_check_config]
    content {
      health_check_enabled         = health_check.value.health_check_enabled
      health_check_type            = health_check.value.health_check_type
      health_check_connect_port    = health_check.value.health_check_connect_port
      healthy_threshold            = health_check.value.healthy_threshold
      unhealthy_threshold          = health_check.value.unhealthy_threshold
      health_check_connect_timeout = health_check.value.health_check_connect_timeout
      health_check_interval        = health_check.value.health_check_interval
      http_check_method            = health_check.value.http_check_method
      health_check_http_code       = health_check.value.health_check_http_code
    }
  }
}

resource "alicloud_nlb_server_group_server_attachment" "ECSv4" {
  for_each = alicloud_instance.default

  server_type     = "Ecs"
  server_id       = each.value.id
  server_group_id = alicloud_nlb_server_group.default.id
  weight          = 100
  port            = var.nlb_server_group_server_port
  server_ip       = each.value.private_ip
}

resource "alicloud_nlb_server_group_server_attachment" "ECSv6" {
  for_each = alicloud_instance.default

  server_type     = "Ecs"
  server_id       = each.value.id
  server_group_id = alicloud_nlb_server_group.default.id
  weight          = 100
  port            = var.nlb_server_group_server_port
  server_ip       = tolist(each.value.ipv6_addresses)[0]
}

resource "alicloud_nlb_listener" "default" {
  listener_protocol      = var.nlb_listener.listener_protocol
  listener_port          = var.nlb_listener.listener_port
  load_balancer_id       = alicloud_nlb_load_balancer.default.id
  server_group_id        = alicloud_nlb_server_group.default.id
  idle_timeout           = var.nlb_listener.idle_timeout
  proxy_protocol_enabled = true
}
