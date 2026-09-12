output "cluster_id" {
  value = aws_docdb_cluster.this.id
}

output "cluster_endpoint" {
  value = aws_docdb_cluster.this.endpoint
}

output "cluster_port" {
  value = aws_docdb_cluster.this.port
}

output "security_group_id" {
  value = aws_security_group.docdb.id
}

output "master_username" {
  value = var.master_username
}

output "mongo_url" {
  value     = local.mongo_url
  sensitive = true
}
