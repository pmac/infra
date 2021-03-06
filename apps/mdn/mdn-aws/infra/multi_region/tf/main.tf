provider "aws" {
  region = "${var.region}"
}

terraform {
  backend "s3" {
    bucket = "mdn-multi-region-tf-state"
    key    = "tf-state"
    region = "us-west-2"
  }
}


#########################################
# EFS
#########################################

module "efs-dev" {
    source = "efs"
    efs_name = "dev"
    subnets = "${var.subnets}"
    nodes_security_group = "${var.nodes_security_group}"
}

module "efs-stage" {
    source = "efs"
    efs_name = "stage"
    subnets = "${var.subnets}"
    nodes_security_group = "${var.nodes_security_group}"
}

module "efs-prod" {
    source = "efs"
    efs_name = "prod"
    subnets = "${var.subnets}"
    nodes_security_group = "${var.nodes_security_group}"
}


#########################################
# Redis
#########################################

module "redis-dev" {
    source = "redis"
    redis_name = "dev"
    redis_node_size = "cache.t2.micro"
    redis_num_nodes = 1
    subnets = "${var.subnets}"
    nodes_security_group = "${var.nodes_security_group}"
}

module "redis-stage" {
    source = "redis"
    redis_name = "stage"
    redis_node_size = "cache.t2.small"
    redis_num_nodes = 3
    subnets = "${var.subnets}"
    nodes_security_group = "${var.nodes_security_group}"
}

module "redis-prod" {
    source = "redis"
    redis_name = "prod"
    redis_node_size = "cache.m3.xlarge"
    redis_num_nodes = 3
    subnets = "${var.subnets}"
    nodes_security_group = "${var.nodes_security_group}"
}


#########################################
# Memcached
#########################################

module "memcached-dev" {
    source = "memcached"
    memcached_name = "dev"
    memcached_node_size = "cache.t2.micro"
    memcached_num_nodes = 1
    subnets = "${var.subnets}"
    nodes_security_group = "${var.nodes_security_group}"
}

module "memcached-stage" {
    source = "memcached"
    memcached_name = "stage"
    memcached_node_size = "cache.t2.small"
    memcached_num_nodes = 3
    subnets = "${var.subnets}"
    nodes_security_group = "${var.nodes_security_group}"
}

module "memcached-prod" {
    source = "memcached"
    memcached_name = "prod"
    memcached_node_size = "cache.m3.xlarge"
    memcached_num_nodes = 3
    subnets = "${var.subnets}"
    nodes_security_group = "${var.nodes_security_group}"
}


#########################################
# MySQL
#########################################

module "mysql-stage" {
    source = "rds"
    # DBName must begin with a letter and contain only alphanumeric characters

    mysql_env     = "stage"
    mysql_db_name = "developer_allizom_org"
    mysql_username = "root"
    mysql_password = "${var.mysql_stage_password}"
    mysql_identifier = "mdn-stage"
    mysql_instance_class = "db.t2.large"
    mysql_backup_retention_days = 0
    mysql_security_group_name = "mdn_rds_sg"
    mysql_storage_gb = 100
    mysql_storage_type = "gp2"
    vpc_id = "${var.vpc_id}"
    vpc_cidr = "${var.vpc_cidr}"
}

module "mysql-prod" {
    source = "rds"
    # DBName must begin with a letter and contain only alphanumeric characters
    mysql_env     = "prod"
    mysql_db_name = "developer_mozilla_org"
    mysql_username = "root"
    mysql_password = "${var.mysql_prod_password}"
    mysql_identifier = "mdn-prod"
    mysql_instance_class = "db.m4.xlarge"
    mysql_backup_retention_days = 7
    mysql_security_group_name = "mdn_rds_sg_prod"
    mysql_storage_gb = 200
    mysql_storage_type = "gp2"
    vpc_id = "${var.vpc_id}"
    vpc_cidr = "${var.vpc_cidr}"
}

