# ──────────────────────────────────────────────
# Security Group for public EC2 instances
# ──────────────────────────────────────────────
resource "aws_security_group" "ec2_public" {
  name        = "${var.project_name}-${var.environment}-ec2-public-sg"
  description = "Allow SSH and HTTP/HTTPS inbound; all outbound"
  vpc_id      = var.vpc_id

  # SSH — restrict to your IP in production (see allowed_ssh_cidr variable)
  ingress {
    description = "SSH"
    from_port   = 22
    to_port     = 22
    protocol    = "tcp"
    cidr_blocks = [var.allowed_ssh_cidr]
  }

  # HTTP
  ingress {
    description = "HTTP"
    from_port   = 80
    to_port     = 80
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  # HTTPS
  ingress {
    description = "HTTPS"
    from_port   = 443
    to_port     = 443
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  # All outbound allowed (needed for yum/apt updates, S3, DynamoDB API calls)
  egress {
    description = "All outbound"
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }

  tags = {
    Name = "${var.project_name}-${var.environment}-ec2-public-sg"
  }
}

# ──────────────────────────────────────────────
# EC2 Instances — one per public subnet
# ──────────────────────────────────────────────
resource "aws_instance" "public" {
  count = length(var.public_subnet_ids)

  ami                         = var.ami_id
  instance_type               = var.instance_type
  subnet_id                   = var.public_subnet_ids[count.index]
  vpc_security_group_ids      = [aws_security_group.ec2_public.id]
  key_name                    = var.key_pair_name
  associate_public_ip_address = true

  # Root volume — 8 GB is free-tier eligible (up to 30 GB gp2/gp3)
  root_block_device {
    volume_type           = "gp3"
    volume_size           = 8
    delete_on_termination = true
    encrypted             = true

    tags = {
      Name = "${var.project_name}-${var.environment}-ec2-${count.index + 1}-root"
    }
  }

  # User data: basic hardening + install SSM agent for console access
  user_data = <<-EOF
    #!/bin/bash
    yum update -y
    yum install -y amazon-ssm-agent
    systemctl enable amazon-ssm-agent
    systemctl start amazon-ssm-agent
  EOF

  tags = {
    Name = "${var.project_name}-${var.environment}-ec2-public-${count.index + 1}"
    AZ   = "subnet-${count.index + 1}"
  }
}
