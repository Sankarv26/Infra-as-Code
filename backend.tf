terraform {
  backend "s3" {
    # -------------------------------------------------------------
    # Replace these values with your own before running terraform init
    # -------------------------------------------------------------
    bucket         = "sankar-github-bucket"        # S3 bucket you created manually
    key            = "global/terraform.tfstate"
    region         = "us-east-1"
    dynamodb_table = "terraform-lock"              # DynamoDB table you created manually
    encrypt        = true
  }
}
