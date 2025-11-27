Terraform module implement dual stack transformation based on NLB for Alibaba Cloud

terraform-alicloud-dualstack-transformation-based-on-nlb
======================================

English | [简体中文](https://github.com/alibabacloud-automation/terraform-alicloud-dualstack-transformation-based-on-nlb/blob/main/README-CN.md)

Faced with the requirements of IPv6 transformation, some enterprises will adopt the dual-stack solution. That is, both the Internet network entrance and the server of the application system are enabled with IPv6，so that the server can receive and respond to requests from the client using both IPv4 and IPv6 protocols.  

This module deploys a dual-stack version of NLB and build a dual-stack network environment for cloud application systems.

Architecture Diagram:

![image](https://raw.githubusercontent.com/alibabacloud-automation/terraform-alicloud-dualstack-transformation-based-on-nlb/main/scripts/diagram.png)


## Usage

<div style="display: block;margin-bottom: 40px;"><div class="oics-button" style="float: right;position: absolute;margin-bottom: 10px;">
  <a href="https://api.aliyun.com/terraform?source=Module&activeTab=document&sourcePath=alibabacloud-automation%3A%3Adualstack-transformation-based-on-nlb&spm=docs.m.alibabacloud-automation.dualstack-transformation-based-on-nlb&intl_lang=EN_US" target="_blank">
    <img alt="Open in AliCloud" src="https://img.alicdn.com/imgextra/i1/O1CN01hjjqXv1uYUlY56FyX_!!6000000006049-55-tps-254-36.svg" style="max-height: 44px; max-width: 100%;">
  </a>
</div></div>

```hcl
provider "alicloud" {
  region = "cn-shanghai"
}

module "complete" {
  source = "alibabacloud-automation/dualstack-transformation-based-on-nlb/alicloud"

  vpc_config = {
    cidr_block = "10.0.0.0/8"
    vpc_name   = "ipv6-vpc"
  }
  nlb_vswitches = [{
    vswitch_name         = "ipv6-nlb-vsw1"
    ipv6_cidr_block_mask = 1
    zone_id              = "cn-shanghai-g"
    cidr_block           = "10.0.0.0/25"
    }, {
    vswitch_name         = "ipv6-nlb-vsw2"
    ipv6_cidr_block_mask = 2
    zone_id              = "cn-shanghai-l"
    cidr_block           = "10.0.0.128/25"
  }]

  app_vswitches = [{
    vswitch_name         = "ipv6-app-vsw3"
    ipv6_cidr_block_mask = 3
    zone_id              = "cn-shanghai-g"
    cidr_block           = "10.0.1.0/24"
    }, {
    vswitch_name         = "ipv6-app-vsw4"
    ipv6_cidr_block_mask = 4
    zone_id              = "cn-shanghai-l"
    cidr_block           = "10.0.2.0/24"
  }]
}
```

## Examples

* [Complete Example](https://github.com/alibabacloud-automation/terraform-alicloud-dualstack-transformation-based-on-nlb/tree/main/examples/complete)

<!-- BEGIN_TF_DOCS -->
## Requirements

| Name | Version |
|------|---------|
| <a name="requirement_terraform"></a> [terraform](#requirement\_terraform) | >= 1.3 |
| <a name="requirement_alicloud"></a> [alicloud](#requirement\_alicloud) | >= 1.245.0 |

## Providers

| Name | Version |
|------|---------|
| <a name="provider_alicloud"></a> [alicloud](#provider\_alicloud) | >= 1.245.0 |

## Modules

No modules.

## Resources

| Name | Type |
|------|------|
| [alicloud_common_bandwidth_package.default](https://registry.terraform.io/providers/hashicorp/alicloud/latest/docs/resources/common_bandwidth_package) | resource |
| [alicloud_instance.default](https://registry.terraform.io/providers/hashicorp/alicloud/latest/docs/resources/instance) | resource |
| [alicloud_nlb_listener.default](https://registry.terraform.io/providers/hashicorp/alicloud/latest/docs/resources/nlb_listener) | resource |
| [alicloud_nlb_load_balancer.default](https://registry.terraform.io/providers/hashicorp/alicloud/latest/docs/resources/nlb_load_balancer) | resource |
| [alicloud_nlb_server_group.default](https://registry.terraform.io/providers/hashicorp/alicloud/latest/docs/resources/nlb_server_group) | resource |
| [alicloud_nlb_server_group_server_attachment.ECSv4](https://registry.terraform.io/providers/hashicorp/alicloud/latest/docs/resources/nlb_server_group_server_attachment) | resource |
| [alicloud_nlb_server_group_server_attachment.ECSv6](https://registry.terraform.io/providers/hashicorp/alicloud/latest/docs/resources/nlb_server_group_server_attachment) | resource |
| [alicloud_security_group.default](https://registry.terraform.io/providers/hashicorp/alicloud/latest/docs/resources/security_group) | resource |
| [alicloud_vpc.default](https://registry.terraform.io/providers/hashicorp/alicloud/latest/docs/resources/vpc) | resource |
| [alicloud_vpc_ipv6_gateway.default](https://registry.terraform.io/providers/hashicorp/alicloud/latest/docs/resources/vpc_ipv6_gateway) | resource |
| [alicloud_vswitch.app](https://registry.terraform.io/providers/hashicorp/alicloud/latest/docs/resources/vswitch) | resource |
| [alicloud_vswitch.nlb](https://registry.terraform.io/providers/hashicorp/alicloud/latest/docs/resources/vswitch) | resource |

## Inputs

| Name | Description | Type | Default | Required |
|------|-------------|------|---------|:--------:|
| <a name="input_app_vswitches"></a> [app\_vswitches](#input\_app\_vswitches) | The vswitches used for application server. | <pre>list(object({<br>    zone_id              = string<br>    cidr_block           = string<br>    ipv6_cidr_block_mask = number<br>    vswitch_name         = optional(string, null)<br>  }))</pre> | n/a | yes |
| <a name="input_common_bandwidth_package"></a> [common\_bandwidth\_package](#input\_common\_bandwidth\_package) | The parameters of common bandwidth package. | <pre>object({<br>    name                 = optional(string, null)<br>    internet_charge_type = optional(string, "PayBy95")<br>    ratio                = optional(number, 20)<br>    isp                  = optional(string, "BGP")<br>    bandwidth            = optional(string, "1000")<br>  })</pre> | `{}` | no |
| <a name="input_create_common_bandwidth_package"></a> [create\_common\_bandwidth\_package](#input\_create\_common\_bandwidth\_package) | Whether to create common bandwidth package. | `bool` | `true` | no |
| <a name="input_ecs_config"></a> [ecs\_config](#input\_ecs\_config) | The parameters of ecs instance. | <pre>object({<br>    instance_type              = optional(string, "ecs.g6e.large")<br>    system_disk_category       = optional(string, "cloud_essd")<br>    image_id                   = optional(string, "ubuntu_24_04_x64_20G_alibase_20250113.vhd")<br>    instance_name              = optional(string, null)<br>    internet_max_bandwidth_out = optional(number, 0)<br>    ipv6_address_count         = optional(number, 1)<br>  })</pre> | `{}` | no |
| <a name="input_exsiting_common_bandwidth_package_id"></a> [exsiting\_common\_bandwidth\_package\_id](#input\_exsiting\_common\_bandwidth\_package\_id) | The id of existing common bandwidth package. If `create_common_bandwidth_package` is false, this value is required. | `string` | `null` | no |
| <a name="input_nlb_listener"></a> [nlb\_listener](#input\_nlb\_listener) | The parameters of nlb listener. | <pre>object({<br>    listener_protocol = optional(string, "TCP")<br>    listener_port     = optional(number, 443)<br>    idle_timeout      = optional(number, 900)<br>  })</pre> | `{}` | no |
| <a name="input_nlb_load_balancer"></a> [nlb\_load\_balancer](#input\_nlb\_load\_balancer) | The parameters of nlb load balancer. | <pre>object({<br>    load_balancer_name = optional(string, null)<br>  })</pre> | <pre>{<br>  "load_balancer_name": "ipv6-nlb"<br>}</pre> | no |
| <a name="input_nlb_server_group"></a> [nlb\_server\_group](#input\_nlb\_server\_group) | The parameters of nlb server group. The attribute 'server\_group\_name' is required. | <pre>object({<br>    server_group_name          = string<br>    scheduler                  = optional(string, "Wrr")<br>    protocol                   = optional(string, "TCP")<br>    preserve_client_ip_enabled = optional(bool, true)<br>    connection_drain_enabled   = optional(bool, true)<br>    connection_drain_timeout   = optional(number, 60)<br><br>    health_check_config = optional(object({<br>      health_check_enabled         = optional(bool, true)<br>      health_check_type            = optional(string, "TCP")<br>      health_check_connect_port    = optional(number, 0)<br>      healthy_threshold            = optional(number, 2)<br>      unhealthy_threshold          = optional(number, 2)<br>      health_check_connect_timeout = optional(number, 5)<br>      health_check_interval        = optional(number, 10)<br>      http_check_method            = optional(string, "GET")<br>      health_check_http_code       = optional(list(string), ["http_2xx", "http_3xx", "http_4xx"])<br>    }), {})<br>  })</pre> | <pre>{<br>  "server_group_name": "idc_server_group"<br>}</pre> | no |
| <a name="input_nlb_server_group_server_port"></a> [nlb\_server\_group\_server\_port](#input\_nlb\_server\_group\_server\_port) | The ports of nlb server group server. | `number` | `443` | no |
| <a name="input_nlb_vswitches"></a> [nlb\_vswitches](#input\_nlb\_vswitches) | The vswitches used for nlb. | <pre>list(object({<br>    zone_id              = string<br>    cidr_block           = string<br>    ipv6_cidr_block_mask = number<br>    vswitch_name         = optional(string, null)<br>  }))</pre> | n/a | yes |
| <a name="input_security_group_name"></a> [security\_group\_name](#input\_security\_group\_name) | The name of security group. | `string` | `null` | no |
| <a name="input_vpc_config"></a> [vpc\_config](#input\_vpc\_config) | The parameters of vpc and vswitches. | <pre>object({<br>    cidr_block = string<br>    vpc_name   = optional(string, null)<br>    ipv6_isp   = optional(string, "BGP")<br>  })</pre> | n/a | yes |
| <a name="input_vpc_ipv6_gateway_name"></a> [vpc\_ipv6\_gateway\_name](#input\_vpc\_ipv6\_gateway\_name) | The name of vpc ipv6 gateway. | `string` | `null` | no |

## Outputs

| Name | Description |
|------|-------------|
| <a name="output_app_vswitch_ids"></a> [app\_vswitch\_ids](#output\_app\_vswitch\_ids) | The IDs of the App VSwitches. |
| <a name="output_bandwidth_package_id"></a> [bandwidth\_package\_id](#output\_bandwidth\_package\_id) | The ID of the common bandwidth package. |
| <a name="output_instance_ids"></a> [instance\_ids](#output\_instance\_ids) | The IDs of the ECS instances. |
| <a name="output_ipv6_gateway_id"></a> [ipv6\_gateway\_id](#output\_ipv6\_gateway\_id) | The ID of the IPv6 gateway. |
| <a name="output_nlb_listener_id"></a> [nlb\_listener\_id](#output\_nlb\_listener\_id) | The ID of the NLB listener. |
| <a name="output_nlb_load_balancer_id"></a> [nlb\_load\_balancer\_id](#output\_nlb\_load\_balancer\_id) | The ID of the NLB load balancer. |
| <a name="output_nlb_server_group_id"></a> [nlb\_server\_group\_id](#output\_nlb\_server\_group\_id) | The ID of the NLB server group. |
| <a name="output_nlb_vswitch_ids"></a> [nlb\_vswitch\_ids](#output\_nlb\_vswitch\_ids) | The IDs of the NLB VSwitches. |
| <a name="output_security_group_id"></a> [security\_group\_id](#output\_security\_group\_id) | The ID of the security group. |
| <a name="output_vpc_id"></a> [vpc\_id](#output\_vpc\_id) | The ID of the VPC. |
<!-- END_TF_DOCS -->

## Submit Issues

If you have any problems when using this module, please opening
a [provider issue](https://github.com/aliyun/terraform-provider-alicloud/issues/new) and let us know.

**Note:** There does not recommend opening an issue on this repo.

## Authors

Created and maintained by Alibaba Cloud Terraform Team(terraform@alibabacloud.com).

## License

MIT Licensed. See LICENSE for full details.

## Reference

* [Terraform-Provider-Alicloud Github](https://github.com/aliyun/terraform-provider-alicloud)
* [Terraform-Provider-Alicloud Release](https://releases.hashicorp.com/terraform-provider-alicloud/)
* [Terraform-Provider-Alicloud Docs](https://registry.terraform.io/providers/aliyun/alicloud/latest/docs)
