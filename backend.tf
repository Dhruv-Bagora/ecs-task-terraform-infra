terraform {
  backend "s3" {
    bucket = "task-backend-bucket"
    key    = "task/terraform.tfstate"
    region = "us-west-1"
  }
}
