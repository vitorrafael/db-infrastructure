terraform {
  backend "s3" {
    bucket = "tcl-terraform-bucket-apresentacao-ana"
    key    = "soat8-g6/backend/terraform.tfstate"
    region = "us-east-1"
  }
}