# ──────────────────────────────────────────────
# Local tags merged into every resource via
# the provider default_tags block in provider.tf
# ──────────────────────────────────────────────

# ── VPC Module ────────────────────────────────
module "vpc" {
  source = "./modules/vpc"

  project_name         = var.project_name
  environment          = var.environment
  vpc_cidr             = var.vpc_cidr
  public_subnet_cidrs  = var.public_subnet_cidrs
  private_subnet_cidrs = var.private_subnet_cidrs
  availability_zones   = var.availability_zones
}

# ── EC2 Module ────────────────────────────────
module "ec2" {
  source = "./modules/ec2"

  project_name      = var.project_name
  environment       = var.environment
  ami_id            = var.ami_id
  instance_type     = var.instance_type
  key_pair_name     = var.key_pair_name
  allowed_ssh_cidr  = var.allowed_ssh_cidr
  vpc_id            = module.vpc.vpc_id
  public_subnet_ids = module.vpc.public_subnet_ids
}

# ── Storage Module ────────────────────────────
module "storage" {
  source = "./modules/storage"

  project_name        = var.project_name
  environment         = var.environment
  s3_bucket_name      = var.s3_bucket_name
  dynamodb_table_name = var.dynamodb_table_name
}
