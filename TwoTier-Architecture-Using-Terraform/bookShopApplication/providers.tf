# terraform {
#   required_providers {
#     aws = {
#         source = "harshicorp/aws"
#         version = "5.31"
#     }
#   }
# }

provider "aws" {
  region = var.applicationRegion
}