variable "vpc_config" {
  description = "The parameters of vpc and vswitches."
  type = object({
    cidr_block = string
    vpc_name   = optional(string, null)
    ipv6_isp   = optional(string, "BGP")
  })
}

variable "nlb_vswitches" {
  description = "The vswitches used for nlb."
  type = list(object({
    zone_id              = string
    cidr_block           = string
    ipv6_cidr_block_mask = number
    vswitch_name         = optional(string, null)
  }))
}

variable "app_vswitches" {
  description = "The vswitches used for application server."
  type = list(object({
    zone_id              = string
    cidr_block           = string
    ipv6_cidr_block_mask = number
    vswitch_name         = optional(string, null)
  }))
}


variable "security_group_name" {
  description = "The name of security group."
  type        = string
  default     = null
}

variable "ecs_config" {
  description = "The parameters of ecs instance."
  type = object({
    instance_type              = optional(string, "ecs.g6e.large")
    system_disk_category       = optional(string, "cloud_essd")
    image_id                   = optional(string, "ubuntu_24_04_x64_20G_alibase_20250113.vhd")
    instance_name              = optional(string, null)
    internet_max_bandwidth_out = optional(number, 0)
    ipv6_address_count         = optional(number, 1)
  })
  default = {}
}

variable "vpc_ipv6_gateway_name" {
  description = "The name of vpc ipv6 gateway."
  type        = string
  default     = null
}

variable "create_common_bandwidth_package" {
  description = "Whether to create common bandwidth package."
  type        = bool
  default     = true
}

variable "common_bandwidth_package" {
  description = "The parameters of common bandwidth package."
  type = object({
    name                 = optional(string, null)
    internet_charge_type = optional(string, "PayBy95")
    ratio                = optional(number, 20)
    isp                  = optional(string, "BGP")
    bandwidth            = optional(string, "1000")
  })
  default = {}
}

variable "exsiting_common_bandwidth_package_id" {
  description = "The id of existing common bandwidth package. If `create_common_bandwidth_package` is false, this value is required."
  type        = string
  default     = null
}

variable "nlb_load_balancer" {
  description = "The parameters of nlb load balancer."
  type = object({
    load_balancer_name = optional(string, null)
  })
  default = {
    load_balancer_name = "ipv6-nlb"
  }
}

variable "nlb_server_group" {
  description = "The parameters of nlb server group. The attribute 'server_group_name' is required."
  type = object({
    server_group_name          = string
    scheduler                  = optional(string, "Wrr")
    protocol                   = optional(string, "TCP")
    preserve_client_ip_enabled = optional(bool, true)
    connection_drain_enabled   = optional(bool, true)
    connection_drain_timeout   = optional(number, 60)

    health_check_config = optional(object({
      health_check_enabled         = optional(bool, true)
      health_check_type            = optional(string, "TCP")
      health_check_connect_port    = optional(number, 0)
      healthy_threshold            = optional(number, 2)
      unhealthy_threshold          = optional(number, 2)
      health_check_connect_timeout = optional(number, 5)
      health_check_interval        = optional(number, 10)
      http_check_method            = optional(string, "GET")
      health_check_http_code       = optional(list(string), ["http_2xx", "http_3xx", "http_4xx"])
    }), {})
  })
  default = {
    server_group_name = "idc_server_group"
  }
}


variable "nlb_server_group_server_port" {
  description = "The ports of nlb server group server."
  type        = number
  default     = 443
}


variable "nlb_listener" {
  description = "The parameters of nlb listener."
  type = object({
    listener_protocol = optional(string, "TCP")
    listener_port     = optional(number, 443)
    idle_timeout      = optional(number, 900)
  })
  default = {}
}
