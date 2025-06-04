provider "aws" {
  region = "us-east-1"
}

# Modulo VPC
# module "vpc" {
#   source = "../modules/vpc"
#   name   = "prod-vpc"
#   cidr_block = "10.0.0.0/16"
#   public_subnets = ["10.0.1.0/24", "10.0.2.0/24"]
#   private_subnets = ["10.0.10.0/24", "10.0.11.0/24"]
# }

# Modulo EKS Cluster
module "eks_cluster" {
  source = "../modules/eks-cluster"
  cluster_name = "prod-eks-cluster"
  vpc_id       = module.vpc.vpc_id
  subnet_ids   = module.vpc.private_subnets
  instance_types = ["m5.large"]
  desired_size   = 3
  max_size       = 5
  min_size       = 3
  depends_on = [module.vpc]
}

# resource "aws_db_instance" "prod_db" {
#   allocated_storage    = 20
#   storage_type         = "gp2"
#   engine               = "postgres"
#   engine_version       = "14.5"
#   instance_class       = "db.t3.medium"
#   name                 = "app1_prod_db"
#   username             = "appuser"
#   password             = "REPLACE_ME_WITH_SECRET" # Usar Secrets Manager o Vault
#   multi_az             = true
#   vpc_security_group_ids = [module.vpc.default_security_group_id]
#   db_subnet_group_name = module.vpc.database_subnet_group_name
#   skip_final_snapshot  = false
# }