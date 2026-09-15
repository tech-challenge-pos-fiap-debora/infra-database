output "endpoint" {
  value = module.rds.endpoint
}

output "port" {
  value = module.rds.port
}

output "security_group_id" {
  value = module.rds.security_group_id
}

output "master_username" {
  value = module.rds.master_username
}

output "database_name" {
  value = module.rds.database_name
}

output "connection_url" {
  value     = module.rds.connection_url
  sensitive = true
}
