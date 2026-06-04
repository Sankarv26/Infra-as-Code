output "instance_ids" {
  description = "IDs of the EC2 instances"
  value       = aws_instance.public[*].id
}

output "public_ips" {
  description = "Public IP addresses of the EC2 instances"
  value       = aws_instance.public[*].public_ip
}

output "security_group_id" {
  description = "ID of the EC2 security group"
  value       = aws_security_group.ec2_public.id
}
