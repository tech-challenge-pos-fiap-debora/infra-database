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

# URLs dos microsserviços (mesmo host/user; rode scripts/create-ms-databases.sh antes).
output "billing_connection_url" {
  value     = replace(module.rds.connection_url, "/${var.database_name}", "/billing")
  sensitive = true
}

output "stock_connection_url" {
  value     = replace(module.rds.connection_url, "/${var.database_name}", "/stock")
  sensitive = true
}

output "identity_connection_url" {
  value     = replace(module.rds.connection_url, "/${var.database_name}", "/identity")
  sensitive = true
}
