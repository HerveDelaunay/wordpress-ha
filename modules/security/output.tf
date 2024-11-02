output "allow_private_rds_id" {
  value = module.allow_private_rds_sg.security_group_id
}

output "allow_public_http_id" {
  value = module.allow_public_http_sg.security_group_id
}

output "allow_private_ssh_id" {
  value = module.allow_private_ssh_sg.security_group_id
}

output "allow_all_outbound_id" {
  value = module.allow_all_outbound_sg.security_group_id
}
