output "db_username" {
  value = var.db_username
}

output "db_password" {
  value = var.db_password
}

output "db_name" {
  value = var.db_name
}

output "db_hostname" {
  value = module.master.db_instance_address
}
