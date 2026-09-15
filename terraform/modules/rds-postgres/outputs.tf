output "endpoint" {
  value = aws_db_instance.this.address
}

output "port" {
  value = aws_db_instance.this.port
}

output "security_group_id" {
  value = aws_security_group.rds.id
}

output "master_username" {
  value = aws_db_instance.this.username
}

output "database_name" {
  value = aws_db_instance.this.db_name
}

output "connection_url" {
  value     = "postgresql://${var.master_username}:${random_password.master.result}@${aws_db_instance.this.address}:${aws_db_instance.this.port}/${var.database_name}"
  sensitive = true
}
