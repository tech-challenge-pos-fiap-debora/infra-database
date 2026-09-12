variable "aws_region" {
  type    = string
  default = "us-east-1"
}

variable "project_name" {
  type    = string
  default = "tech-challenge"
}

variable "environment" {
  type    = string
  default = "prod"
}

variable "database_name" {
  type    = string
  default = "techChallenge"
}

variable "master_username" {
  type    = string
  default = "techchallenge"
}

variable "instance_class" {
  type    = string
  default = "db.t3.medium"
}

variable "instance_count" {
  type    = number
  default = 1
}

variable "backup_retention_period" {
  type    = number
  default = 7
}
