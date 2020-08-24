provider "aws" {
  region                  = "ap-south-1"
  shared_credentials_file = "/Users/sanjayv/.aws/credentials"
  profile                 = "user1"
}

module "vpc" {
  source = "./modules/networking"

  cidr_vpc           = "10.1.0.0/16"
  availability_zones = ["ap-south-1a", "ap-south-1b"]
  tags = {
    "Name" = "Created From Terraform"
  }
}

backend "s3" {
  bucket = "tf-learn-sample"
  key = "state"
  dynamodb_table = "tf-learn-sample"
}

