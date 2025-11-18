terraform {
  backend "s3" {
    bucket         = "terraform-states-driver"
    key            = "web/dev/terraform.tfstate"
    region         = "us-east-1"
    dynamodb_table = "terraform-locks"
    encrypt        = true
  }
}

