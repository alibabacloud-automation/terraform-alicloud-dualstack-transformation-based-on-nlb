
# Complete

## Usage

To run this example you need to execute:

```bash
$ terraform init
$ terraform plan
$ terraform apply
```

Note that this example may create resources which cost money. Run `terraform destroy` when you don't need these resources.

<!-- BEGIN_TF_DOCS -->
## Requirements

| Name | Version |
|------|---------|
| <a name="requirement_terraform"></a> [terraform](#requirement\_terraform) | >= 1.3 |
| <a name="requirement_alicloud"></a> [alicloud](#requirement\_alicloud) | >= 1.245.0 |

## Providers

No providers.

## Modules

| Name | Source | Version |
|------|--------|---------|
| <a name="module_complete"></a> [complete](#module\_complete) | ../.. | n/a |

## Resources

No resources.

## Inputs

No inputs.

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