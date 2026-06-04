# ──────────────────────────────────────────────
# S3 Bucket (application data)
# ──────────────────────────────────────────────
resource "aws_s3_bucket" "app" {
  bucket = var.s3_bucket_name

  # Prevent accidental deletion in all environments
  lifecycle {
    prevent_destroy = false # Set to true for prod
  }

  tags = {
    Name = var.s3_bucket_name
  }
}

# Block all public access — buckets are private by default
resource "aws_s3_bucket_public_access_block" "app" {
  bucket = aws_s3_bucket.app.id

  block_public_acls       = true
  block_public_policy     = true
  ignore_public_acls      = true
  restrict_public_buckets = true
}

# Enable versioning — protects against accidental overwrites/deletes
resource "aws_s3_bucket_versioning" "app" {
  bucket = aws_s3_bucket.app.id

  versioning_configuration {
    status = "Enabled"
  }
}

# Server-side encryption at rest using AES-256 (free)
resource "aws_s3_bucket_server_side_encryption_configuration" "app" {
  bucket = aws_s3_bucket.app.id

  rule {
    apply_server_side_encryption_by_default {
      sse_algorithm = "AES256"
    }
  }
}

# ──────────────────────────────────────────────
# DynamoDB Table (application data)
# ──────────────────────────────────────────────
resource "aws_dynamodb_table" "app" {
  name         = var.dynamodb_table_name
  billing_mode = "PAY_PER_REQUEST" # On-demand — free tier covers 25 WCU/RCU; no provisioning needed

  # Primary key — adjust attribute name/type to match your data model
  hash_key = "PK"

  attribute {
    name = "PK"
    type = "S" # S = String, N = Number, B = Binary
  }

  # Optional sort key — uncomment if your access patterns need it
  # range_key = "SK"
  # attribute {
  #   name = "SK"
  #   type = "S"
  # }

  # Point-in-time recovery — free, highly recommended
  point_in_time_recovery {
    enabled = true
  }

  # Encryption at rest using AWS managed key (free)
  server_side_encryption {
    enabled = true
  }

  tags = {
    Name = var.dynamodb_table_name
  }
}
