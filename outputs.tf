output "vpc_id" {
  description = "ID of the created VPC"
  value       = module.vpc.vpc_id
}

output "public_subnet_ids" {
  description = "IDs of the public subnets"
  value       = module.vpc.public_subnet_ids
}

output "private_subnet_ids" {
  description = "IDs of the private subnets"
  value       = module.vpc.private_subnet_ids
}

output "ec2_public_ips" {
  description = "Public IPs of EC2 instances in public subnets"
  value       = module.ec2.public_ips
}

output "ec2_instance_ids" {
  description = "Instance IDs of EC2 instances"
  value       = module.ec2.instance_ids
}

output "s3_bucket_name" {
  description = "Name of the application S3 bucket"
  value       = module.storage.s3_bucket_name
}

output "dynamodb_table_name" {
  description = "Name of the application DynamoDB table"
  value       = module.storage.dynamodb_table_name
}
