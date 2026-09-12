output "cluster_endpoint" {
  value = module.documentdb.cluster_endpoint
}

output "cluster_port" {
  value = module.documentdb.cluster_port
}

output "security_group_id" {
  value = module.documentdb.security_group_id
}

output "master_username" {
  value = module.documentdb.master_username
}

output "mongo_url" {
  value     = module.documentdb.mongo_url
  sensitive = true
}
