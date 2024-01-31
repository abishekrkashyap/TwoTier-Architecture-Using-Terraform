terraform {
  backend "s3" {
    bucket = "terraformbackend-storage"
    key = "infrastructure/bookShopApplication.tfstate"
    region = "us-east-1"
    dynamodb_table = "terraformstate-locking"
  }
}