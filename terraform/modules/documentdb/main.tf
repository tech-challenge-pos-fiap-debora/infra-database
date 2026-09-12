locals {
  name = "${var.project_name}-${var.environment}"
}

resource "random_password" "master" {
  length  = 24
  special = false
}

resource "aws_security_group" "docdb" {
  name        = "${local.name}-docdb-sg"
  description = "DocumentDB access from VPC"
  vpc_id      = var.vpc_id

  ingress {
    description = "MongoDB from VPC"
    from_port   = 27017
    to_port     = 27017
    protocol    = "tcp"
    cidr_blocks = [var.vpc_cidr]
  }

  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }

  tags = merge(var.tags, {
    Name = "${local.name}-docdb-sg"
  })
}

resource "aws_docdb_subnet_group" "this" {
  name       = "${local.name}-docdb"
  subnet_ids = var.private_subnet_ids

  tags = merge(var.tags, {
    Name = "${local.name}-docdb"
  })
}

resource "aws_docdb_cluster" "this" {
  cluster_identifier      = "${local.name}-docdb"
  engine                  = "docdb"
  master_username         = var.master_username
  master_password         = random_password.master.result
  db_subnet_group_name    = aws_docdb_subnet_group.this.name
  vpc_security_group_ids  = [aws_security_group.docdb.id]
  storage_encrypted       = true
  backup_retention_period = var.backup_retention_period
  skip_final_snapshot     = true

  tags = var.tags
}

resource "aws_docdb_cluster_instance" "this" {
  count              = var.instance_count
  identifier         = "${local.name}-docdb-${count.index + 1}"
  cluster_identifier = aws_docdb_cluster.this.id
  instance_class     = var.instance_class

  tags = var.tags
}

locals {
  mongo_url = "mongodb://${var.master_username}:${random_password.master.result}@${aws_docdb_cluster.this.endpoint}:27017/${var.database_name}?tls=true&replicaSet=rs0&retryWrites=false"
}
