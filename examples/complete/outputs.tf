output "vpc_id" {
  description = "The ID of the VPC."
  value       = module.complete.vpc_id
}

output "nlb_vswitch_ids" {
  description = "The IDs of the NLB VSwitches."
  value       = module.complete.nlb_vswitch_ids
}

output "app_vswitch_ids" {
  description = "The IDs of the App VSwitches."
  value       = module.complete.app_vswitch_ids
}

output "security_group_id" {
  description = "The ID of the security group."
  value       = module.complete.security_group_id
}

output "instance_ids" {
  description = "The IDs of the ECS instances."
  value       = module.complete.instance_ids
}

output "ipv6_gateway_id" {
  description = "The ID of the IPv6 gateway."
  value       = module.complete.ipv6_gateway_id
}

output "bandwidth_package_id" {
  description = "The ID of the common bandwidth package."
  value       = module.complete.bandwidth_package_id
}

output "nlb_load_balancer_id" {
  description = "The ID of the NLB load balancer."
  value       = module.complete.nlb_load_balancer_id
}

output "nlb_server_group_id" {
  description = "The ID of the NLB server group."
  value       = module.complete.nlb_server_group_id
}

output "nlb_listener_id" {
  description = "The ID of the NLB listener."
  value       = module.complete.nlb_listener_id
}
