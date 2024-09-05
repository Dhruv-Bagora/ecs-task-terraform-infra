terraform {
  backend "s3" {
    bucket = "test-again-bucket-xyz"
    key    = "task/terraform.tfstate"
    region = "us-west-1"
  }
}
