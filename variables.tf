# ──────────────────────────────────────────────
# Global
# ──────────────────────────────────────────────
variable "aws_region" {
  description = "AWS region to deploy all resources"
  type        = string
  default     = "ap-southeast-1" # Singapore
}

variable "project_name" {
  description = "Short project identifier used in resource names and tags"
  type        = string
}

variable "environment" {
  description = "Deployment environment: dev | staging | prod"
  type        = string
  validation {
    condition     = contains(["dev", "staging", "prod"], var.environment)
    error_message = "environment must be one of: dev, staging, prod."
  }
}

variable "owner_email" {
  description = "Email of the infra owner (used in tags)"
  type        = string
}

# ──────────────────────────────────────────────
# VPC
# ──────────────────────────────────────────────
variable "vpc_cidr" {
  description = "CIDR block for the VPC"
  type        = string
  default     = "10.0.0.0/16"
}

variable "public_subnet_cidrs" {
  description = "CIDR blocks for the two public subnets (one per AZ)"
  type        = list(string)
  default     = ["10.0.1.0/24", "10.0.2.0/24"]
}

variable "private_subnet_cidrs" {
  description = "CIDR blocks for the two private subnets (one per AZ)"
  type        = list(string)
  default     = ["10.0.3.0/24", "10.0.4.0/24"]
}

variable "availability_zones" {
  description = "List of AZs to use (must match the region)"
  type        = list(string)
  default     = ["ap-southeast-1a", "ap-southeast-1b"]
}

# ──────────────────────────────────────────────
# EC2
# ──────────────────────────────────────────────
variable "ami_id" {
  description = "AMI ID for EC2 instances (Amazon Linux 2023 free-tier)"
  type        = string
  default     = "ami-0df7a207adb9748c7" # Amazon Linux 2023 — ap-southeast-1
}

variable "instance_type" {
  description = "EC2 instance type (t2.micro is free-tier eligible)"
  type        = string
  default     = "t2.micro"
}

variable "key_pair_name" {
  description = "Name of the EC2 key pair (must exist in AWS console first)"
  type        = string
}

variable "allowed_ssh_cidr" {
  description = "Your IP CIDR allowed to SSH into public EC2 instances"
  type        = string
  default     = "0.0.0.0/0" # Restrict to your IP in production: e.g. 203.0.113.5/32
}

# ──────────────────────────────────────────────
# Storage
# ──────────────────────────────────────────────
variable "s3_bucket_name" {
  description = "Globally unique name for the application S3 bucket"
  type        = string
}

variable "dynamodb_table_name" {
  description = "Name for the application DynamoDB table"
  type        = string
  default     = "app-data"
}
