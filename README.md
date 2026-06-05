# Terraform AWS Infrastructure — AP Southeast

Modular Terraform IaC for AWS (ap-southeast-1) with VPC, public/private subnets,
EC2 instances, S3, and DynamoDB. Free-tier optimised.

## Architecture

```
Internet
    │
Internet Gateway
    │
VPC: 10.0.0.0/16
├── Public Subnet 1a  (10.0.1.0/24)  — EC2 t2.micro
├── Public Subnet 1b  (10.0.2.0/24)  — EC2 t2.micro
├── Private Subnet 1a (10.0.3.0/24)  — isolated (local VPC only)
└── Private Subnet 1b (10.0.4.0/24)  — isolated (local VPC only)

S3 Bucket       — versioned, encrypted, private
DynamoDB Table  — on-demand billing, PITR enabled
```

## Pre-requisites (one-time manual steps)

1. **AWS Account** — free tier at https://aws.amazon.com
2. **IAM user** — create in IAM console with AdministratorAccess + programmatic access
3. **AWS CLI** — `aws configure` with your access key + region `ap-southeast-1`
4. **Terraform CLI** — v1.6+ from https://developer.hashicorp.com/terraform/install
5. **S3 state bucket** — create manually: `myproject-tfstate-ap` (enable versioning)
6. **DynamoDB lock table** — create manually: `terraform-lock`, partition key `LockID` (String)
7. **EC2 Key Pair** — create in EC2 console → Key Pairs, download the `.pem`, `chmod 400` it

## Quick Start

```bash
# 1. Clone and enter the project
cd terraform-infra

# 2. Copy and edit your variables
cp terraform.tfvars.example terraform.tfvars   # edit with your values

# 3. Update backend.tf with your S3 bucket name, then:
terraform init

# 4. Preview what will be created
terraform plan

# 5. Apply
terraform apply

# 6. SSH into a public EC2 instance
ssh -i ~/.ssh/my-keypair.pem ec2-user@<public_ip_from_output>

# 7. Tear down when done (saves cost)
terraform destroy
```

## Module Reference

| Module | What it creates |
|---|---|
| `modules/vpc` | VPC, IGW, 2 public + 2 private subnets, route tables |
| `modules/ec2` | Security group, 2 × EC2 t2.micro in public subnets |
| `modules/storage` | S3 bucket (versioned + encrypted), DynamoDB table |

## Free Tier Notes

- EC2: t2.micro — 750 hrs/month free (enough for 1 always-on instance)
- S3: 5 GB storage free; versioning has no extra cost
- DynamoDB: 25 GB + 25 RCU/WCU free per month (on-demand mode stays within this for dev)
- No NAT Gateway — private subnets are truly isolated (no internet cost)

## Tagging Strategy

All resources are tagged via `provider default_tags`:

| Tag | Value |
|---|---|
| Project | your project_name variable |
| Environment | dev / staging / prod |
| ManagedBy | terraform |
| Owner | your owner_email variable |
| Region | aws_region |

Additional `Name` tags are applied per-resource inside each module.