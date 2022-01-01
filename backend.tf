terraform {
    backend "s3" {
        bucket = "sherry-tf-state"
        key    = "terraform.tfstate"
        region = "us-west-2"
        dynamodb_table = "terraformstate"
  }
}