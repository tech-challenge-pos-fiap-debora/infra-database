locals {
  common_tags = {
    Project     = var.project_name
    Environment = var.environment
  }
}

data "aws_vpc" "this" {
  filter {
    name   = "tag:Project"
    values = [var.project_name]
  }

  filter {
    name   = "tag:Environment"
    values = [var.environment]
  }
}

data "aws_subnets" "private" {
  filter {
    name   = "vpc-id"
    values = [data.aws_vpc.this.id]
  }

  tags = {
    "kubernetes.io/role/internal-elb" = "1"
  }
}

module "documentdb" {
  source = "../../modules/documentdb"

  project_name            = var.project_name
  environment             = var.environment
  vpc_id                  = data.aws_vpc.this.id
  vpc_cidr                = data.aws_vpc.this.cidr_block
  private_subnet_ids      = data.aws_subnets.private.ids
  database_name           = var.database_name
  master_username         = var.master_username
  instance_class          = var.instance_class
  instance_count          = var.instance_count
  backup_retention_period = var.backup_retention_period
  tags                    = local.common_tags
}
