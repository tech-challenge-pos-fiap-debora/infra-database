locals {
  name = "${var.project_name}-${var.environment}"
}

resource "random_password" "master" {
  length  = 24
  special = false
}

resource "aws_security_group" "rds" {
  name        = "${local.name}-rds-sg"
  description = "PostgreSQL access from VPC"
  vpc_id      = var.vpc_id

  ingress {
    description = "PostgreSQL from VPC"
    from_port   = 5432
    to_port     = 5432
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
    Name = "${local.name}-rds-sg"
  })
}

resource "aws_db_subnet_group" "this" {
  name       = "${local.name}-rds"
  subnet_ids = var.private_subnet_ids

  tags = merge(var.tags, {
    Name = "${local.name}-rds"
  })
}

# Learner Lab: Postgres, classe micro/small/medium, gp2 <= 100 GB,
# sem Multi-AZ e sem Enhanced Monitoring.
resource "aws_db_instance" "this" {
  identifier = "${local.name}-pg"

  engine         = "postgres"
  engine_version = var.engine_version
  instance_class = var.instance_class

  db_name  = var.database_name
  username = var.master_username
  password = random_password.master.result

  allocated_storage     = var.allocated_storage
  max_allocated_storage = 0
  storage_type          = "gp2"
  storage_encrypted     = true

  db_subnet_group_name   = aws_db_subnet_group.this.name
  vpc_security_group_ids = [aws_security_group.rds.id]
  publicly_accessible    = false
  multi_az               = false
  availability_zone      = null

  backup_retention_period = var.backup_retention_period
  skip_final_snapshot     = true
  deletion_protection     = false

  performance_insights_enabled = false
  monitoring_interval          = 0
  apply_immediately            = true

  tags = var.tags
}
